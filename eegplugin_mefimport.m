function vers = eegplugin_mefimport(fig, try_strings, catch_strings)
% EEGPLUGIN_MEFIMPORT EEGLAB plugin for importing MSEL-UP .MEF file
% 
% Syntax:
%   vers = eegplugin_mefimport(fig, try_strings, catch_strings)
%
% Input(s):
%   fig            - [num]  handle to EEGLAB figure
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
% $Revision: 0.2 $  $Date: Tue 05/07/2019  9:39:59.429 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% version info
% ------------
vers='mefimport0.2';

% parse inputs
% ------------
q = parseInputs(fig, try_strings, catch_strings);
fig = q.fig;
try_strings = q.try_strings;
catch_strings = q.catch_strings;

% Setup menus of importing MEF files into EEGLAB
% ----------------------------------------------
% find import data menu
importmenu = findobj(fig,'tag','import data');

% menu callback
cmd_mefimp = [try_strings.no_check, 'EEG = pop_mefimport;',...
    catch_strings.new_and_hist];

% create menus in EEGLab
uimenu(importmenu, 'label', 'Import UP-MSEL .MEF file', 'callback',...
    cmd_mefimp, 'separator', 'on', 'position',length(get(menu,'children'))+1);

end % function
 
% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(fig, try_strings, catch_strings)

p = inputParser;
p.addRequired('fig', @isobject);
p.addRequired('try_strings', @isstruct);
p.addRequired('catch_strings', @isstruct);

p.parse(fig, try_strings, catch_strings);
q.fig = p.Results.fig;
q.try_strings = p.Results.try_strings;
q.catch_strings = p.Results.catch_strings;

end % function

% [EOF]