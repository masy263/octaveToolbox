function distribution = fct_valueDistribution(A, plotFlag)

  A        = fct_flattenMatrix(A);
  realA    = real(A);
  imagA    = imag(A);
  maxRealA = max(realA);
  minRealA = min(realA);

  if(sum(imagA .^ 2) > 0)
    isCplx       = 1;
    maxImagA     = max(imagA);
    minImagA     = min(imagA);
    distribution = zeros(4,length(A(1,:)));
  else
    isCplx       = -1;
    distribution = zeros(2,length(A(1,:)));
  end

  it       = 0;

  while minRealA <= maxRealA
    it                 = it + 1;
    cmpMin             = (minRealA == realA);
    distribution(1,it) = sum(cmpMin);
    distribution(2,it) = minRealA;
    realA              = (cmpMin) .* (maxRealA + 1) + ((cmpMin) - 1).^2 .* realA;
    minRealA           = min(realA);
  end

  jt = 0;

  if(isCplx > 0)

    while minImagA <= maxImagA
      jt                 = jt + 1;
      cmpMin             = (minImagA == imagA);
      distribution(3,jt) = sum(cmpMin);
      distribution(4,jt) = minImagA;
      imagA              = (cmpMin) .* (maxImagA + 1) + ((cmpMin) - 1).^2 .* imagA;
      minImagA           = min(imagA);
    end

  end
    
  distribution = distribution(:,1:max([it, jt]));

  if(plotFlag > 0)
    close all;

    if(isCplx > 0)
      figure; plot(distribution(4,:), distribution(3,:), 'o');
      figure; plot(distribution(2,:), distribution(1,:), 'o');
    else
      plot(distribution(2,:), distribution(1,:), '*');
    end

  end

end