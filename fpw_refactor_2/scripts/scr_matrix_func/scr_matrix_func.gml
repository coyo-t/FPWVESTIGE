globalvar LOOKFORWARDS;
LOOKFORWARDS = matrix_build_lookat(0,0,0, 0,0,1, 0,1,0);

globalvar identity_matrix;
identity_matrix = matrix_build_identity();

#region matrix stacks
function MatrixStack (_type) constructor begin
	__stack = [];
	__backburner = [];
	__curr = identity_matrix;
	__changed = false;
	type = -1;
	if (_type == matrix_world || _type == matrix_view || _type == matrix_projection)
	{
		type = _type;
	}
	
	// stack-y funcs
	///@func push(matrix)
	static push = function (_mat)
	{
		__changed = true;
		array_push(__stack, _mat);
		return self;
	}
	
	///@func pop()
	static pop = function ()
	{
		__changed = true;
		return array_pop(__stack);
	}
	
	///@func bot()
	static bot = function ()
	{
		if (!__changed)
		{
			return __curr;
		}
		var m = identity_matrix;
		
		var l = array_length(__stack);
		for (var i = 0; i < l;)
		{
			m = matrix_multiply(m, __stack[i++]);
		}
		
		__changed = false;
		__curr =  m;
		
		return m;
	}
	
	// queue-y funcs
	///@func queue(mat)
	static queue = function (_mat)
	{
		__changed = true;
		array_insert(__stack, 0, _mat);
		return self;
	}
	
	///@func dequeue()
	static dequeue = function ()
	{
		__changed = true;
		var m = __stack[0];
		array_delete(__stack, 0, 1);
		return m;
	}
	
	///@func top()
	static top = function ()
	{
		if (!__changed)
		{
			return __curr;
		}
		
		var m = identity_matrix;
		
		for (var i = array_length(__stack) - 1; i >= 0;)
		{
			m = matrix_multiply(m, __stack[i--]);
		}
		
		__changed = false;
		__curr = m;
		
		return m;
	}
	
	///@func push_stack([_new])
	static push_stack = function (_new)
	{
		array_push(__backburner, get_stack());
		
		if (!is_undefined(_new))
		{
			set(_new);
			return self;
		}

		clear();
		return self;
	}
	
	///@func pop_stack() 
	static pop_stack = function ()
	{
		__changed = true;
		__stack = array_pop(__backburner);
		apply();
	}
	
	///@func get_stack()
	static get_stack = function ()
	{
		var len = array_length(__stack)
		var _a = array_create(len);
		array_copy(_a, 0, __stack, 0, len);
		return _a;
	}
	
	///@func clear()
	static clear = function ()
	{
		__changed = false;
		__stack = [identity_matrix];
		__curr = identity_matrix;
		__set_real(identity_matrix);
		return self;
	}
	
	///@func apply()
	static apply = function ()
	{
		__set_real(top());
		return self;
	}
	
	static __set_real = function (_mat)
	{
		if (type != -1)
		{
			matrix_set(type, _mat);
		}
	}
	
	///@func set(matrix, [type])
	static set = function (_mat, _type)
	{
		__curr = _mat;
		__changed = false;
		__stack = [_mat];
		
		if (!is_undefined(_type))
		{
			matrix_set(_type, _mat);
			return self;
		}
		__set_real(_mat);
		return self;
	}
	
	///@func mul(mat)
	static mul = function (_mat)
	{
		var tm = top();
		push(_mat);
		set(matrix_multiply(_mat, tm));
		return self;
	}
	
	///@func get()
	static get = function ()
	{
		if (type != -1)
		{
			return matrix_get(type);
		}
		
		return identity_matrix;
	}
end

#endregion

function matrix_get_modelview ()
{
	return matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view));
}

