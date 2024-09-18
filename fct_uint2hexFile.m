function retvar = fct_uint2hexFile(inpVal, bitWidth, fName)

  keepGoing = 0;
  lenDat    = prod(size(inpVal));
  retvar    = -1;
  sep       = 32;


  if min(inpVal) < 0
    fprintf("[uint2hexFile] WARNING: data contains negative values!\n");
    fprintf("[uint2hexFile] WARNING: negative values are set to 0!\n");
    inpVal = inpVal .* (inpVal >= 0);
  end

  tmp = max(max(inpVal));

  if 2^bitWidth-1 < tmp
    fprintf("[uint2hexFile] WARNING: max input value = %d!\n", tmp);
    fprintf("[uint2hexFile] WARNING: %d bits max value = %d\n", bitWidth, 2^bitWidth-1);
    bitWidth = 0;

    while 2^bitWidth-1 < tmp
      bitWidth = bitWidth + 1;
    end

    fprintf("[uint2hexFile] WARNING: bit width is been changed to %d bits!\n", bitWidth);
  end

  if mod(bitWidth, 4) ~= 0
    lenLine = (bitWidth + 4 - mod(bitWidth,4)) / 4;
  else
    lenLine = bitWidth / 4;
  end

  clmns = length(inpVal(1,:));

  nLines = length(inpVal(:,1));
  nClmns = (lenLine + 1) * clmns;

  retvar = char(sep * ones(nLines, nClmns));

  it = 1;
  jt = 1;

  while it < nClmns
  retvar(:,it:it + lenLine - 1) = dec2hex(inpVal(:,jt), lenLine);
  it = it + lenLine + 1;
  jt = jt + 1;
  end

  retvar(:,end) = char(10);
  retvar = char(fct_flattenMatrix(double(retvar)));

  fid = fopen(fName, "w");
  fprintf(fid, "%s", retvar);
  fclose(fid);

end
