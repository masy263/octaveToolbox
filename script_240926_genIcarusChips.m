% ======================================================================= %
% NOTWENDIGE AENDERUNGEN AM MATLAB-MODELL                                 %
% ---------------------------------------                                 %
%                                                                         %
% 1) icarus_simulator/DSP/Init_Icarus_Signaling_UL.m:                     %
%        -ParSet.Sig.UL_Modulation.Symbols = modul_qpsk(ParSet);          %
%        +ParSet                           = modul_qpsk(ParSet);          %
%                                                                         %
% 2) icarus_simulator/DSP/Init_Icarus_Signaling_UL.m:                     %
%        -m = load ('FEC\uplink\e_matrix.txt');                           %
%        +m = load (ParSet.Sim.fecUplinkMatrixPath);                      %
%        -m = load ('FEC\downlink\e_matrix.txt');                         %
%        +m = load (ParSet.Sim.fecUplinkMatrixPath);                      %
%                                                                         %
% 2) icarus_simulator/SimScripts/SimScript_UL_SigGen.m:                   %
%        +ParSet.Sim.fecUplinkMatrixPath   = 'FEC\uplink\e_matrix.txt';   %
%        +ParSet.Sim.fecDownlinkMatrixPath = 'FEC\downlink\e_matrix.txt'; %
% ======================================================================= %

close all; clear; clc;

path2prmkModel = '/home/markus/Git-Repos/icasLeo/icarus_simulator/';

addpath(genpath(path2prmkModel));

 %% +++ begin: struct declaration +++ %%

  ParSet = struct;    % System and Control Parameters
  Data   = struct;    % Data Exchange among Blocks

 %  +++++ end: struct declaration +++ %%

 %% +++ begin: running prmk matlab simulation +++ %%

  SimScript_UL_SigGen;

  ParSet.Sim.savepath              = '/home/markus/Git-Repos/octaveToolbox/outputData/'
  ParSet.Sim.fecUplinkMatrixPath   = [path2prmkModel, 'FEC/uplink/e_matrix.txt'];
  ParSet.Sim.fecDownlinkMatrixPath = [path2prmkModel, 'FEC/downlink/e_matrix.txt'];
  ParSet.Sim.filenumber            = 1; % darf nicht < 1 sein
  ParSet                           = Init_Icarus_FEC(ParSet);

  [ParSet, Data] = Init_Icarus_Signaling_UL(ParSet, Data);
  [ParSet, Data] = gen_icarus_ul_payload_data(ParSet, Data);
  [ParSet, Data] = gen_icarus_ul_signal_hdl_testbench(ParSet, Data);

 %  +++++ end: running prmk matlab simulation +++ %%

 %% +++ begin: load icarus data +++ %%

  load([ParSet.Sim.savepath, 'sig_field_payload_chips', num2str(ParSet.Sim.filenumber), '.mat']);

  chipsPilotAndPayload = chips;
  chipsSignaling       = chips_signaling;
  chipsPreamble        = transpose(preamble_sync); %real(preamble_sync)' + imag(preamble_sync)' .* i;
  icasDataPath         = '/home/markus/Arbeit/2024-09-24_icasChipsCsv/';

 %  +++++ end: load icarus data +++ %%

 %% +++ begin: write to *.csv +++ %%

  csvwrite([icasDataPath, 'chipsPilotAndPayload.csv'], chipsPilotAndPayload);
  csvwrite([icasDataPath, 'chipsSignaling.csv'], chipsSignaling);
  csvwrite([icasDataPath, 'preambleSync.csv'], chipsPreamble);

 %  +++++ end: write to *.csv +++ %%

 %% +++ begin: handle further data +++ %%

  % info_bits;
  % signaling_bits;
  % spreading_code;
  % symbols;
  % symbols_pilot
  % tx_filter_nos5

 %  +++++ end: handle further data +++ %%
