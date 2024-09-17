function retvar = uint2hexFile(inpVal, bitWidth, fName)

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
      fprintf("[uint2hexFile] ERROR: both dimensions >1... abort...\n")
    end

  end

  if keepGoing > 0

    if min(inpVal) < 0
      fprintf("[uint2hexFile] WARNING: data contains negative values!\n");
      fprintf("[uint2hexFile] WARNING: negative values are set to 0!\n");
      retvar = inpVal .* (inpVal >= 0);
    else
      retvar = inpVal;
    end

    tmp = max(inpVal);

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
