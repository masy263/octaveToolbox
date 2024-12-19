% sigImag = csvread("/home/markus/Git-Repos/adrv9361z7035ccbobCmos/verilog/simInp/adcImag.dat");
% sigReal = csvread("/home/markus/Git-Repos/adrv9361z7035ccbobCmos/verilog/simInp/adcReal.dat");

rmsImag       = sqrt(sum(sigImag.^2) / length(sigImag(:,1)))
rmsReal       = sqrt(sum(sigReal.^2) / length(sigReal(:,1)))
noiseImag     = rand(1e+6, 1) - 0.5;
noiseImagGain = sqrt(length(noiseImag(:,1)) / sum(noiseImag.^2)) * rmsImag
noiseImag     = round(noiseImag .* noiseImagGain);
noiseImagRms  = sqrt(sum(noiseImag.^2) / length(noiseImag(:,1)))
noiseReal     = rand(1e+6, 1) - 0.5;
noiseRealGain = sqrt(length(noiseReal(:,1)) / sum(noiseReal.^2)) * rmsReal
noiseReal     = round(noiseReal .* noiseRealGain);
noiseRealRms  = sqrt(sum(noiseReal.^2) / length(noiseReal(:,1)))

csvwrite("/home/markus/Git-Repos/adrv9361z7035ccbobCmos/verilog/simInp/noiseImag.dat", noiseImag);
csvwrite("/home/markus/Git-Repos/adrv9361z7035ccbobCmos/verilog/simInp/noiseReal.dat", noiseReal);