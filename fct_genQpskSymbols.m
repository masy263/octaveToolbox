function symbols = fct_genQpskSymbols(a)

  sq2 = 1 / sqrt(2);

  if min(size(a)) > 0
    keepGoing = 1;
  else
    keepGoing = 0;
    symbols = -1;
    fprintf("[fct_genQpskSymbols] ERROR: dimension mismatch\n");
  end

  if keepGoing > 0

    if length(a(:,1)) > 1
      vertical = 1;
    else
      vertical = 0;
      a = a';
    end

    it = 0;
    lenA = length(a(:,1));
    lenA = lenA - mod(lenA, 2);
    symbols = zeros(lenA / 2, 1) + zeros(lenA / 2, 1) * i;

    while it < lenA
      it = it + 2;
      sym = sq2 + sq2 * i;
      tmp = a(it-1,1) * 2 + a(it,1);

      if tmp == 0
        sym =  sq2 + sq2 * i;
      end

      if tmp == 1
        sym = -sq2 + sq2 * i;
      end

      if tmp == 3
        sym = -sq2 - sq2 * i;
      end

      if tmp == 2
        sym =  sq2 - sq2 * i;
      end

      symbols(it / 2, 1) = sym;
    end

    if vertical < 1
      symbols = real(symbols)' + imag(symbols)' .* i;
    end

  end

end
