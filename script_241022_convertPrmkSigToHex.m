inpPath  = '/home/markus/Arbeit/2024-08-01_IcasSignalePrmk/';
fileReal = 'samples_input_real';
fileImag = 'samples_input_imag';

sigImag = csvread([inpPath, fileImag, '.dat']);
sigImag = fct_int2complementOnTwo(sigImag, 16);
sigReal = csvread([inpPath, fileReal, '.dat']);
sigReal = fct_int2complementOnTwo(sigReal, 16);
lenImag = length(sigImag(:,1));
lenReal = length(sigReal(:,1));
x1      = (lenImag - 1) * 7.5;
x0      = [0:7.5:x1];
x1      = [0:1:x1];
sigImag = round(interp1(x0, sigImag', x1)');
sigReal = round(interp1(x0, sigReal', x1)');
lenImag = length(sigImag(:,1));
lenReal = length(sigReal(:,1));

fprintf("length imag data         = %d\n", lenImag);
fprintf("  expected address width = %d\n", fct_determineBitWidth(lenImag));
fprintf("length real data         = %d\n", lenReal);
fprintf("  expected address width = %d\n", fct_determineBitWidth(lenReal));

idxSamp    = 0;
idxStep    = 100000;
fileHandle = "w";

while idxSamp < lenImag
  idxSampLast = idxSamp + 1;
  idxSamp     = idxSamp + idxStep;

  if idxSamp > lenImag
    idxSamp = lenImag;
  end

  fct_uint2hexFile(sigImag(idxSampLast:idxSamp), 16, [inpPath, fileImag, '.hex'], fileHandle);
  fct_uint2hexFile(sigReal(idxSampLast:idxSamp), 16, [inpPath, fileReal, '.hex'], fileHandle);
  fileHandle = "a";
end

% fct_uint2hexFile(sigImag, 16, [inpPath, fileImag, '.hex']);
% fct_uint2hexFile(sigReal, 16, [inpPath, fileReal, '.hex']);