///@arg matrix_a
///@arg matrix_b
///@arg factor
function matrix_mix (mat1, mat2, fac)
{
	// could be done with loops, manual for speed
	// also this is kinda useless. oops
	var fbc = 1. - fac;
	
	return [
		(mat1[0] * fbc) + (mat2[0] * fac),
		(mat1[1] * fbc) + (mat2[1] * fac),
		(mat1[2] * fbc) + (mat2[2] * fac),
		(mat1[3] * fbc) + (mat2[3] * fac),
		
		(mat1[4] * fbc) + (mat2[4] * fac),
		(mat1[5] * fbc) + (mat2[5] * fac),
		(mat1[6] * fbc) + (mat2[6] * fac),
		(mat1[7] * fbc) + (mat2[7] * fac),
		
		(mat1[8] * fbc) + (mat2[8] * fac),
		(mat1[9] * fbc) + (mat2[9] * fac),
		(mat1[10] * fbc) + (mat2[10] * fac),
		(mat1[11] * fbc) + (mat2[11] * fac),
		
		(mat1[12] * fbc) + (mat2[12] * fac),
		(mat1[13] * fbc) + (mat2[13] * fac),
		(mat1[14] * fbc) + (mat2[14] * fac),
		(mat1[15] * fbc) + (mat2[15] * fac)
	];
}

///@arg x
///@arg y
///@arg z
function matrix_build_position (_x, _y, _z)
{
	return [
		1,  0,  0,  0,
		0,  1,  0,  0,
		0,  0,  1,  0,
		_x, _y, _z, 1
	];
}

///@arg x_scale
///@arg y_scale
///@arg z_scale
function matrix_build_scale (_xs, _ys, _zs)
{
	return [
		_xs, 0,   0,   0,
		0,   _ys, 0,   0,
		0,   0,   _zs, 0,
		0,   0,   0,   1
	];
}

///@arg x
///@arg y
///@arg z
///@arg x_scale
///@arg y_scale
///@arg z_scale
function matrix_build_ps (_x, _y, _z, _xs, _ys, _zs)
{
	return [
		_xs, 0,   0,   0,
		0,   _ys, 0,   0,
		0,   0,   _zs, 0,
		_x,  _y,   _z, 1
	];
}


///@desc xz and yz are 2d H and V respectively. [distorted axis][pivot axis]
///@arg xz
///@arg yz
///@arg zx
///@arg zy
function matrix_build_skew (_xz, _yz, _zx, _zy)
{
	return [
		1,   _yz, _zy, 0,
		_xz, 1,   _zx, 0,
		0,   0,   1,   0,
		0,   0,   0,   1
	];
}

///@arg x_offset
///@arg y_offset
function matrix_build_offset (_xo, _yo)
{
	return [
		1, 0, 0, 0,
		0, 1, 0, 0,
		_xo, _yo, 1, 0,
		0, 0, 0, 1
	]
}


function matrix_duplicate (mat)
{
	//var m = array_create(16);
	//m[@ 0]  = mat[0];  m[@ 1]  = mat[1];  m[@ 2]  = mat[2];  m[@ 3]  = mat[3];
	//m[@ 4]  = mat[4];  m[@ 5]  = mat[5];  m[@ 6]  = mat[6];  m[@ 7]  = mat[7];
	//m[@ 8]  = mat[8];  m[@ 9]  = mat[9];  m[@ 10] = mat[10]; m[@ 11] = mat[11];
	//m[@ 12] = mat[12]; m[@ 13] = mat[13]; m[@ 14] = mat[14]; m[@ 15] = mat[15];
	var m = array_create(16);
	array_copy(m, 0, mat, 0, 16);
	
	return m;
}


function matrix_string (m)
{
	var s = string;
	return (
		"["+s(m[0 ])+", "+s(m[1 ])+", "+s(m[2 ])+", "+s(m[3 ])+"]\n"+
		"["+s(m[4 ])+", "+s(m[5 ])+", "+s(m[6 ])+", "+s(m[7 ])+"]\n"+
		"["+s(m[8 ])+", "+s(m[9 ])+", "+s(m[10])+", "+s(m[11])+"]\n"+
		"["+s(m[12])+", "+s(m[13])+", "+s(m[14])+", "+s(m[15])+"]"
	);
	
}


function matrix_string_prec (m, p)
{
	var s = string_format;
	return (
		"["+s(m[0 ], 0, p)+", "+s(m[1 ], 0, p)+", "+s(m[2 ], 0, p)+", "+s(m[3 ], 0, p)+"]\n"+
		"["+s(m[4 ], 0, p)+", "+s(m[5 ], 0, p)+", "+s(m[6 ], 0, p)+", "+s(m[7 ], 0, p)+"]\n"+
		"["+s(m[8 ], 0, p)+", "+s(m[9 ], 0, p)+", "+s(m[10], 0, p)+", "+s(m[11], 0, p)+"]\n"+
		"["+s(m[12], 0, p)+", "+s(m[13], 0, p)+", "+s(m[14], 0, p)+", "+s(m[15], 0, p)+"]"
	);
	
}

