function polyphase = fct_parseSignal(sig, inpNos, plotFlag)

  lSig       = length(sig(:,1));
  lSig       = lSig - mod(lSig, inpNos);
  sig        = sig(1:lSig,1);
  polyphase  = zeros(lSig / inpNos, inpNos);

  for it = 1:inpNos
    polyphase(:,it) = real(sig(it:inpNos:end,1)) + imag(sig(it:inpNos:end,1)) * i;

    if plotFlag > 0
      figure;
      plot(polyphase(:,it),'bx');
    end

  end

  if plotFlag > 0
    fct_prmkPsd((sig), 1024, 13.5,1);
  end

end