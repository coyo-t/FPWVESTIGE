/// @desc enable z-testing
if (shader_current() != -1)
{
	shader_reset();
}

gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_alphatestref(0);
