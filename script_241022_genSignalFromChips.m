icasDataPath = '/home/markus/Arbeit/2024-09-24_icasChipsCsv/';

nOs     = 15;
rollOff = 0.3;
chips   = [];
chips   = [chips; csvread([icasDataPath, 'chipsPilotAndPayload.csv'])];
chips   = [chips; csvread([icasDataPath, 'chipsSignaling.csv'])];
chips   = [chips; csvread([icasDataPath, 'preambleSync.csv'])];
sig     = fct_pulseShaping(chips, nOs, rollOff, 0);
sig     = round(fct_normMatrix(sig) .* 2^9);
sigImag = fct_int2complementOnTwo(imag(sig), 16);
sigReal = fct_int2complementOnTwo(real(sig), 16);

fct_uint2hexFile(sigImag, 16, [icasDataPath, 'icasImag.hex'], "w");
fct_uint2hexFile(sigReal, 16, [icasDataPath, 'icasReal.hex'], "w");
