inpPath = '/home/markus/Arbeit/ibnHdl/adrv/data240919/hexInp/';
outPath = '/home/markus/Arbeit/ibnHdl/adrv/data240919/csvOut/';

outFileCplxAppendix = '_cplx.csv';
outFilePolyAppendix = '_poly.csv';
outFileByteAppendix = '_byte.csv';
outFileDeciAppendix = '_deci.csv';

idxStart               = 0;
idxEnd                 = 9;
constellationBitTupels = [0, 0; 0, 1; 1, 1; 1, 0];
phase0                 = [0, 90, 180, 270];
validDataSets          = [];
validPolyphases        = [];
validPhases0           = [];
validBitShifts         = [];


nrDataSet        = idxStart;

while nrDataSet < idxEnd + 1

  fileName = ['tcDataAdc', num2str(nrDataSet, "%02d")];

  inpFile     = [inpPath, fileName];
  outFileCplx = [outPath, fileName, outFileCplxAppendix];

  if fct_checkFileExistence(outFileCplx) > 0
    signalCplx = csvread(outFileCplx);
    fprintf("[script_240921_ibnHdl] INFO %s already exists...\n", outFileCplx);
  else
    signalCplx = fct_convertTcAdc(inpFile);
    csvwrite(outFileCplx, signalCplx);
    fprintf("[script_240921_ibnHdl] INFO %s was created...\n", outFileCplx);
  end

  polyphase = fct_parseSignal(signalCplx, 15, 0);
  outFilePoly = [outPath, fileName, outFilePolyAppendix];

  if fct_checkFileExistence(outFilePoly) < 0
    csvwrite(outFilePoly, polyphase);
  end


  nrPolyphase        = 0;

  while nrPolyphase < 15
    nrPolyphase = nrPolyphase + 1;
    nrPhase0 = 0;

    while nrPhase0 < 4
      bitTupels = fct_convertQpskSymbols2bitTupels(polyphase(:,nrPolyphase), constellationBitTupels);
      bits      = fct_flattenMatrix(bitTupels);
      evalBits  = fct_search4cntValsInBitstream(bits, 8);

      if max(evalBits) > (length(polyphase(:,nrPolyphase)) / 8);
        nrBitShift      = sum([evalBits == max(evalBits)] .* [0:7]);
        bytes           = fct_reshapeBits(bits(1,nrBitShift + 1:end), 8);
        validDataSets   = [validDataSets; nrDataSet];
        validPolyphases = [validPolyphases; nrPolyphase];
        validPhases0    = [validPhases0; phase0(1,1)];
        validBitShifts  = [validBitShifts; nrBitShift];
        outFileByte     = [outPath, fileName, outFileByteAppendix];
        outFileDeci     = [outPath, fileName, outFileDeciAppendix];

        if fct_checkFileExistence(outFileByte) < 0
          csvwrite(outFileByte, bytes);
        end

        if fct_checkFileExistence(outFileDeci) < 0
          csvwrite(outFileDeci, fct_bin2uint(bytes));
        end

      end

      constellationBitTupels = [constellationBitTupels(2:4,:); constellationBitTupels(1,:)];
      phase0    = [phase0(1,2:4), phase0(1,1)];
      nrPhase0  = nrPhase0 + 1;
    end

  end

  nrDataSet = nrDataSet + 1;
end

valids = [validDataSets validPolyphases validPhases0 validBitShifts]
