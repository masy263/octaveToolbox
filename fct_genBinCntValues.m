function bits = fct_genBinCntValues(bitWidth)

  nBit              = bitWidth;
  bits              = zeros(2^nBit, nBit);
  it = 0;

  while it < 2^nBit
    tmp = it;
    it = it + 1;
    jt = 0;

    while jt < nBit
      bits(it, nBit - jt) = mod(tmp, 2);
      tmp = tmp - mod(tmp, 2);
      tmp = tmp / 2;
      jt = jt + 1;
    end

  end

end

