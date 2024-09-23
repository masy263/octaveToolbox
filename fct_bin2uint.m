function ret = fct_bin2uint(inpDat)

  nLines = length(inpDat(:,1));
  nClmns = length(inpDat(1,:));
  ret    = zeros(nLines, 1);

  it = 0;

  while it < nClmns
    ret = ret + inpDat(:,nClmns - it) .* 2^it;
    it = it + 1;
  end

end