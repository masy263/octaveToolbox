clear; clc; close all;

cntBitWidth = 8;
nOs         = 15;
plotFlag    = 0;
rollOff     = 0.3;
sigBitWidth = 12;
outBitWidth = 16;

bits           = fct_genBinCntValues(cntBitWidth);
bits           = fct_flattenMatrix(bits)';
symbols        = fct_genQpskSymbols(bits);
sigBasebandRrc = fct_pulseShaping(symbols, nOs, rollOff, 0);
sigBasebandRrc = round(fct_normMatrix(sigBasebandRrc) .* (2^sigBitWidth - 1));
sigBasebandRc  = fct_pulseShaping(symbols, nOs, rollOff, 1);
sigBasebandRc  = round(fct_normMatrix(sigBasebandRc) .* (2^sigBitWidth - 1));

outSigRrc = sigBasebandRrc;
outSigRc  = sigBasebandRc;

enlarge = 30;
it      = 1;

while it < enlarge
  it        = it + 1;
  outSigRc  = [outSigRc; sigBasebandRc];
  outSigRrc = [outSigRrc; sigBasebandRrc];
end

fileSize = fct_uint2hexFile(fct_int2complementOnTwo(real(outSigRc),  outBitWidth), outBitWidth, ['sigBasebandRc_I_nOs',  num2str(nOs), '.hex']);
fileSize = fct_uint2hexFile(fct_int2complementOnTwo(imag(outSigRc),  outBitWidth), outBitWidth, ['sigBasebandRc_Q_nOs',  num2str(nOs), '.hex']);
fileSize = fct_uint2hexFile(fct_int2complementOnTwo(real(outSigRrc), outBitWidth), outBitWidth, ['sigBasebandRrc_I_nOs', num2str(nOs), '.hex']);
fileSize = fct_uint2hexFile(fct_int2complementOnTwo(imag(outSigRrc), outBitWidth), outBitWidth, ['sigBasebandRrc_Q_nOs', num2str(nOs), '.hex'])

csvwrite(['sigBasebandRrc_nOs', num2str(nOs), '.csv'], sigBasebandRrc);
csvwrite(['sigBasebandRc_nOs', num2str(nOs), '.csv'], sigBasebandRc);

if plotFlag > 0
  xAxis = [1:max(size(sigBasebandRrc))];
  % figure; plot(sigBasebandRrc, '*');
  % figure; plot(real(sigBasebandRrc));
  % figure; plot(imag(sigBasebandRrc));
  figure; plot(xAxis, real(sigBasebandRrc), 'r', xAxis, imag(sigBasebandRrc), 'b');

  xAxis = [1:max(size(sigBasebandRc))];
  % figure; plot(sigBasebandRc, '*');
  % figure; plot(real(sigBasebandRc));
  % figure; plot(imag(sigBasebandRc));
  figure; plot(xAxis, real(sigBasebandRc), 'r', xAxis, imag(sigBasebandRc), 'b');
end