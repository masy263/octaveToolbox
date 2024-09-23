function ret = fct_convertTcAdc(inpFile)

  ret = 0;

  tcData = fct_hexFile2uint(inpFile, 4);
  tcData = [tcData(:,1) * 256 + tcData(:,2), tcData(:,3) * 256 + tcData(:,4)];
  tcData = fct_complementOnTwo2int(tcData, 16);
  tcData = tcData(:,2) + tcData(:,1) * i;

  ret = tcData;

end