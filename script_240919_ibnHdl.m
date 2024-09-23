inpPath = '/home/markus/Arbeit/ibnHdl/adrv/data240919/hexInp/';
outPath = '/home/markus/Arbeit/ibnHdl/adrv/data240919/csvOut/';

% /home/markus/Arbeit/ibnHdl/adrv/data240912/csvOut/tcOutAdc10_polyphase_06_phi090.bits

amountOfDataSets = 10;
pickSample = -1;


if pickSample < 0

  it = 0;

  while it < amountOfDataSets

    if it < 10
      fPref = ['tcDataAdc0', num2str(it)];
    else
      fPref = ['tcDataAdc',  num2str(it)];
    end

    sig = fct_convertTcAdc(inpPath, outPath, fPref);

    polyphase = fct_parseSignal(outPath, outPath, [fPref, '_cplx.csv'], 15, 0);
    input("Naechstes?");
    it = it + 1;
  end

else
  it = pickSample;

    if it < 10
      outFile = ['tcOutAdc0', num2str(it), '.cplx'];
    else
      outFile = ['tcOutAdc',  num2str(it), '.cplx'];
    end

    polyphase = fct_parseSignal(outPath, outPath, outFile, 15, 3);

    it = 0;

    while it < 15
      it = it + 1;
      figure; plot(polyphase(:,it), 'rx');
    end
    
    input("fertig?");
end

close all