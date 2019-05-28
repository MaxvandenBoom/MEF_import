function [EEG, com] = pop_mafimport(EEG, varargin)
% POP_MAFIMPORT Import MAF event data into EEGLAB with GUI
% 
% Syntax:
%   [EEG, com] = pop_mafimport(EEG)
%   [EEG, com] = pop_mafimport(EEG, wholename)
%   [EEG, com] = pop_mafimport(EEG, wholename, start_end)
%   [EEG, com] = pop_mafimport(EEG, wholename, start_end, unit)
% 
% Input(s):
%   wholename       - [str] full path and name of MAF file
%   start_end       - [1 x 2 array] (optional) [start time/index, end time/index] of 
%                     the signal to be extracted fromt he file (default:
%                     the entire signal)
%   unit            - [str] (optional) unit of start_end: 'Index' (default), 'uUTC',
%                     'Second', 'Minute', 'Hour', and 'Day'
% 
% Outputs:
%   EEG             - [struct] EEGLab dataset structure. See Note for
%                     addtional information about the details of the
%                     structure.
% Note:
%   The command output [com] is a hidden output that does not have to
% be described in the header
% 
% See also EEGLAB, mafimport, pop_mefimport.

% Copyright 2019 Richard J. Cui. Created: Tue 05/28/2019  3:14:55.269 PM
% $Revision: 0.1 $  $Date: Tue 05/28/2019  3:14:55.269 PM$
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================
% display help if not enough arguments
% ------------------------------------
if nargin == 0
    com = '';
	help mfilename
	return
end % if	

q = parseInputs(EEG, varargin{:});
EEG = q.EEG;
maf_name = q.wholename;
start_end = q.start_end;
unit = q.unit;

% =========================================================================
% main
% =========================================================================
% import MAF structure
% --------------------
if isempty(maf_name)
    % get the filename of MAF
    maf_name = gui_mafimport;
    % if GUI is cancelled
    if isempty(maf_name)
        EEG = [];
        return
    end % if
end % if
mef1 = EEG.etc.maf_data.mef1;
evt_t = mef1.getMAFEvent(maf_name); % event table

% process events from MAF
% -----------------------

% return the command string
% -------------------------
com = sprintf('%s(EEG, [wholename, [start_end, [unit]]])', mfilename);

end

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(varargin)

% defaults
defaultWN = '';
defaultSE = [];
defaultUnit = 'index';
expectedUnit = {'index', 'uutc', 'second', 'minute', 'hour', 'day'};

% parse rules
p = inputParser;
p.addRequired('EEG', @(x) isempty(x) || isstruct(x));
p.addOptional('wholename', defaultWN, @ischar);
p.addOptional('start_end', defaultSE,...
    @(x) isnumeric(x) & numel(x) == 2 & x(1) <= x(2));
p.addOptional('unit', defaultUnit,...
    @(x) any(validatestring(x, expectedUnit)));

% parse and return the results
p.parse(varargin{:});
q = p.Results;

end % function

% [EOF]