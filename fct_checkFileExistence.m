function ret = fct_checkFileExistence(fName)

  ret = fopen(fName);

  if ret > 0
    fclose(ret);
  end

end