///@arg mat
function matrix_transpose (m)
{
	// 0  1  2  3
	// 4  5  6  7
	// 8  9  10 11
	// 12 13 14 15
	// 
	// 0  4  8  12
	// 1  5  9  13
	// 2  6  10 14
	// 3  7  11 15
	
	return [
		m[0],  m[4],  m[8],  m[12],
		m[1],  m[5],  m[9],  m[13],
		m[2],  m[6],  m[10], m[14],
		m[3],  m[7],  m[11], m[15]
	];
}


///@arg matrix
function matrix_inverse (m)
{
	var inv = array_create(16);
	
	inv[0] = (
		m[5]  * m[10] * m[15] - 
		m[5]  * m[11] * m[14] - 
		m[9]  * m[6]  * m[15] + 
		m[9]  * m[7]  * m[14] +
		m[13] * m[6]  * m[11] - 
		m[13] * m[7]  * m[10]
	);

	inv[4] = (
		-m[4]  * m[10] * m[15] + 
		m[4]   * m[11] * m[14] + 
		m[8]   * m[6]  * m[15] - 
		m[8]   * m[7]  * m[14] - 
		m[12]  * m[6]  * m[11] + 
		m[12]  * m[7]  * m[10]
	);

	inv[8] = (
		m[4]  * m[9]  * m[15] - 
		m[4]  * m[11] * m[13] - 
		m[8]  * m[5]  * m[15] + 
		m[8]  * m[7]  * m[13] + 
		m[12] * m[5]  * m[11] - 
		m[12] * m[7]  * m[9]
	);

	inv[12] = (
		-m[4] * m[9]  * m[14] + 
		m[4]  * m[10] * m[13] +
		m[8]  * m[5]  * m[14] - 
		m[8]  * m[6]  * m[13] - 
		m[12] * m[5]  * m[10] + 
		m[12] * m[6]  * m[9]
	);
	
	//
	inv[1] = (
		-m[1] * m[10] * m[15] + 
		m[1]  * m[11] * m[14] + 
		m[9]  * m[2]  * m[15] - 
		m[9]  * m[3]  * m[14] - 
		m[13] * m[2]  * m[11] + 
		m[13] * m[3]  * m[10]
	);

	inv[5] = (
		m[0]  * m[10] * m[15] - 
		m[0]  * m[11] * m[14] - 
		m[8]  * m[2]  * m[15] + 
		m[8]  * m[3]  * m[14] + 
		m[12] * m[2]  * m[11] - 
		m[12] * m[3]  * m[10]
	);

	inv[9] = (
		-m[0] * m[9]  * m[15] + 
		m[0]  * m[11] * m[13] + 
		m[8]  * m[1]  * m[15] - 
		m[8]  * m[3]  * m[13] - 
		m[12] * m[1]  * m[11] + 
		m[12] * m[3]  * m[9]
	);

	inv[13] = (
		m[0]  * m[9]  * m[14] - 
		m[0]  * m[10] * m[13] - 
		m[8]  * m[1]  * m[14] + 
		m[8]  * m[2]  * m[13] + 
		m[12] * m[1]  * m[10] - 
		m[12] * m[2]  * m[9]
	);
	
	//
	inv[2] = (
		m[1]  * m[6] * m[15] - 
		m[1]  * m[7] * m[14] - 
		m[5]  * m[2] * m[15] + 
		m[5]  * m[3] * m[14] + 
		m[13] * m[2] * m[7]  - 
		m[13] * m[3] * m[6]
	);

	inv[6] = (
		-m[0] * m[6] * m[15] + 
		m[0]  * m[7] * m[14] + 
		m[4]  * m[2] * m[15] - 
		m[4]  * m[3] * m[14] - 
		m[12] * m[2] * m[7]  + 
		m[12] * m[3] * m[6]
	);

	inv[10] = (
		m[0]  * m[5] * m[15] - 
		m[0]  * m[7] * m[13] - 
		m[4]  * m[1] * m[15] + 
		m[4]  * m[3] * m[13] + 
		m[12] * m[1] * m[7]  - 
		m[12] * m[3] * m[5]
	);

	inv[14] = (
		-m[0] * m[5] * m[14] + 
		m[0]  * m[6] * m[13] + 
		m[4]  * m[1] * m[14] - 
		m[4]  * m[2] * m[13] - 
		m[12] * m[1] * m[6]  + 
		m[12] * m[2] * m[5]
	);
	
	//
	inv[3] = (
		-m[1] * m[6] * m[11] + 
		m[1]  * m[7] * m[10] + 
		m[5]  * m[2] * m[11] - 
		m[5]  * m[3] * m[10] - 
		m[9]  * m[2] * m[7]  + 
		m[9]  * m[3] * m[6]
	);

	inv[7] = (
		m[0] * m[6] * m[11] - 
		m[0] * m[7] * m[10] - 
		m[4] * m[2] * m[11] + 
		m[4] * m[3] * m[10] + 
		m[8] * m[2] * m[7]  - 
		m[8] * m[3] * m[6]
	);

	inv[11] = (
		-m[0] * m[5] * m[11] + 
		m[0]  * m[7] * m[9]  + 
		m[4]  * m[1] * m[11] - 
		m[4]  * m[3] * m[9]  - 
		m[8]  * m[1] * m[7]  + 
		m[8]  * m[3] * m[5]
	);

	inv[15] = (
		m[0] * m[5] * m[10] - 
		m[0] * m[6] * m[9]  - 
		m[4] * m[1] * m[10] + 
		m[4] * m[2] * m[9]  + 
		m[8] * m[1] * m[6]  - 
		m[8] * m[2] * m[5]
	);

	var det = m[0] * inv[0] + m[1] * inv[4] + m[2] * inv[8] + m[3] * inv[12];
	
	if (det == 0)
	{
		return m;
	}

	det = 1. / det;
	
	var inv_out = [
		inv[0] * det,
		inv[1] * det,
		inv[2] * det,
		inv[3] * det,
		
		inv[4] * det,
		inv[5] * det,
		inv[6] * det,
		inv[7] * det,
		
		inv[8] * det,
		inv[9] * det,
		inv[10] * det,
		inv[11] * det,
		
		inv[12] * det,
		inv[13] * det,
		inv[14] * det,
		inv[15] * det,
	];

	return inv_out;
}


