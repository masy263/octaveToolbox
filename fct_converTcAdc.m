function ret = fct_converTcAdc(fName)

  close all;

  nOs = 15;

  data = fct_hexFile2uint(fName, 4)
  data = [data(:,1) * 256 + data(:,2), data(:,3) * 256 + data(:,4)];
  data = fct_complementOnTwo2int(data, 16);
  plot(data(1:2000,1))
  data = data(:,2) + data(:,1) * i;

  ret = data;

  %it = 0;

  %while it < nOs
  %  it = it + 1;
  %  polyphase = data(it:nOs:end,:);
  %  figure; plot(polyphase, '*');
  %end

end