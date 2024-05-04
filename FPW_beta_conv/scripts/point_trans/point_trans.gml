///@arg point_x
///@arg point_y
///@arg buffer
///@arg out_size_x
///@arg out_size_y
function point_trans(x_in, y_in, buff, out_w, out_h) {

	//todo, add interpolation between values?

	var trans_w = buffer_peek(buff, 0, buffer_u16);
	var trans_h = buffer_peek(buff, 2, buffer_u16);

	var point_x = (x_in / out_w) * trans_w;
	var point_y = (y_in / out_h) * trans_h;

	point_x = clamp(floor(point_x), 0, trans_w - 1);
	point_y = clamp(floor(point_y), 0, trans_h - 1);

	var peep = (point_x + point_y * trans_w) * 2;
	var offset = 4;

	return [
		(buffer_peek(buff, peep + offset,     buffer_u8) / $FF) * out_w,
		(buffer_peek(buff, peep + 1 + offset, buffer_u8) / $FF) * out_h
	];



}
