function data = fct_hexFile2uint(fName, clmns)

  data = -1;

  strDat = fileread(fName);
  sizeStrDat = size(strDat);
  lenStrDat = prod(sizeStrDat);

  checkVector = '0123456789ABCDEFabcdef';

  strValidHex = zeros(sizeStrDat);

  it = 0;
  while it < length(checkVector(1,:))
    it = it + 1;
    strValidHex = strValidHex + (strDat == checkVector(1,it));
  end

  positions = zeros(3, lenStrDat);
  it = 0;
  jt = 1;

  while it < lenStrDat
    it = it + 1;

    if (positions(1,jt) == 0) && (strValidHex(1,it) > 0)
      positions(1,jt) = it;
    end

    if (positions(1,jt) > 0) && (strValidHex(1,it) > 0)
      positions(2,jt) = it;
    end

    if (positions(1,jt) > 0) && (positions(2,jt) > 0) && (strValidHex(1,it) < 1)
      jt = jt + 1;
    end

  end

  positions = positions(:,1:jt);

  if positions(2,end) < 1
    positions = positions(:,1:end - 1);
  end

  positions(3,:) = positions(2,:) - positions(1,:) + 1;

  lenDat = length(positions(3,:));
  data = zeros(1,lenDat);

  it = 0;

  while it < lenDat
    it = it + 1;
    data(1,it) = hex2dec(strDat(1,positions(1,it):positions(2,it)));
  end

  lenDat = lenDat - mod(lenDat, clmns);
  data = data(1,1:lenDat);
  lenDat = lenDat / clmns;

  ret = zeros(lenDat, clmns);

  it = 0;

  while it < clmns
    it = it + 1;
    ret(:,it) = data(1, it:clmns:end)';
  end

  data = ret;

end