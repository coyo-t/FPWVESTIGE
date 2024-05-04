///@arg px
///@arg py
function point_in_bbox (argument0, argument1) begin
	return point_in_rectangle(argument0, argument1, bbox_left, bbox_top, bbox_right, bbox_bottom);
end


///@arg px
///@arg py
///@arg array
function point_in_bounds (argument0, argument1, argument2) begin
	var bnd = argument2;
	return point_in_rectangle(argument0, argument1, bnd[0], bnd[1], bnd[2], bnd[3]);

end


///@arg left
///@arg top
///@arg right
///@arg bottom
///@arg camera
function on_camera (bbox_l, bbox_t, bbox_r, bbox_b, _camera) begin
	var _c_box = [
		camera_get_view_x(_camera),
		camera_get_view_y(_camera),
		camera_get_view_x(_camera) + (camera_get_view_width(_camera) - 1),
		camera_get_view_y(_camera) + (camera_get_view_height(_camera) - 1)
	];

	return 
		(bbox_l <= _c_box[2] && bbox_r >= _c_box[0]) &&
		(bbox_t <= _c_box[3] && bbox_b >= _c_box[1]);

end


/////@arg x
/////@arg y
/////@arg ex
/////@arg ey
/////@arg rx
/////@arg ry
//function point_in_elipse (px, py, ex, ey, rx, ry) begin
//	return (pow(px - ex, 2) / pow(rx, 2)) + (pow(py - ey, 2) / pow(ry, 2)) >= 1;

//end

