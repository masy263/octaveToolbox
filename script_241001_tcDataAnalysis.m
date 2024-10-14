amntDataSets = 2;
bytesPerSet  = 4;

cfoVec = [];
sigVec = [];

beginIdx = 0;
endIdx   = 9;
fileIdx  = beginIdx - 1;

while fileIdx < endIdx
  fileIdx = fileIdx + 1;

  %% +++ begin: convert hexInp to raw decimal data +++
  
    inpPath           = '/home/markus/Arbeit/ibnHdl/adrv/data241009/hexInp/';
    outPath           = '/home/markus/Arbeit/ibnHdl/adrv/data241009/csvOut/';
    fName             = ['tcDataSigBitsAndCfo', num2str(fileIdx, "%02d")];
    outFileRawDec     = [outPath, fName, '_rawDec.csv'];
    outFileSigCfo     = [outPath, fName, '_sigCfo.csv'];
    outFileSigBitsHex = [outPath, fName, '_sigBitsHex.csv'];
    outFileSigBitsBin = [outPath, fName, '_sigBitsBin.csv'];

    fct_cutTcRawFile([inpPath, fName], 3 * 4 * 8192)
  
    if fct_checkFileExistence(outFileRawDec) < 0
      csvwrite(outFileRawDec, fct_hexFile2uint([inpPath, fName], amntDataSets * bytesPerSet));
    end
  
  %  +++++ end: convert hexInp to raw decimal data +++
  
  %% +++ begin: convert raw decimal data to uint data +++
  
    rawData   = csvread(outFileRawDec);
    % rawData   = rawData(1,:); % for debugging
    uintData  = zeros(length(rawData(:,1)), amntDataSets);
    it        = 0;
  
    while it < bytesPerSet
      jt = 0;
  
      while jt < amntDataSets
        jt             = jt + 1;
        uintData(:,jt) = uintData(:,jt) + rawData(:,jt * bytesPerSet - it) .* 256^it;
      end
  
      it = it + 1;
    end
  
  %  +++++ end: convert raw decimal data to uint data +++
  
  %% +++ begin: extracting sig bits +++
  
    bitWidth      = 10;
    offSetBits    = 6;
  
    rawSigBitData = uintData(:,2);
    uintSigBits   = mod((rawSigBitData - mod(rawSigBitData, 2^offSetBits)) ./ 2^offSetBits, 2^bitWidth);

    sigVec        = [sigVec; uintSigBits];

    csvwrite(outFileSigBitsHex, dec2hex(uintSigBits,  3));
    csvwrite(outFileSigBitsBin, dec2bin(uintSigBits, 10));
  
  %  +++++ end: extracting sig bits +++
  
  %% +++ begin: extracting sig field number +++
  
    bitWidth     = 2;
    offSetBits   = 16;
  
    rawSigNrData = uintData(:,2);;
    sigFieldNr   = mod((rawSigNrData - mod(rawSigNrData, 2^offSetBits)) ./ 2^offSetBits, 2^bitWidth);
  
  %  +++++ end: extracting sig field number +++
  
  %% +++ begin: extracting sig bits +++
  
    bitWidth      = 18;
    offSetBits    = 0;
  
    rawSigCfo  = uintData(:,1);
    uintSigCfo = mod((rawSigCfo - mod(rawSigCfo, 2^offSetBits)) ./ 2^offSetBits, 2^bitWidth);
    sigCfo     = fct_complementOnTwo2int(uintSigCfo, bitWidth);
    cfoVec     = [cfoVec; sigCfo];
    distCfo    = fct_valueDistribution(sigCfo, 0);
  
    csvwrite(outFileSigCfo, fct_valueDistribution(sigCfo, 0));
  
  %  +++++ end: extracting sig bits +++

end

distCfo = fct_valueDistribution(cfoVec, 0)
distSig = fct_valueDistribution(sigVec, 0)
csvwrite([outPath, 'distCfo.csv'], distCfo');