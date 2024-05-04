function Camera () constructor begin
	
end

camera = {
	x: 0, y: 0, z: 0,
	cx: 0, cy: 0, cz: 0,
	pitch: 0,
	yaw: 0,
	roll: 0,
	get_matrix: function () {
		var mat = [1,0,0,0, 0,1,0,0, 0,0,1,0, cx+x,cy+y,cz+z,1];
		mat = matrix_multiply(mat, matrix_build(0,0,0, 0,0,roll, 1,1,1));
		mat = matrix_multiply(mat, matrix_build(0,0,0, pitch, yaw, 0, 1,1,1));
		return mat;
	},
	set_rotation: function (_pitch, _yaw, _roll)
	{
		pitch = clamp(_pitch, -90, 90);
		
		yaw = _yaw;
		
		if (yaw > 360)
		{
			yaw -= 360;
		}
		
		if (yaw < 0)
		{
			yaw += 360;
		}
		
		roll = _roll;
	},
	rotate: function (_dp, _dy, _dr) {
		self.set_rotation(pitch + _dp, yaw + _dy, roll + _dr);
	},
	get_pos_real: function ()
	{
		return [-(cx+x), -(cy+y), -(cz+z)];
	}
}