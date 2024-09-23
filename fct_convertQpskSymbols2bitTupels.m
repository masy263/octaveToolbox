function ret = fct_convertQpskSymbols2bitTupels(symbols, constellation)

  ret      = zeros(length(symbols(:,1)),2);
  quarter  = zeros(length(symbols(:,1)),1);
  quarter  = quarter + 1 .* [((real(symbols)) > 0) .* ((imag(symbols)) > 0)];
  quarter  = quarter + 2 .* [((real(symbols)) < 0) .* ((imag(symbols)) > 0)];
  quarter  = quarter + 3 .* [((real(symbols)) < 0) .* ((imag(symbols)) < 0)];
  quarter  = quarter + 4 .* [((real(symbols)) > 0) .* ((imag(symbols)) < 0)];

  it = 0;

  while it < 4
    it = it + 1;
    ret(:,1) = ret(:,1) + (quarter == it) .* constellation(it,1);
    ret(:,2) = ret(:,2) + (quarter == it) .* constellation(it,2);
  end

end