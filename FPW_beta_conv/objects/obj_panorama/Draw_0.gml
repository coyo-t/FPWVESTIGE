//gpu_push_state();
////shader_send("stretch", stretch);
////shader_send("compress", compress);
//gpu_set_texfilter(true);

//event_inherited();

//shader_reset();
//gpu_pop_state();

gpu_push_state();
shader_set(shader_name);
shader_send("stretch", stretch);
shader_send("compress", compress);
gpu_set_texfilter(true);

event_inherited();

shader_reset();
gpu_pop_state();
