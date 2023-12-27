// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function smoothLerp(key, newValue, options={}){
	if ( self[$ key] == newValue ) return undefined;
	return lerp( self[$ key], newValue, 0.25 );
}