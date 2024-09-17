function retvar = int2hexFile(inpVal, bitWidth, fName, datCheck)

  if datCheck > 0
    maxValInp = max(inpVal);
    maxValOut = 2^(bitWidth-1) - 1;
    minValInp = min(inpVal);
    minValOut = 2^(bitWidth-1);
    fprintf("[int2hexFile] kleinster Eingabewert:         %d\n", minValInp);
    fprintf("[int2hexFile] kleinstmoeglicher Ausgabewert: -%d\n", minValOut);
    fprintf("[int2hexFile] groesster Eingabewert:         %d\n", maxValInp);
    fprintf("[int2hexFile] groesstmoeglicher Ausgabewert: %d\n", maxValOut);
  end


  if mod(bitWidth, 4) ~= 0
    lenLine = (bitWidth + 4 - mod(bitWidth,4)) / 4;
  else
    lenLine = bitWidth / 4;
  end

  keepGoing = 0;
  lenDat    = 0;

  if length(inpVal(:,1)) == 1
    keepGoing = 1;
    lenDat    = length(inpVal(1,:));
    inpVal    = inpVal';
  else

    if length(inpVal(1,:)) == 1
      keepGoing = 1;
      lenDat    = length(inpVal(:,1));
    else
      keepGoing = 0;
      fprintf("both dimensions >1... abort...\n")
    end

  end

  if keepGoing > 0
    retvar = int2complementOnTwo(inpVal, bitWidth);
    fid = fopen(fName, "w");
    it = 0;

    while it < lenDat
      it = it + 1;
      jt = 0;
      hexLine = dec2hex(retvar(it,1), lenLine);

      while jt < lenLine
        jt = jt + 1;
        fprintf(fid, "%c", hexLine(1,jt));
      end

      fprintf(fid, "\n");

    end

    fclose(fid);
  else
    retvar = -1;
  end

end