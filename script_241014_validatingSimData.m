close all;

inpPath        = "/home/markus/Git-Repos/adrv9361z7035ccbobCmos/verilog/.sim/";
fNameMfSamples = "mfSampleOutput.csv";

mfSamples = csvread([inpPath, fNameMfSamples]);
sizeMfSamples = size(mfSamples);
fprintf("length of input data set %d\n", sizeMfSamples(1,1));

lOffset    = 318;
lPreambl   = 32766;
lSignaling = 66495 + 45;
lPP        = 2985114

it = 0;

while it < 5;
  it = it + 1;
  mfSamples(:,it) = mfSamples(:,2 * it - 1) + mfSamples(:, 2 * it) * i;
end

mfSamples = mfSamples(:,1:5);

startIdx        = lOffset;
endIdx          = startIdx + lPreambl - 1;
simDatPraemble  = mfSamples(startIdx:endIdx, :); length(simDatPraemble(:,1))
startIdx        = endIdx + 1;
endIdx          = min([sizeMfSamples(1,1), endIdx + lSignaling]);
simDatSignaling = mfSamples(startIdx:endIdx, :); length(simDatSignaling(:,1))
startIdx        = endIdx + 1;
endIdx          = min([sizeMfSamples(1,1), endIdx + lPP]);
simDatPP        = mfSamples(startIdx:endIdx, :); length(simDatPP(:,1))

it = 0;

while(it < 1)
  it = it + 1;
  figure;
  plot(simDatPraemble(:,it));
  figure;
  plot(simDatSignaling(:,it));
  figure;
  plot(simDatPP(:,it));
end
