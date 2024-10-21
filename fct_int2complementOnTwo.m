function retvar = fct_int2complementOnTwo(A, B)

  % A - Array of integer values
  % B - Bitwidth

  retvar = A .* (A >= 0) + (A < 0) .* (2^B + A);

end