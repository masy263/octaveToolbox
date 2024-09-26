function ret = fct_plotPolyphase(fName, nr)
  polyphases = csvread(fName);
  sig = polyphases(:,nr);
  figure;
  plot(sig);
  ret = length(sig(:,1));
end