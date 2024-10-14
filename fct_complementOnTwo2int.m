function b = fct_complementOnTwo2int(a, bitWidth)

  b = zeros(size(a));
  it = bitWidth;
  
  while (2^it - 1) < max(max(a))
    it = it + 1;
  end
  
  if (2^bitWidth - 1) < max(max(a))
    fprintf("[fct_complementOnTwo2int] WARNING specified bit width is to small...\n");
    fprintf("[fct_complementOnTwo2int] WARNING bit width is been set from %d to %d...\n", bitWidth, it);
  end

  bitWidth = it;
  it = 0;
  
  while it < (bitWidth - 1);
    b = b + mod(a,2) .* 2^it;
    a = (a - mod(a,2)) ./ 2;
    it = it + 1;
  end
  
  b = b - a * 2^(bitWidth - 1);

end

