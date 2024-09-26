icasDataPath         = '/home/markus/Arbeit/icasSignalUL/icasChipsUnshaped/';
outPathHexFiles      = '/home/markus/Arbeit/2024-09-24_icasChipsHex/';
chipsPilotAndPayload = 'chipsPilotAndPayload.csv';
chipsSignaling       = 'chipsSignaling.csv';
chipsComplete        = 'icasFullSampleVector.csv';
chipsSyncPreamble    = 'preambleSync.csv';

bitWidthPreamble         = 3;
outFileChipsPreambleReal = [outPathHexFiles, 'chipsSyncPreambleReal.hex'];
outFileChipsPreambleImag = [outPathHexFiles, 'chipsSyncPreambleImag.hex'];

if min([fct_checkFileExistence(outFileChipsPreambleReal), fct_checkFileExistence(outFileChipsPreambleImag)]) < 0
  preamble = csvread([icasDataPath, chipsSyncPreamble]);
  preamble = round(fct_normMatrix(preamble) .* (2^bitWidthPreamble - 1));
  fileSizeSyncReal = fct_uint2hexFile(fct_int2complementOnTwo(real(preamble),  bitWidthPreamble), bitWidthPreamble, outFileChipsPreambleReal);
  fileSizeSyncImag = fct_uint2hexFile(fct_int2complementOnTwo(imag(preamble),  bitWidthPreamble), bitWidthPreamble, outFileChipsPreambleImag);
  fprintf("Preamble size: %d bits\n", length(preamble(:,1)) * 2 * bitWidthPreamble);
else
  fprintf("preamble files already exist.\n");
end

outFileChipsSignaling = [outPathHexFiles, 'chipsSignaling.hex'];

if fct_checkFileExistence(outFileChipsSignaling) < 0
  signaling = csvread([icasDataPath, chipsSignaling]);
  signalingReal = real(signaling);
  signalingBits = (signalingReal > 0.5);
  fileSizeSig = fct_uint2hexFile(signalingBits, 1, outFileChipsSignaling)
  fprintf("Signaling size: %d bits\n", length(signalingBits(:,1)));
else
  fprintf("signaling file already exists.\n");
end

outFileChipsPilotAndPayloadReal = [outPathHexFiles, 'chipsChipsPilotAndPayloadReal.hex'];
outFileChipsPilotAndPayloadImag = [outPathHexFiles, 'chipsChipsPilotAndPayloadImag.hex'];

if min([fct_checkFileExistence(outFileChipsPilotAndPayloadReal), fct_checkFileExistence(outFileChipsPilotAndPayloadImag)]) < 0
  pilotAndPayload = csvread([icasDataPath, chipsPilotAndPayload]);
  ppReal = round(real(pilotAndPayload) .* 1000) ./ 1000;
  ppImag = round(imag(pilotAndPayload) .* 1000) ./ 1000;
  ppRealGt0 = (ppReal > 0);
  ppImagGt0 = (ppImag > 0);
  lData = length(ppRealGt0(:,1))
  ppSizeByte = round(2 * lData / 8 + 0.5)
  fileSizePPReal = fct_uint2hexFile(ppRealGt0, 1, outFileChipsPilotAndPayloadReal)
  fileSizePPImag = fct_uint2hexFile(ppImagGt0, 1, outFileChipsPilotAndPayloadImag)
end

nOs         = [2, 3, 5, 15, 30];
bitWidthRrc = 8;
rollOff     = 0.3;
it          = 0;

outPathRrc = '/home/markus/Arbeit/2024-09-24_rrcFilter/';

while it < length(nOs(1,:))
  it = it + 1;
  rrcFilter = rcosine(1, nOs(1,it), 'fir/sqrt', rollOff, 3);
  rrcFilter = round(fct_normMatrix(rrcFilter) .* (2^(bitWidthRrc - 1) - 1));
  csvwrite([outPathRrc, 'rrcFilterNos', num2str(nOs(1,it), "%02d"), '.csv'], rrcFilter);
  fct_uint2hexFile(fct_int2complementOnTwo(rrcFilter', bitWidthRrc), bitWidthRrc, [outPathRrc, 'rrcFilterNos', num2str(nOs(1,it), "%02d"), '.hex'])
end
