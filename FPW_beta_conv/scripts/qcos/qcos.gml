///@arg degrees
function qcos(argument0) {
	var ang = argument0 / (2*pi);
	var si = frac(1. - ang * 2.) * 2. - 1.;
	var so = sign(.5 - frac(.5 - ang));
	return (20. / (si * si + 4.) - 4.) * so;



}
