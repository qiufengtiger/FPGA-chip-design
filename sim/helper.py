# convert int list to binary list, in reversed order to facilitate scanning
#                     index 0  1                  MSB
# example: [2, 0, 1, 3] -> [0, 1, 0, 0, 1, 0, 1, 1]
# reg[1:0] => 10
def int_list_to_bitstream(input_list, bit_length):
	format_string = "{0:0%db}" % bit_length
	binary = [format_string.format(item) for item in input_list]
	binary = [list(item)[::-1] for item in binary]
	binary = sum(binary, [])
	binary = [int(item) for item in binary]
	return binary

# example: [1, 0, 1, 0] -> 5
def bin_list_to_int_little_endian(input_list):
	return int("".join(str(i) for i in input_list[::-1]), 2)