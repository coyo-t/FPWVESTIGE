/// @desc
var last_ind = t_dialog_ind;

t_dialog_ind += dt() * 12;
t_dialog_ind = min(t_dialog_ind, t_dialog_len);

var is_same = floor(t_dialog_ind) == floor(last_ind);

if (!is_same)
{
	t_dialog_ind = floor(t_dialog_ind);
	
	on_new_ind();
	
}

//var delta = mouse_wheel_down() - mouse_wheel_up();

//t_dialog_ind += delta;
