function ret = fct_converTcAdc(inpPath, outPath, idxStart, idxEnd)

  ret = 0;

  if inpPath(1,end) == '/'
    inpPath = inpPath(1,1:end - 1);
  end

  if outPath(1,end) == '/'
    outPath = outPath(1,1:end - 1);
  end

  it = idxStart - 1;

  while it < idxEnd
    it = it + 1;

    if it < 10
      inpFile = [inpPath, '/tcInp.adc0', num2str(it)];
      outFile = [outPath, '/tcOutAdc0',  num2str(it), '.cplx'];
    else
      inpFile = [inpPath, '/tcInp.adc',  num2str(it)];
      outFile = [outPath, '/tcOutAdc',   num2str(it), '.cplx'];
    end

    tcData = fct_hexFile2uint(inpFile, 4);
    tcData = [tcData(:,1) * 256 + tcData(:,2), tcData(:,3) * 256 + tcData(:,4)];
    tcData = fct_complementOnTwo2int(tcData, 16);
    tcData = tcData(:,2) + tcData(:,1) * i;

    csvwrite(outFile, tcData);

    ret = ret + 1;
  end

end