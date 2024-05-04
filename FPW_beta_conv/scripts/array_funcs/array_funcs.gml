///@arg array
///@arg value
function array_push (arr, _x) begin
	arr[@ array_size(arr)] = _x;
end


///@arg array
///@arg index_a
///@arg index_b
function array_swap (arr, a, b) begin
	if (a == b) exit;

	var tmp = arr[a];
	arr[@a] = arr[b];
	arr[@b] = tmp;

end


function array_rand (arr) begin
	return arr[irandom(array_length(arr) - 1)];
end