///@arg x
///@arg y
///@arg z
///@arg view_matrix
///@arg proj_matrix
function world_to_screen (_x, _y, _z, v, p)
{
	var sx, sy;
	
	// ortho
	sx = p[12] + p[0] * (v[0] * _x + v[4] * _y + v[8] * _z + v[12]);
	sy = p[13] + p[5] * (v[1] * _x + v[5] * _y + v[9] * _z + v[13]);
	var w = 1;
	
	// perspective
	if (p[15] == 0)
	{
		w = v[2] * _x + v[6] * _y + v[10] * _z + v[14];
		
		if (w == 0)
		{
			return [-infinity, -infinity, 1];
		}
		
		sx = p[8] + p[0] * (v[0] * _x + v[4] * _y + v[8] * _z + v[12]) / w;
		sy = p[9] + p[5] * (v[1] * _x + v[5] * _y + v[9] * _z + v[13]) / w;
		w = 1 / w;
	}
	
	//return [sx * .5 + .5, -sy * .5 + .5, w];
	return [sx, -sy, w];
}


///@arg angle_in_radians
function matrix_build_rotate_x (_angle) // pitch
{
	//_angle = degtorad(_angle);
	var sin_a = sin(_angle);
	var cos_a = cos(_angle);
	
	return [
		1, 0, 0,   0,
		0, cos_a, -sin_a, 0,
		0, sin_a,  cos_a, 0,
		0, 0,      0,     1
	];
}


///@arg angle_in_radians
function matrix_build_rotate_y (_angle) // yaw
{
	//_angle = degtorad(_angle);
	var sin_a = sin(_angle);
	var cos_a = cos(_angle);
	
	return [
		 cos_a, 0, sin_a, 0,
		 0,     1, 0,     0,
		-sin_a, 0, cos_a, 0,
		 0,     0, 0,     1
	];
}


///@arg angle_in_radians
function matrix_build_rotate_z (_angle) // roll
{
	//_angle = degtorad(_angle);
	var sin_a = sin(_angle);
	var cos_a = cos(_angle);
	
	return [
		cos_a, -sin_a, 0, 0,
		sin_a,  cos_a, 0, 0,
		0,      0,     1, 0,
		0,      0,     0, 1
	];
}