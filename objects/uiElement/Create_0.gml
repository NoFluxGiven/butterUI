ui = new ButterUi();

var b = new ButterElement( {
	x: 60,
	y: 60,
	width: 50,
	height: 50,
	sprite: sprUiElement,
	onClick: function( event ) {
		animate( "width", irandom_range(1,20)*40,  smoothLerp );
		animate( "height", irandom_range(1,20)*40, smoothLerp );
		animate( "x", irandom_range(1,90)*10,      smoothLerp );
		animate( "y", irandom_range(1,50)*10,      smoothLerp );
	},
	onHover: function( event ) {
		colour = c_orange;
	},
	onUnhover: function( event ) {
		colour = c_white;
	}
} );

	var t = new ButterText( {
		x: "50%",
		y: "50%",
		width: 200,
		height: 200,
		halign: fa_center,
		valign: fa_middle,
		text: "New Game"
	} );

b.addChild( t );

var screen = new ButterScreen({
	children: [
		b
	]
});

ui.addScreen( "main_menu", screen );
ui.setScreen( "main_menu" );