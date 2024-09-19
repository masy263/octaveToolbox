function polyphase = fct_parseSignal(fName, inpNos)

  close all;

  sig       = csvread(fName);
  lSig      = length(sig(:,1));
  lSig      = lSig - mod(lSig, inpNos);
  sig       = sig(1:lSig,1);
  polyphase = zeros(lSig / inpNos, inpNos);
  bits      = polyphase;

  for it = 1:inpNos
    polyphase(:,it)    = sig(it:inpNos:end,1);
    bits(:,it * 2 - 1) = (imag(polyphase(:,it)) < 0);
    bits(:,it * 2)     = (real(polyphase(:,it)) < 0);

    if it < 10
      outputFile = ['polyphase_0', num2str(it), '.bits'];
    else
      outputFile = ['polyphase_',  num2str(it), '.bits'];
    end

    csvwrite(outputFile, bits(:,it * 2 - 1:it * 2));
    figure;
    plot(polyphase(:,it),'bx');
  end

  mypsd((sig), 1024, 13.5,1);

end