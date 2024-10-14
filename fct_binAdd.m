function ret = fct_binAdd(op1, op2, bitWidth)

  ret = op1;

  lenOp1 = length(op1(1,:));
  overflow = 0;

  it = 0;

  while it < lenOp1
    ret(1,end - it) = mod(op1(1,end - it) + op2(1,end - it) + overflow, 2);
    overflow = ((op1(1,end - it) + op2(1,end - it) + overflow) > 1);
    it = it + 1;
  end
    
end