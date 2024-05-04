// name derived from my future d&d character, Cog of Mythril
// clockwork cat

enum CogFlag {
	has_texture = 1, //unused
	is_compressed = 2
};


///@arg vbuffer
///@arg format
function Model_Cog (_vbff, _vform) constructor begin
	vbuff = _vbff;
	vformat = _vform;
	prim_type = pr_trianglelist;
	sprite = -1;
	texture = -1;
	img_ind = 0;
	
	static free = function ()
	{
		//todo: add some function to check if this is the last case of a vertex
		//format being used. otherwise there will be a memory leak on our hands
		
		//also ffs deleting the struct somehow using the delete keyword
		//how tf do i do that
		//blaghdjafdhafhjdal
		vertex_delete_buffer(vbuff);
		
		if (sprite != -1)
			sprite_delete(sprite);
			
	}
	
	static draw = function (tex)
	{
		tex = tex == undefined ? texture : tex;
		
		vertex_submit(vbuff, prim_type, tex);
		
	}
	
	static set_sprite = function (spr)
	{
		sprite = spr;
		texture = sprite_get_texture(sprite, 0);
		
	}
	
	
	static update_texture = function (ind)
	{
		img_ind = ind;
		texture = sprite_get_texture(sprite, ind);
		
	}
	
end


function model_load_cog_path (path, freeze)
{
	path = BASEPATH + path;
	if (!file_exists(path)) return -1;
	
	var f = buffer_load(path);
	
	var result = model_load_cog(f, freeze);
	
	buffer_delete(f);
	
	return result;
	
}


function model_load_cog (f, freeze)
{
	// check the magic file id. fuck it if its not a cog file
	// er.. vertex buffer model... cog.. consta.. whatever???
	static expected_fid = $434D4256;
	
	if (buffer_read(f, buffer_u32) != expected_fid)
	{
		//buffer_delete(f);
		return -1;
	}
	
	// okay yeah its probably a cog model. continue
	// todo: abort if version is higher than our expected version
	// other todo: check if the model is just straight vbuffer data or if its separated out
	var version_id  = buffer_read(f, buffer_u16);
	var flags       = buffer_read(f, buffer_u16);
	var header_size = buffer_read(f, buffer_u16);
	
	if (flags & CogFlag.is_compressed)
	{
		var compress_start = buffer_tell(f);
		var zip_size = buffer_get_size(f) - compress_start;
		var zip = buffer_create(zip_size, buffer_fixed, 1);
		buffer_copy(f, compress_start, zip_size, zip, 0);
		
		var zz = buffer_decompress(zip);
		buffer_delete(zip);
		zip = zz;
		
		zip_size = buffer_get_size(zip);
		buffer_resize(f, compress_start + zip_size);
		buffer_copy(zip, 0, zip_size, f, compress_start);
		buffer_delete(zip);
		buffer_seek(f, buffer_seek_start, compress_start);
		
	}
	
	var tex_type  = buffer_read(f, buffer_u16);
	var tex_addr = buffer_read(f, buffer_u32);
	
	
	buffer_seek(f, buffer_seek_start, header_size);
	
	var vformat;
	{ //create the vertex format if needed
		var vertex_format_count = buffer_read(f, buffer_u8);
		var vformat_arr = [];
	
		repeat (vertex_format_count)
			array_push(vformat_arr, buffer_read(f, buffer_u8));
	
		vformat = vertex_format_create(vformat_arr);
	}
	
	var mdldata_size = buffer_read(f, buffer_u32);
	
	var vb;
	{
		var fvb = buffer_create(mdldata_size, buffer_fixed, 1);
		buffer_copy(f, buffer_tell(f), mdldata_size, fvb, 0);
	
		vb = vertex_create_buffer_from_buffer(fvb, vformat);
		buffer_delete(fvb);
		
	}
	
	
	if (freeze == undefined || freeze)
		vertex_freeze(vb);
	
	var cog = new Model_Cog(vb, vformat);
	
	switch (tex_type)
	{
		case StarType.none:
		case StarType.engine:
		break;
		
		case StarType.asset:
			buffer_seek(f, buffer_seek_start, tex_addr);
			var spr_index = asset_get_index(buffer_read(f, buffer_string));
		
			cog.sprite = spr_index;
		break;
		
		default:
			buffer_seek(f, buffer_seek_start, tex_addr);
			var spr = star_tex_decode(f);
			cog.set_sprite(spr);

		break;
		
	}
	
	//buffer_delete(f);
	
	return cog;
	
}


///@arg file_path
///@arg vertex_format
///@arg freeze
function model_load_vbm (path, vformat, freeze)
{
	var fpath = BASEPATH + path;
	
	if (!file_exists(fpath)) return -1;
	
	var bff = buffer_load(fpath);
	var mdl = vertex_create_buffer_from_buffer(bff, vformat);

	buffer_delete(bff);

	if (freeze == undefined || freeze) vertex_freeze(mdl);

	return mdl;
	
}
