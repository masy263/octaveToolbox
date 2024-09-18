function ret = fct_normMatrix(A)

  ret = A ./ max(max(abs(A)));

end
