% takes the Ministry file and computes average in col 26 and std in col 27
Min_file = './Example/Ministry.xlsx'; 
tMinT = readtable(Min_file); % reads file
start = 6; % skip first 5 rows of the xlsx file

[rows,col] = size(tMinT);
for i = 1:rows
    tMinH(1) = mean(tMinT.Var2(i));
    tMinH(2) = mean(tMinT.Var3(i));
    tMinH(3) = mean(tMinT.Var4(i));
    tMinH(4) = mean(tMinT.Var5(i));
    tMinH(5) = mean(tMinT.Var6(i));
    tMinH(6) = mean(tMinT.Var7(i));
    tMinH(7) = mean(tMinT.Var8(i));
    tMinH(8) = mean(tMinT.Var9(i));
    tMinH(9) = mean(tMinT.Var10(i));
    tMinH(10) = mean(tMinT.Var11(i));
    tMinH(11) = mean(tMinT.Var12(i));
    tMinH(12) = mean(tMinT.Var13(i));
    tMinH(13) = mean(tMinT.Var14(i));
    tMinH(14) = mean(tMinT.Var15(i));
    tMinH(15) = mean(tMinT.Var16(i));
    tMinH(16) = mean(tMinT.Var17(i));
    tMinH(17) = mean(tMinT.Var18(i));
    tMinH(18) = mean(tMinT.Var19(i));
    tMinH(19) = mean(tMinT.Var20(i));
    tMinH(20) = mean(tMinT.Var21(i));
    tMinH(21) = mean(tMinT.Var22(i));
    tMinH(22) = mean(tMinT.Var23(i));
    tMinH(23) = mean(tMinT.Var24(i));
    tMinH(24) = mean(tMinT.Var25(i));
    
    tMinT.Var26(i) = mean(tMinH);
    tMinT.Var27(i) = std(tMinH);
end
tMinSD = tMinT.Var27(start:rows);

save ./Example/ministrySD tMinSD
