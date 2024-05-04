/// @desc

var strs = [
	"Who put cheese in my cheese",
	"MEOOOOOOOWWWHAHAHAHAHAHAH",
	"Insert slur here.",
	"null terminatedn't",
	"biggith oofith"
];

save_data[? SAVEKEY_CYCLE] = strs[irandom(array_size(strs) - 1)];

plrdat_save();
