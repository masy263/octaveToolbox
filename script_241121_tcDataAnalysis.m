% script_241121_tcDataAnalysis

refFileImag = '/home/markus/Arbeit/2024-06-21_TestsignalPrmkUL/Nos2/samples_Nos2_input_imag.dat';
refFileReal = '/home/markus/Arbeit/2024-06-21_TestsignalPrmkUL/Nos2/samples_Nos2_input_imag.dat';
data        = csvread(refFileImag);
data        = [csvread(refFileReal); data];

fprintf("  Ref.File :: min: %6d :: max: %6d\n", min(min(data)), max(max(data)));

inpPath = '/home/markus/Arbeit/2024-11-21_testAufEvalBoard/tcOut241121agcAt50dB/';
outPath = '/home/markus/Arbeit/2024-11-21_testAufEvalBoard/data/';

% check adc magnitudes

filePrefix   = 'tcAdcAt-';
idxStart     = 41;
idxEnd       = 45;
idxDelta     = 1;
amntDataSets = 2;
bytesPerSet  = 2;
idxInpFile   = idxStart;
foundFile    = -1;

while (foundFile < 0) && (idxInpFile < idxEnd + idxDelta)
  inpFile    = [inpPath, filePrefix, num2str(idxInpFile), 'dBm'];
  fid        = fopen(inpFile, 'r');

  if fid > 0
    foundFile  = 1;
    fprintf("found file: %s\n", inpFile);
    fclose(fid);
  else
    foundFile  = -1;
    idxInpFile = idxInpFile + idxDelta;
  end

end

foundFile = -1;

while idxInpFile < idxEnd + idxDelta
  inpFile = [inpPath, filePrefix, num2str(idxInpFile), 'dBm'];
  outFile = [outPath, filePrefix, num2str(idxInpFile), 'dBm.dec'];

  fct_cutTcRawFile(inpFile, 3 * 4 * 8192)

  data = fct_hexFile2uint(inpFile, amntDataSets * bytesPerSet);
  data = [data(:,1) * 256 + data(:,2), data(:,3) * 256 + data(:,4)];
  data = fct_complementOnTwo2int(data, 16);

  fprintf("  -%ddBm :: min: %6d :: max: %6d\n", idxInpFile, min(min(data)), max(max(data)));
  csvwrite(outFile, data);

  idxInpFile = idxInpFile + idxDelta;

  while (foundFile < 0) && (idxInpFile < idxEnd + idxDelta)
    inpFile    = [inpPath, filePrefix, num2str(idxInpFile), 'dBm'];
    fid        = fopen(inpFile, 'r');

    if fid > 0
      foundFile  = 1;
      fprintf("found file: %s\n", inpFile);
      fclose(fid);
    else
      foundFile  = -1;
      idxInpFile = idxInpFile + idxDelta;
    end

  end

  foundFile = -1;
end

% lVal file

filePrefix   = 'tcLValsAt-';
idxStart     = 30;
idxEnd       = 40;
idxDelta     = 1;
amntDataSets = 2;
bytesPerSet  = 4;
idxInpFile   = idxStart;
foundFile    = -1;

while (foundFile < 0) && (idxInpFile < idxEnd + idxDelta)
  inpFile    = [inpPath, filePrefix, num2str(idxInpFile), 'dBm'];
  fid        = fopen(inpFile, 'r');

  if fid > 0
    foundFile  = 1;
    fprintf("found file: %s\n", inpFile);
    fclose(fid);
  else
    foundFile  = -1;
    idxInpFile = idxInpFile + idxDelta;
  end

end

foundFile = -1;

while idxInpFile < idxEnd + idxDelta
  inpFile = [inpPath, filePrefix, num2str(idxInpFile), 'dBm'];
  outFile = [outPath, filePrefix, num2str(idxInpFile), 'dBm.dec'];

  fct_cutTcRawFile(inpFile, 3 * 4 * 8192)

  data      = fct_hexFile2uint(inpFile, amntDataSets * bytesPerSet);
  data(:,1) = data(:,1) * 256^3 + data(:,2) * 256^2 + data(:,3) * 256^1 + data(:,4);
  data(:,2) = data(:,5) * 256^3 + data(:,6) * 256^2 + data(:,7) * 256^1 + data(:,8);
  data      = data(:,1:2);
  data      = data - mod(data, 2^9);
  data      = data ./ 2^9;
  data      = mod(data, 2^9);
  data      = fct_complementOnTwo2int(data, 9);

  it            = 0;
  zeroCnt       = 0;
  zeroInARow    = 0;
  zeroInARowMax = 0;

  while it < length(data)
    it = it + 1;

    if data(it, :) == [0,0]
      zeroCnt = zeroCnt + 1;
      zeroInARow = zeroInARow + 1;
    else
      zeroInARowMax = max([zeroInARow, zeroInARowMax]);
      zeroInARow    = 0;
    end

  end

  fprintf("  -%ddBm lVal :: min: %6d :: max: %6d\n", idxInpFile, min(min(data)), max(max(data)));
  fprintf("              :: zero entries: %d :: max zero entries in a row: %d\n", zeroCnt, zeroInARowMax);

  csvwrite(outFile, data);

  idxInpFile = idxInpFile + idxDelta;

  while (foundFile < 0) && (idxInpFile < idxEnd + idxDelta)
    inpFile    = [inpPath, filePrefix, num2str(idxInpFile), 'dBm'];
    fid        = fopen(inpFile, 'r');

    if fid > 0
      foundFile  = 1;
      fprintf("found file: %s\n", inpFile);
      fclose(fid);
    else
      foundFile  = -1;
      idxInpFile = idxInpFile + idxDelta;
    end

  end

  foundFile = -1;
end

