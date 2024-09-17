clear; clc;

nBit              = 8;
bits              = zeros(2^nBit, nBit);

it = 0;
while it < 2^nBit
  tmp = it;
  it = it + 1;
  jt = 0;

  while jt < nBit
    bits(it, nBit - jt) = mod(tmp, 2);
    tmp = tmp - mod(tmp, 2);
    tmp = tmp / 2;
    jt = jt + 1;
  end

end

sig = zeros(1, 2^nBit * nBit);
it = 0;

while it < 2^nBit
  sig(1, it * nBit + 1:it * nBit + nBit) = bits(it + 1, :);
  it = it + 1;
end

%bits
%sig

sq2               = 1 / sqrt(2);
qpskConstellation = [sq2+sq2*i, -sq2+sq2*i, sq2-sq2*i, -sq2-sq2*i];

sigBit1           = sig(1, 1:2:end-1);
sigBit0           = sig(1, 2:2:end);
%[sigBit1', sigBit0']

constIdx          = sigBit1 * 2 + sigBit0 + 1;
sigQpsk           = constIdx';
it                = 0;

while it < length(sigQpsk(:,1))
  it = it + 1;
  sigQpsk(it,1) = qpskConstellation(1,sigQpsk(it,1));
end

%sigQpsk

%sigQpsk(1,:)      = qpskConstellation(1,constIdx(1,:));

sigBinTupel = [imag(sigQpsk) < 0, real(sigQpsk) < 0];

csvwrite("testSigBin.csv", sig');
csvwrite("testSigBinTupel.csv", sigBinTupel);
csvwrite("testSigCplxSym.csv", sigQpsk);

