% script_241107_convertPrmkSamples

inpPath     = '/home/markus/Arbeit/2024-10-22_prmkSimSampleInput/';
outPath     = inpPath;
fileImagDec = 'samples_input_imag.dat';
fileRealDec = 'samples_input_real.dat';
fileImagHex = 'samples_input_imag';
fileRealHex = 'samples_input_real';


fprintf("[script_241107_convertPrmkSamples] read imag data dec...\n")

polyphasesImag = csvread([inpPath, fileImagDec]);
polyphasesImag = polyphasesImag(1:end-mod(length(polyphasesImag(:,1)), 5),1);
polyphasesReal = csvread([inpPath, fileRealDec]);
polyphasesReal = polyphasesReal(1:end-mod(length(polyphasesReal(:,1)), 5),1);
bitWidth = fct_determineBitWidth(max(max(abs(polyphasesImag)))) + 1;
inpLength = length(polyphasesImag);
lenPolyphase = inpLength / 5;

fprintf("[script_241107_convertPrmkSamples] input data:\n")
fprintf("    > length:            %10d\n", lenPolyphase);
fprintf("    > bitwidth:          %10d\n", bitWidth)
fprintf("    > ram address width: %10d\n", fct_determineBitWidth(lenPolyphase))
fprintf("[script_241107_convertPrmkSamples] split polyphases...\n")

chipImag = zeros(lenPolyphase, 5);
chipReal = zeros(lenPolyphase, 5);

idxPP = 0;

while idxPP < 5
  idxPP             = idxPP + 1;
  chipImag(:,idxPP) = polyphasesImag(idxPP:5:end,1);
  chipReal(:,idxPP) = polyphasesReal(idxPP:5:end,1);
end

chipImagUint = fct_int2complementOnTwo(chipImag, bitWidth);
chipRealUint = fct_int2complementOnTwo(chipReal, bitWidth);

idxPP = 0;

while idxPP < 5
  fct_uint2hexFile(chipImagUint(:,idxPP + 1), bitWidth, [outPath, fileImagHex, num2str(idxPP), '.hex']);
  fct_uint2hexFile(chipRealUint(:,idxPP + 1), bitWidth, [outPath, fileRealHex, num2str(idxPP), '.hex']);
  idxPP             = idxPP + 1;
end
