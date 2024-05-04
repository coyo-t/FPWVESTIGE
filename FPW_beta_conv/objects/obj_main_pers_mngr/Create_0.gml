/// @desc
//centre the player
obj_office_player.x = room_width * 0.5 - RESW * 0.5;

obs_to_keep = [
	obj_office_player
];


function set_pers (state) begin
	var size = array_size(obs_to_keep);
	for (var i = 0; i < size; i++)
	{
		var ob = obs_to_keep[i];
		ob.persistent = state;
		
	}
end
