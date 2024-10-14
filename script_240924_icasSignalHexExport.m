icasDataPath         = '/home/markus/Arbeit/icasSignalUL/icasChipsUnshaped/';
outPathHexFiles      = '/home/markus/Arbeit/2024-09-24_icasChipsHex/';
chipsPilotAndPayload = 'chipsPilotAndPayload.csv';
chipsSignaling       = 'chipsSignaling.csv';
% chipsComplete        = 'icasFullSampleVector.csv';
chipsSyncPreamble    = 'preambleSync.csv';

%% +++ begin: export sync preamble +++ %%

  bitWidthPreamble         = 3;
  outFileChipsPreambleReal = [outPathHexFiles, 'chipsSyncPreambleReal.hex'];
  outFileChipsPreambleImag = [outPathHexFiles, 'chipsSyncPreambleImag.hex'];
  preamble                 = csvread([icasDataPath, chipsSyncPreamble]);
  figure; plot(preamble)
  preamble                 = round(fct_normMatrix(preamble) .* (2^(bitWidthPreamble - 1) - 1));
  sum(preamble == (0 + 3 * i))
  figure; plot(preamble)
  preamble                 = fct_int2complementOnTwo(real(preamble),  bitWidthPreamble) + fct_int2complementOnTwo(imag(preamble),  bitWidthPreamble) * i;
  sum(preamble == (0 + 3 * i))
  figure; plot(preamble)

  if min([fct_checkFileExistence(outFileChipsPreambleReal), fct_checkFileExistence(outFileChipsPreambleImag)]) < 0
    fileSizeSyncReal = fct_uint2hexFile(real(preamble), bitWidthPreamble, outFileChipsPreambleReal);
    fileSizeSyncImag = fct_uint2hexFile(imag(preamble), bitWidthPreamble, outFileChipsPreambleImag);
    fprintf("Preamble size: %d bits\n", length(preamble(:,1)) * 2 * bitWidthPreamble);
  else
    fprintf("preamble files already exist.\n");
  end

%  +++++ end: export sync preamble +++ %%

%% +++ begin: export signaling field +++ %%

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

%  +++++ end: export signaling field +++ %%

%% +++ begin: export pilot and payload chips field +++ %%

  outFileChipsPilotAndPayloadReal = [outPathHexFiles, 'chipsPilotAndPayloadReal.hex'];
  outFileChipsPilotAndPayloadImag = [outPathHexFiles, 'chipsPilotAndPayloadImag.hex'];

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

%  +++++ end: export sync preamble +++ %%

%% +++ begin: generate and export rrc filters +++ %%

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

%  +++++ end: generate and export rrc filters +++ %%
