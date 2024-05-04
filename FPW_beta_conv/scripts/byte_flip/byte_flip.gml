///@arg byte
function byte_flip(argument0) {
	var byte = argument0 & $FF;
	return 0 
		| ((byte & $01) << 7) 
		| ((byte & $02) << 5)
		| ((byte & $04) << 3)
		| ((byte & $08) << 1)
		| ((byte & $10) >> 1)
		| ((byte & $20) >> 3)
		| ((byte & $40) >> 5)
		| ((byte & $80) >> 7);



}
