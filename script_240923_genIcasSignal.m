clear; clc; close all;

nOs         = 2;
rollOff     = 0.3;
sigBitWidth = 4;

symbols     = csvread('/home/markus/Arbeit/icasSignalUL/icasChipsUnshaped/icasFullSampleVector.csv');
sigBaseband = fct_pulseShaping(symbols, nOs, rollOff, 0);
sigBaseband = round(fct_normMatrix(sigBaseband) .* (2^sigBitWidth - 1));

fileSize = fct_uint2hexFile(fct_int2complementOnTwo(real(sigBaseband),  sigBitWidth), sigBitWidth, ['icasBaseband_I_nOs',  num2str(nOs), '.hex']);
fileSize = fct_uint2hexFile(fct_int2complementOnTwo(imag(sigBaseband),  sigBitWidth), sigBitWidth, ['icasBaseband_Q_nOs',  num2str(nOs), '.hex']);

%csvwrite(['icasBaseband_I_nOs', num2str(nOs), '.csv'], sigBaseband);
