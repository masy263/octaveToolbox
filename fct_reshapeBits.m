function ret = fct_reshapeBits(bits, bitWidth)

    lenBits = length(bits(1,:));
    lenBits = lenBits - mod(lenBits, bitWidth);
    bits    = bits(1,1:lenBits);
    ret     = reshape(bits, [bitWidth, lenBits / bitWidth])';

end