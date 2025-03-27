% ======================================================================= %
% NOTWENDIGE AENDERUNGEN AM MATLAB-MODELL                                 %
% ---------------------------------------                                 %
%                                                                         %
% 1) icarus_simulator/DSP/Init_Icarus_Signaling_UL.m:                     %
%        -ParSet.Sig.UL_Modulation.Symbols = modul_qpsk(ParSet);          %
%        +ParSet                           = modul_qpsk(ParSet);          %
%                                                                         %
% 2) icarus_simulator/FEC/Init_Icarus_FEC.m:                              %
%        -m = load ('FEC\uplink\e_matrix.txt');                           %
%        +m = load (ParSet.Sim.fecUplinkMatrixPath);                      %
%        -m = load ('FEC\downlink\e_matrix.txt');                         %
%        +m = load (ParSet.Sim.fecDownlinkMatrixPath);                      %
%                                                                         %
% 2) icarus_simulator/SimScripts/SimScript_UL_SigGen.m:                   %
%        +ParSet.Sim.fecUplinkMatrixPath   = 'FEC\uplink\e_matrix.txt';   %
%        +ParSet.Sim.fecDownlinkMatrixPath = 'FEC\downlink\e_matrix.txt'; %
% ======================================================================= %

close all; clear; clc;

runPrmkMatlabModel = 0;

path2prmkModel = '/home/markus/Git-Repos/icasLeo/icarus_simulator/';

