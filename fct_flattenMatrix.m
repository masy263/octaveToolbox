function ret = fct_flattenMatrix(A)

  lines = length(A(:,1));
  clmns = length(A(1,:));
  ret   = zeros(1, lines * clmns);
  it    = 0;

  while it < clmns
    it = it + 1;
    ret(1, it:clmns:end) = [A(:,it)]';
  end

end
