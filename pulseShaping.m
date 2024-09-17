close all;
clear; clc;

nOs               = 15;
rollOff           = 0.3;
bitWidth          = 8;

Bchip_Hz            = 900e3;
Bsig_Hz             = Bchip_Hz * nOs;
        %     noise               = sqrt( Bsig_Hz/(Bchip_Hz*(1+0)) * 0.5 * 10^(-0.1*(SNR_dB))).*complex(randn(size(sig_rx)),randn(size(sig_rx)));
        %     sig_rx_noise        = sig_rx + noise;


sigQpsk = csvread("testSigCplxSym.csv")';
%sigQpsk = csvread("icasFullSampleVector.csv")';

lSigQpsk = length(sigQpsk(1,:))

rcFilter = rcosine(1, nOs, 'fir/sqrt', rollOff, 8);

sigBaseband = zeros(1,lSigQpsk*nOs);
sigBaseband(1:nOs:end) = sigQpsk;
sigBaseband = conv(rcFilter, sigBaseband);
%sigBasebandMf = conv(rcFilter, sigBaseband);

% MF Referenzsignal zur Kontrolle
%csvwrite("testSigMf.csv", sigBasebandMf');

% Fuer ADC-IBN ist das Testsignal gleich dem MF-Signal
% sigBaseband = sigBasebandMf;

maxBB = max(abs(sigBaseband))

realBBnorm = real(sigBaseband) ./ maxBB;
imagBBnorm = imag(sigBaseband) ./ maxBB;

realBB = round(realBBnorm .* 2^(bitWidth-1));
imagBB = round(imagBBnorm .* 2^(bitWidth-1));

sigBaseband = realBB + imagBB * i;

%figure;
%plot(sigBaseband,'bx');

% figure;
% plot(sigBaseband,'bx');
% 
% for it = 1:nOs
% figure;
% plot(sigBaseband(it:5:end),'bx');
% end

%fid = fopen("sigBaseband_formatSpace.csv", 'w');
%fprintf(fid, "%d %d\n", [realBB', imagBB']);
%fclose(fid);

% fid = fopen("sigBaseband_formatComma.csv", 'w');
% fprintf(fid, "%d, %d\n", [realBB', imagBB']);
% fclose(fid);
% 
% fid = fopen("sigBaseband_formatCplxCommaI.csv", 'w');
% fprintf(fid, "%d%+di,\n", [realBB', imagBB']);
% fclose(fid);
% 
% fid = fopen("sigBaseband_formatCplxCommaNoI.csv", 'w');
% fprintf(fid, "%d%+d,\n", [realBB', imagBB']);
% fclose(fid);
% 
% fid = fopen("sigBaseband_formatCplxI.csv", 'w');
% fprintf(fid, "%d%+di\n", [realBB', imagBB']);
% fclose(fid);
% 
% fid = fopen("sigBaseband_formatCplxNoI.csv", 'w');
% fprintf(fid, "%d%+d\n", [realBB', imagBB']);
% fclose(fid);
% 
 fid = fopen("sigBaseband_I.csv", 'w');
 fprintf(fid, "%d\n", realBB');
 fclose(fid);
 
 fid = fopen("sigBaseband_Q.csv", 'w');
 fprintf(fid, "%d\n", imagBB');
 fclose(fid);
 
 fid = fopen("tcOut.csv", 'w');
 fprintf(fid, "%d\n", [realBB', imagBB']);
 fclose(fid);
 
 2^(bitWidth - 1)
 min(realBB)
 max(realBB)
 
 int2hexFile(realBB, 16, "sigBaseband_I.hex", 1);
 int2hexFile(imagBB, 16, "sigBaseband_Q.hex", 1);
 
% csvwrite("testSig_norm.csv", sigBaseband');

 
% audiowrite("sigBaseband.wav", [realBBnorm', imagBBnorm'], 9e+5 * nOs);

%  probe = sigBaseband(1,5e+5:5e+5+8192*8);
%  probe = sigBaseband;
%  csvwrite("probe.csv", probe');
% 
% mypsd (sigBaseband, 1024, nOs*0.9, 1)
