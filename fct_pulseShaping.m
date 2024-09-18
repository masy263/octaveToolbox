function sigBaseband = fct_pulseShaping(symbols, nOs, rollOff, rc)

  sigBaseband = -1;

  if min(size(symbols)) > 0
    keepGoing = 1;
  else
    keepGoing = 0;
    fprintf("[fct_genQpskSymbols] ERROR: dimension mismatch\n");
  end

  if keepGoing > 0

    if length(symbols(:,1)) > 1
      vertical = 1;
      symbols = real(symbols)' + imag(symbols)' .* i;
    else
      vertical = 0;
    end

    lenSymbols = length(symbols(1,:));
    rcFilter = rcosine(1, nOs, 'fir/sqrt', rollOff, 8);

    sigBaseband            = zeros(1,lenSymbols*nOs);
    sigBaseband(1:nOs:end) = symbols;
    sigBaseband            = conv(rcFilter, sigBaseband);

    if rc > 0
      sigBaseband          = conv(rcFilter, sigBaseband);
    end

    if vertical > 0
      sigBaseband = real(sigBaseband)' + imag(sigBaseband)' .* i;
    end

  end

end
