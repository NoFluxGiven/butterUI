// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro BUTTER_FLOW_TOPBOTTOM 0
#macro BUTTER_FLOW_BOTTOMTOP 0
#macro BUTTER_FLOW_LEFTRIGHT 1
#macro BUTTER_FLOW_RIGHTLEFT 2

function ButterUi() constructor {
	screens = {};
	currentScreen = "";
	
	function addScreen( name, screen ) {
		screens[$ name] = screen;
		return self;
	}
	
	function setScreen( name ) {
		currentScreen = name;
	}
	
	function step() {
		var screen = screens[$ currentScreen];
		if ( screen == undefined ) exit;
			
		var children = screen.children;
			
		for (var c=0;c<array_length(children);c++) {
			var child = children[c];
				
			child._step();
		}
	}
	
	function draw() {
		var screen = screens[$ currentScreen];
		if ( screen == undefined ) exit;
			
		var children = screen.children;
			
		for (var c=0;c<array_length(children);c++) {
			var child = children[c];
				
			child._draw();
		}
	}
}

