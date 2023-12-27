function ButterText( options ) : ButterElement( options ) constructor {
	
	text = options[$ "text"] ?? "";
	halign = options[$ "halign"] ?? fa_left;
	valign = options[$ "valign"] ?? fa_top;
	
	static _drawHook = function(xoffset, yoffset) {
		draw_set_halign( halign );
		draw_set_valign( valign );
		draw_set_color( colour );
		draw_text_ext( x+xoffset,y+yoffset, text, -1, width );
	}
}