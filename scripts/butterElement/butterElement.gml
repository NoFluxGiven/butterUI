function ButterElement( options={} ) constructor {
	
	x		  = options[$ "x"] ?? 0;
	y		  = options[$ "y"] ?? 0;
	
	basex	  = x;
	basey	  = y;
	
	sprite		  = options[$ "sprite"] ?? noone;
	subimage	  = options[$ "subimage"] ?? 0;
	rotation	  = options[$ "rotation"] ?? 0;
	colour	  = options[$ "colour"] ?? c_white;
	alpha	  = options[$ "alpha"] ?? 1;
	
	width	  = options[$ "width"]    ?? 0;
	height	  = options[$ "height"]   ?? 0;
	depth	  = options[$ "depth"]	  ?? 0;
	flow	  = options[$ "flow"]     ?? BUTTER_FLOW_LEFTRIGHT;
	children  = options[$ "children"] ?? [];
	parent	  = options[$ "parent"]   ?? undefined;
	
	animations = options[$ "animations"] ?? [];
	
	// Hover: Before being clicked, an element is hovered if the cursor
	// sits over it.
	// Click: When selected using a cursor or controller
	// Focus: After being clicked, an element is in focus
	
	onClick   = method( self, ( options[$ "onClick"]   ?? function(event) {} ) );
	onUnclick = method( self, ( options[$ "onUnclick"] ?? function(event) {} ) );
	onFocus	  = method( self, ( options[$ "onFocus"]   ?? function(event) {} ) );
	onUnfocus = method( self, ( options[$ "onUnfocus"] ?? function(event) {} ) );
	onInput	  = method( self, ( options[$ "onInput"]   ?? function(event) {} ) );
	onHover	  = method( self, ( options[$ "onHover"]   ?? function(event) {} ) );
	onUnhover = method( self, ( options[$ "onUnhover"] ?? function(event) {} ) );
	
	state = "idle";
	isFocused = false;
	
	inputHandler = options[$ "inputHandler"] ?? _inputHandler_default;
	animHandler  = options[$ "animHandler"] ??  _animHandler_default;
	
	static _animHandler_default = function() {
		for (var i=0; i<array_length(animations); i++) {
			var nim = animations[i];
			
			var e   = nim.enabled;
			if (!e) continue;
			
			var r   = nim.lambda( nim.key, nim.newValue, nim.options );
			
			if (r == undefined) {
				nim.enabled = false;
				continue;
			}
			
			self[$ nim.key] = r;
		}
	}
	
	static _inputHandler_default = function() {
		switch (state) {
			case "idle":
				if ( point_in_rectangle( mouse_x, mouse_y, x,y, x+width, y+height ) ) {
					state = "hovered_transition";
				}
				break;
			
			case "hovered_transition":
				onHover();
				state = "hovered";
				break;
			
			case "hovered":
				if ( !point_in_rectangle( mouse_x, mouse_y, x,y, x+width, y+height ) ) {
					state = "idle_transition";
					onUnhover();
				}
				if (mouse_check_button_pressed( mb_left )) {
					onClick();
					isFocused = true;
					onFocus();
				}
				if (mouse_check_button_released( mb_left )) {
					onUnclick();
				}
				break;
				
			case "idle_transition":
				state = "idle";
				break;
				
			
		}
		
	}
	
	static animate = function( key, newValue, animFunction, options={} ) {
		animations =  array_filter( animations, method( { key }, function( _x ) {
			return _x.key != key;
		} ) );
		array_push( animations, {
			key,
			newValue,
			lambda: method( self, animFunction ),
			options,
			enabled: true
		} );
	}
	
	static addChild = function( element ) {
		array_push( children, element );
		element.parent = self;
	}
	
	static _drawHook = function() {}
	
	static _step = function() {
		inputHandler();
		animHandler();
	}
	
	static _convertCoords = function( val, target ) {
		if (parent == undefined) {
			return real(val);
		}
		
		var targetVal = parent[$ target] ?? 0
		
		if ( is_string(val) && string_ends_with(val, "%") ) {
			return targetVal * ( real( string_replace( val, "%", "" ) ) / 100 );
		}
		
		return real(val);
	}
	
	static _draw = function(xoffset=0,yoffset=0) {
		x = _convertCoords( basex, "width" );
		y = _convertCoords( basey, "height" );
		
		if (sprite != noone) {
			var sprw = sprite_get_width( sprite ),
				sprh = sprite_get_height( sprite );
				
			draw_sprite_ext( sprite, subimage, x+xoffset,y+yoffset, width/sprw, height/sprh, rotation, colour, alpha );
		}
		
		_drawHook(xoffset, yoffset);
		
		for (var i=0;i<array_length(children);i++) {
			var child = children[i];
			
			// Draw the child with our current x/y + whatever offsets
			// other ancestors have applied.
			child._draw( x+xoffset, y+yoffset );
		}
	}
	
}