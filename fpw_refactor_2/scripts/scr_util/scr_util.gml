#macro BASEPATH            "./bin/"
//#macro Testing:BASEPATH    "./bin_dbg/"
//#macro SCREENSHOT_SAVE_LOC "C:/Users/Chymic/Pictures/gmDebugImg/"
#macro SCREENSHOT_SAVE_LOC @"D:\_images\gmDebugImg\fpw_2_2\"


function lerp_dt (value1, value2, fac) 
{
	return lerp(value1, value2, 1. - power(fac, DT));
}


function point_in_bbox (_x, _y)
{
	return point_in_rectangle(_x, _y, bbox_left, bbox_top, bbox_right, bbox_bottom);
}

///@arg fov_degrees
///@arg width
///@arg height
function fov_v2h (fov, width, height)
{
	return radtodeg(2. * arctan(tan(degtorad(fov) * .5) * (width / height)));
}


///@arg fov_degrees
///@arg width
///@arg height
function fov_h2v (fov, width, height)
{
	gml_pragma("forceinline");
	return fov_v2h(fov, height, width);
}
