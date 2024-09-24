clear, clc, close all

cntBitWidth = 8;
plotFlag    = 1;
nOs         = 15;

bits           = fct_genBinCntValues(cntBitWidth);
bits           = fct_flattenMatrix(bits)';
symbols        = fct_genQpskSymbols(bits);

if plotFlag > 0
  figure;
  plot(symbols)
end

rrcFilter = fct_complementOnTwo2int(fct_hexFile2uint(['rrcFilterNos', num2str(nOs, "%02d"), '.hex'], 1), 8);

if plotFlag > 0
  figure;
  plot(rrcFilter)
end

lenRrc                      = length(rrcFilter(:,1));
lenSym                      = length(symbols(:,1));
lenData                     = (lenSym + 3) * nOs;
outDataRc                   = zeros(lenData,1);
outDataRrc                  = zeros(lenData,1);
tmpRc                       = zeros(lenRrc,1);
tmpRrc                      = zeros(lenRrc,1);
convSum                     = 0;

it     = 0;
jt     = 0;
symIdx = 0;

while it < lenData
  jt = jt + 1;

  if jt < nOs
    tmpRrc = [0; tmpRrc(1:end - 1, 1)];  
  else
    jt = 0;

    if symIdx < lenSym
      symIdx = symIdx + 1;
      tmpRrc = [symbols(symIdx,1); tmpRrc(1:end - 1, 1)];
    else
      tmpRrc = [0; tmpRrc(1:end - 1, 1)];  
    end

  end

  it               = it + 1;
  convSum          = sum(tmpRrc .* rrcFilter);
  outDataRrc(it,1) = convSum;
  tmpRc            = [convSum; tmpRc(1:end - 1,1)];
  convSum          = sum(tmpRc .* rrcFilter);
  outDataRc(it,1)  = convSum;
end

if plotFlag > 0
  x = 0:(lenData - 1);
  figure;
  plot(x, real(outDataRrc), 'r', x, imag(outDataRrc), 'b')
  figure;
  plot(outDataRrc)
end

if plotFlag > 0
  x = 0:(lenData - 1);
  figure;
  plot(x, real(outDataRc), 'r', x, imag(outDataRc), 'b')
  figure;
  plot(outDataRc)
end

outDataRc   = round(fct_normMatrix(outDataRc) * 1000);
outRc       = zeros(lenData, 4);
outRc(:,2)  = fct_int2complementOnTwo(real(outDataRc), 16);
outRc(:,1)  = fct_int2complementOnTwo(imag(outDataRc), 16);
outRc(:,4)  = mod(outRc(:,2), 256);
outRc(:,3)  = (outRc(:,2) - outRc(:,4)) ./ 256;
outRc(:,2)  = mod(outRc(:,1), 256);
outRc(:,1)  = (outRc(:,1) - outRc(:,2)) ./ 256;
fileSizeRc  = fct_uint2hexFile(outRc, 8, 'tcDataAdc00')
outDataRrc  = round(fct_normMatrix(outDataRrc) * 1000);
outRrc      = zeros(lenData, 4);
outRrc(:,2) = fct_int2complementOnTwo(real(outDataRrc), 16);
outRrc(:,1) = fct_int2complementOnTwo(imag(outDataRrc), 16);
outRrc(:,4) = mod(outRrc(:,2), 256);
outRrc(:,3) = (outRrc(:,2) - outRrc(:,4)) ./ 256;
outRrc(:,2) = mod(outRrc(:,1), 256);
outRrc(:,1) = (outRrc(:,1) - outRrc(:,2)) ./ 256;
fileSizeRrc = fct_uint2hexFile(outRrc, 8, 'tcDataAdc01')
