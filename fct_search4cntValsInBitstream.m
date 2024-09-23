function evalDat = fct_search4cntValsInBitstream(bitstream, bitWidth)

  data    = bitstream;
  it      = 0;
  evalDat = zeros(1,bitWidth);

  while it < bitWidth
    it            = it + 1;
    bitRegisters  = fct_reshapeBits(data, bitWidth);
    valueDat      = fct_bin2uint(bitRegisters);
    diffDat       = diff(valueDat);
    evalDat(1,it) = sum(diffDat == 1);
    data          = data(1,2:end);
  end

end