addpath(genpath(path2prmkModel));

 %% +++ begin: struct declaration +++ %%

  ParSet = struct;    % System and Control Parameters
  Data   = struct;    % Data Exchange among Blocks

 %  +++++ end: struct declaration +++ %%

 %% +++ begin: running prmk matlab simulation +++ %%

  if(runPrmkMatlabModel > 0)
    SimScript_UL_SigGen;
  end

  % ParSet.Sim.savepath              = '/home/markus/Git-Repos/octaveToolbox/outputData/';
  ParSet.Sim.savepath              = '/home/markus/Arbeit/2025-01-09_simDaten/';
  ParSet.Sim.fecUplinkMatrixPath   = [path2prmkModel, 'FEC/uplink/e_matrix.txt'];
  ParSet.Sim.fecDownlinkMatrixPath = [path2prmkModel, 'FEC/downlink/e_matrix.txt'];
  ParSet.Sim.filenumber            = 1; % darf nicht < 1 sein

  if(runPrmkMatlabModel > 0)
    ParSet         = Init_Icarus_FEC(ParSet);
    [ParSet, Data] = Init_Icarus_Signaling_UL(ParSet, Data);
    [ParSet, Data] = gen_icarus_ul_payload_data(ParSet, Data);
    [ParSet, Data] = gen_icarus_ul_signal_hdl_testbench(ParSet, Data);
  end

 %  +++++ end: running prmk matlab simulation +++ %%

 %% +++ begin: load icarus data +++ %%

  load([ParSet.Sim.savepath, 'sig_field_payload_chips', num2str(ParSet.Sim.filenumber), '.mat']);

  icasDataPath             = '/home/markus/Arbeit/2024-09-24_icasChipsCsv/';
  noiseAtEnd               = (2 * round(rand(2^16,1)) - 1) * 0.7071 + (2 * round(rand(2^16,1)) - 1) * 0.7071 * i;
  noiseAtStart             = (floor(rand(2^16,1) * 7) - 3) + (floor(rand(2^16,1) * 7) - 3) * i;
  % chipsPilotAndPayload     = transpose(chips');
  chipsPilotAndPayload     = chips;
  chipsPilotAndPayload(1:10, 1)
  chipsPilotAndPayload     = [chipsPilotAndPayload; noiseAtEnd];
  chipsPreamble            = transpose(preamble_sync);
  chipsPreamble            = chipsPreamble * 3;
  chipsPreamble            = [noiseAtStart; chipsPreamble];
  chipsSignaling           = transpose(chips_signaling');
  nChipsPilotAndPayload    = length(chipsPilotAndPayload(:,1));
  nChipsPreamble           = length(chipsPreamble(:,1));
  nChipsSignaling          = length(chipsSignaling(:,1));
  addrWidthPilotAndPayload = fct_determineBitWidth(nChipsPilotAndPayload);
  addrWidthPreamble        = fct_determineBitWidth(nChipsPreamble);
  addrWidthSignaling       = fct_determineBitWidth(nChipsSignaling);

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

 %% +++ begin: echo data parameters +++ %%

  fNameInfo = 'info.txt';
  fidInfo = fopen([icasDataPath, fNameInfo], 'w');

  if(fidInfo > 0)
    fprintf(fidInfo, "[script_240926_genIcarusChips] info:\n");
    fprintf(fidInfo, "====================================\n\n");
    fprintf(fidInfo, " +++ begin: date of generation: +++\n\n ");
    fprintf(fidInfo, " %s", date); fprintf(fidInfo, "\n\n");
    fprintf(fidInfo, " +++++ end: date of generation: +++\n\n");
    fprintf(fidInfo, " +++ begin: signaling bits: +++\n\n");
    fprintf(fidInfo, "  binary:             ");
    fprintf(fidInfo, "% d", signaling_bits); fprintf(fidInfo, "\n");
    fprintf(fidInfo, "  binary_reverse:     ");
    fprintf(fidInfo, "% d", signaling_bits(1,end:-1:1)); fprintf(fidInfo, "\n\n");
    fprintf(fidInfo, "  decimal:            ");
    fprintf(fidInfo, "% d", fct_bin2uint(signaling_bits)); fprintf(fidInfo, "\n");
    fprintf(fidInfo, "  decimal_reverse:    ");
    fprintf(fidInfo, "% d", fct_bin2uint(signaling_bits(1,end:-1:1))); fprintf(fidInfo, "\n\n");
    fprintf(fidInfo, "  hexadecimal:         ");
    fprintf(fidInfo, "%s", dec2hex(fct_bin2uint(signaling_bits))); fprintf(fidInfo, "\n");
    fprintf(fidInfo, "  hexadecimal_reverse: ");
    fprintf(fidInfo, "%s", dec2hex(fct_bin2uint(signaling_bits(1,end:-1:1)))); fprintf(fidInfo, "\n\n");
    fprintf(fidInfo, " +++++ end: signaling bits: +++\n\n");
    fprintf(fidInfo, " +++ begin: spread code: +++\n\n");
    spreadTxt = reshape([spreading_code, 0], [32, 32])';
    idxSC     = 0;

    while idxSC < 31
      idxSC = idxSC + 1;
      fprintf(fidInfo, " ");
      fprintf(fidInfo, "%3d", spreadTxt(idxSC, :));
      fprintf(fidInfo, "\n");
    end

    fprintf(fidInfo, " ");
    fprintf(fidInfo, "%3d", spreadTxt(idxSC, 1:end-1));
    fprintf(fidInfo, "\n\n");
    fprintf(fidInfo, " +++++ end: spread code: +++\n\n");
    fprintf(fidInfo, " +++ begin: chip set properties: +++\n\n");
    fprintf(fidInfo, "                | amount of chips | address width\n");
    fprintf(fidInfo, "  --------------+-----------------+---------------\n");
    fprintf(fidInfo, "  pilot/payload | %15d | %13d\n", nChipsPilotAndPayload, addrWidthPilotAndPayload);
    fprintf(fidInfo, "  sync preamble | %15d | %13d\n", nChipsPreamble, addrWidthPreamble);
    fprintf(fidInfo, "      signaling | %15d | %13d\n\n", nChipsSignaling, addrWidthSignaling);
    fprintf(fidInfo, " +++++ end: chip set properties: +++\n\n");
    fclose(fidInfo);
  else
    fprintf("[script_240926_genIcarusChips] unable to generate %s\n", fNameInfo);
  end

 %  +++++ end: echo data parameters +++ %%

