function cktnetlist = MVS_1_0_1_9_inverter_ckt()
%function cktnetlist = MVS_1_0_1_9_inverter_ckt()
%This function returns a cktnetlist structure for an inverter using MVS model
%
%The circuit
%   An CMOS inverter made of an N-type and a P-type MVS MOS devices.
%
%To see the schematic of this circuit, run:
%
% showimage('SHinverter.jpg');
%
%Examples (TODO: untested)
%--------
%
% % set up DAE %
% DAE = MNA_EqnEngine(MVS_1_0_1_9_inverter_ckt);
%
% % DC sweep %
% swp = dot_dcsweep(DAE, [], 'Vin:::E', 0, 1, 20);
% feval(swp.plot, swp);
%
%See also
%--------
% 
% add_element, supported_ModSpec_devices[TODO], DAEAPI[TODO], DAE[TODO]
% dot_dcsweep
%

%
% Author: Tianshi Wang, 2014/01/30



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Type "help MAPPlicense" at the MATLAB/Octave prompt to see the license      %
%% for this software.                                                          %
%% Copyright (C) 2008-2013 Jaijeet Roychowdhury <jr@berkeley.edu>. All rights  %
%% reserved.                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % ckt name
    cktnetlist.cktname = 'MVS inverter';

    % nodes (names)
    cktnetlist.nodenames = {'vdd', 'in', 'out'};
    cktnetlist.groundnodename = 'gnd';

    VddDC = 1;
    VinDC = 0;
    CL = 3e-15;
	RL = 1e9;

	% input function for Vin
	Vinfunc = @(t, args) pulse(t, args.td, args.thi, args.tfs, args.tfe); 
	Vinargs.td = 0; Vinargs.thi = 1e-12; Vinargs.tfs = 50e-12; Vinargs.tfe = 51e-12;

    % vddElem
    cktnetlist = add_element(cktnetlist, vsrcModSpec(), 'Vdd', {'vdd', 'gnd'}, {}, {{'E',...
    {'DC', VddDC}}});

    % vinElem
    cktnetlist = add_element(cktnetlist, vsrcModSpec(), 'Vin', {'in', 'gnd'}, {}, {{'E',...
    {'DC', VinDC}, {'TRAN', Vinfunc, Vinargs}}});

    % nmosElem
    cktnetlist = add_element(cktnetlist, MVS_1_0_1_9_ModSpec(), 'NMOS', {'out', 'in', 'gnd', 'gnd'}, ...
    {{'Type', 1}, {'W', 1e-4}, {'Lgdr', 32e-7}, {'dLg', 9e-7}, {'Cg', 2.57e-6},...
   	{'Beta', 1.8}, {'Alpha', 3.5}, {'Tjun', 300}, {'Cif', 1.38e-12}, {'Cof', 1.47e-12},...
   	{'phib', 1.2}, {'Gamma', 0.1}, {'mc', 0.2}, {'CTM_select', 1}, {'Rs0', 100},...
   	{'Rd0', 100}, {'n0', 1.68}, {'nd', 0.1}, {'vxo', 1.2e7}, {'Mu', 200}, {'Vt0', 0.4}, {'delta', 0.15}});

    % pmosElem
    cktnetlist = add_element(cktnetlist, MVS_1_0_1_9_ModSpec(), 'PMOS', {'vdd', 'in', 'out', 'vdd'}, ...
    {{'Type', -1}, {'W', 1.0e-4}, {'Lgdr', 32e-7}, {'dLg', 8e-7}, {'Cg', 2.57e-6},...
   	{'Beta', 1.8}, {'Alpha', 3.5}, {'Tjun', 300}, {'Cif', 1.38e-12}, {'Cof', 1.47e-12},...
   	{'phib', 1.2}, {'Gamma', 0.1}, {'mc', 0.2}, {'CTM_select', 1}, {'Rs0', 100},...
   	{'Rd0', 100}, {'n0', 1.68}, {'nd', 0.1}, {'vxo', 7542204}, {'Mu', 165}, {'Vt0', 0.5535}, {'delta', 0.15}}); 

    % clElem
    cktnetlist = add_element(cktnetlist, capModSpec(), 'CL', {'out', 'gnd'}, ...
    {{'C', CL}}, {});

    % rlElem
    % cktnetlist = add_element(cktnetlist, resModSpec(), 'RL', {'out', 'gnd'}, ...
    % {{'R', RL}}, {});
end
