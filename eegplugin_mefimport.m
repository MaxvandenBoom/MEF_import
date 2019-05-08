function vers = eegplugin_mefimport(fig,try_strings,catch_strings)
% EEGPLUGIN_MEFIMPORT EEGLAB plugin for importing MSEL-UP .MEF file
% 
% Syntax:
%   vers = eegplugin_mefimport(fig, try_strings, catch_strings)
%
% Input(s):
%   fig            - [integer]  handle to EEGLAB figure
%   try_strings    - [struct] "try" strings for menu callbacks.
%   catch_strings  - [struct] "catch" strings for menu callbacks. 
%
% Output(s):
%
% Example:
%
% Note:
%   With this menu it is possible to import Multiscale Electrophysiology
%   Format (.MEF) files into EEGLAB.
%
% References:
%   https://github.com/benbrinkmann/mef_lib_2_1
% 
% See also .

% Copyright 2019 Richard J. Cui. Created: Sun 04/28/2019  9:51:01.691 PM
% $Revision: 0.1 $  $Date: Sun 04/28/2019  9:51:01.691 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% version info
vers='mefimport0.1';

if nargin < 3
    error('eegplugin_mefimport requires 3 arguments');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup menus of importing .MEF files (website) into EEGLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
importmenu=findobj(fig,'tag','import data');
cmdIMP = [try_strings.no_check, 'EEG = pop_mefimport;', catch_strings.new_and_hist];
uimenu(importmenu,'label','From NPXLab .NPX file',...
    'callback',cmdIMP,'separator','on');

end % function
 
% [EOF]