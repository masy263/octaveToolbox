inpPrefix = '/home/markus/Git-Repos/adrv9361z7035ccbobCmos/verilog/simOut/mfOut';
outPrefix = '/home/markus/Arbeit/2024-10-22_prmkSimSampleInput/samples_input_';
idx       = 0;

while idx < 5
  fName   = [inpPrefix, 'Imag', num2str(idx), '.dat'];
  data    = csvread(fName);
  dataBit = fct_determineBitWidth(data);
  dataMin = min(data);
  dataMax = max(data);
  dataRms = sqrt(sum(data(:,1).^2) / length(data(:,1)));

  fprintf("imag %d :: len: %d :: min: %d :: max: %d :: rms: %d :: bit width: %d\n", idx, length(data(:,1)), dataMin, dataMax, dataRms, dataBit);

  fName = [outPrefix, 'imag', num2str(idx), '.hex'];
  data  = fct_int2complementOnTwo(data, 14);

  fct_uint2hexFile(data, 14, fName, "w");

  idx = idx + 1;
end

idx = 0;

while idx < 5
  fName   = [inpPrefix, 'Real', num2str(idx), '.dat'];
  data    = csvread(fName);
  dataBit = fct_determineBitWidth(data);
  dataMin = min(data);
  dataMax = max(data);
  dataRms = sqrt(sum(data(:,1).^2) / length(data(:,1)));

  fprintf("real %d :: len: %d :: min: %d :: max: %d :: rms: %d :: bit width: %d\n", idx, length(data(:,1)), dataMin, dataMax, dataRms, dataBit);

  fName = [outPrefix, 'real', num2str(idx), '.hex'];
  data  = fct_int2complementOnTwo(data, 14);

  fct_uint2hexFile(data, 14, fName, "w");

  idx = idx + 1;
end

