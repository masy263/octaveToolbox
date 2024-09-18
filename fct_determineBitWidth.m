function bitWidth = fct_determineBitWidth(A)

  bitWidth = 0;

  while (2^bitWidth - 1) < max(max(A))
    bitWidth = bitWidth + 1;
  end

end