function ret = fct_bitInversion(bits)

  if(sum(sum([bits == 0] + [bits == 1])) == prod(size(bits)))
    ret = bits .* -1 + 1;
  else
    ret = -1;
    fprintf("[fct_bitInversion] inp data includes values beside {0,1}\n");
  end

end