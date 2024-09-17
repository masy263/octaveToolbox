close all;
clear all;

%fid = fopen('tcOut.adc00.csv', 'r');
%s = fread(fid);
%s = readlines('testSigMf.csv');
s = readlines('tcOut.csv');inpNos = 15;
%s = readlines('csv/tcOut.mf07.csv');inpNos = 5;
%s = readlines('csv/tcOut.pd01.csv');
%s = readlines('csv/tcOut.rx00.csv');
sig = [];
for it = 1:size(s,1)
    try
        stemp = s(it);
        stemp = strsplit(stemp,',');
        for it2 = 1:size(stemp,2)
            ctemp = eval(stemp(it2));
            sig = [sig, ctemp];
        end
    catch
        break;
    end
end
% fclose(fid);

for it = 1:inpNos
figure;

polyphase = sig(it:5:end);csvwrite(['symPolyphase', num2str(it), '.csv'], polyphase');
bit1 = imag(polyphase) < 0;
bit0 = real(polyphase) < 0;

polyphase = zeros(1, length(bit0(1,:)) * 2);
polyphase(1, 1:2:end) = bit1;
polyphase(1, 2:2:end) = bit0;

csvwrite(['binSymPolyphase', num2str(it), '.csv'], [bit1;bit0]');
csvwrite(['bitPolyphase', num2str(it), '.csv'], polyphase');

plot(sig(it:5:end),'bx');
end
mypsd((sig), 1024, 13.5,1);




