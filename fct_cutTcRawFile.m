function sofPos = fct_cutTcRawFile(fName, amntBytes)

  sofPos = -1;

  charLinebreak = 10;
  charSpace     = 32;

  strDat     = double(fileread(fName));
  sizeStrDat = size(strDat);
  lenStrDat  = prod(sizeStrDat);

  strDat = nonzeros(strDat .* (strDat ~= charLinebreak))';
  sof    = double('2E 16 D2 04 0C 00 80');
  lenSof = length(sof(1,:));
  it     = lenSof - 1;

  while it < lenStrDat
    it = it + 1;
    check = (sum(strDat(1,it - lenSof + 1:it) == sof) == lenSof);

    if check > 0
      % fprintf("found sof at %d\n", it);
      sofPos = it;
      strDat = strDat(1,it + 1:it + amntBytes);
      it     = lenStrDat;
      fid    = fopen(fName, 'w');

      fprintf(fid, "%s", char(strDat));
      fclose(fid);
    end

  end

end