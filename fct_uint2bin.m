function ret = fct_bin2uint(inpDat, bitWidth)

  % input data structure:
  % inpDat = [a11, a12; ...
  %           a21, a22]
  % output data structure:
  % ret = [bit_a11_bitWidth-1:bit_a11_0, bit_a12_bitWidth-1:bit_a12_0;
  %        bit_a21_bitWidth-1:bit_a21_0, bit_a22_bitWidth-1:bit_a22_0]

  floatCheck = mod(inpDat, 1);

  if sum(sum(floatCheck)) > 0
    fprintf("[fct_bin2uint] Input data is of type float. Post comma values are been killed.\n");
    inpDat = inpDat - floatCheck;
  end

  if 2^bitWidth-1 < max(max(inpDat))
    bitWidth = fct_determineBitWidth(max(max(inpDat)));
    fprintf("[fct_bin2uint] Bit width is to small. Set bit width to: %d.\n", bitWidth);
  end

  bitWidth       = max([bitWidth, fct_determineBitWidth(max(max(inpDat)))]);
  [lines, clmns] = size(inpDat);
  ret            = zeros(lines, bitWidth * clmns);
  it             = 0;

  while it < bitWidth
    jt = 0;

    while jt < clmns
      jt                          = jt + 1;
      ret(:,(bitWidth * jt) - it) = round(mod(inpDat(:,jt), 2));
      inpDat(:,jt)                = (inpDat(:,jt) - ret(:,(bitWidth * jt) - it)) ./ 2;
    end

    it = it + 1;
  end

end