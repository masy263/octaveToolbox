bitWidth = 4;

it = 0;

while it < 16
  bitsIn = fct_uint2bin(it, bitWidth);
  invert1 = fct_binInversion(bitsIn);
  compl2 = fct_binAdd(invert1, fct_uint2bin(1, bitWidth), bitWidth);
  invert2 = fct_binInversion(compl2);
  bitsOut = fct_binAdd(invert2, fct_uint2bin(1, bitWidth), bitWidth);
  sum(bitsIn == bitsOut) == bitWidth
  it = it + 1;
end