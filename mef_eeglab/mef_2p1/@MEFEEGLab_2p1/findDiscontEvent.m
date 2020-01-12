function dc_event = findDiscontEvent(this, start_end, unit)
% MEFEEGLAB_2P1,FINDDISCONTEVENT process dicountinuity events
% 
% Syntax:
%   dc_event = findDiscontEvent(this)
%   dc_event = findDiscontEvent(__, start_end)
%   dc_event = findDiscontEvent(__, start_end, unit)
% 
% Input(s):
%   this            - [obj] MEFEEGLab_2p1 object
%   start_end       - [1 x 2 array] (optional) [start time/index, end time/index] of 
%                     the signal to be extracted from the file (default:
%                     the entire signal)
%   unit            - [str] (optional) unit of start_end: 'Index' (default), 'uUTC',
%                     'Second', 'Minute', 'Hour', and 'Day'
% Output(s):
%   dc_event        - [struct] event structure
% 
% Note:
% 
% See also .

% Copyright 2020 Richard J. Cui. Created: Sun 01/12/2020  2:35:48.393 PM
% $Revision: 0.1 $  $Date: Sun 01/12/2020  2:35:48.393 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================
q = parseInputs(this, start_end, unit);
start_end = q.start_end;
if isempty(start_end)
    start_end = this.StartEnd;
end % if
unit = q.unit;

% =========================================================================
% main process
% =========================================================================
% converte start_end to index if not
if strcmpi(unit, 'index')
    se_ind = start_end;
else
    se_ind = this.SampleTime2Index(start_end, unit);
end % if

% find the continuity blocks
seg_cont = this.Continuity;
cont_ind = se_ind(1) <= seg_cont.SampleIndexEnd...
    & se_ind(2) >= seg_cont.SampleIndexStart;
dc_start = seg_cont.SampleIndexStart(cont_ind); % discont start in index

% find the relative index of start of discontinuity
rel_dc = dc_start - se_ind(1);
rel_dc(rel_dc < 0) = []; % get rid of index < 0

% construct the event of EEGLAB
num_event = numel(rel_dc);
t = table('Size', [num_event, 3], 'VariableTypes', {'string', 'double', 'double'},...
    'VariableNames', {'type', 'latency', 'urevent'});
t.type = repmat('Discont', num_event, 1);
t.latency = rel_dc(:);
t.urevent = (1:num_event)';

% output
dc_event = table2struct(t);

end

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(varargin)

% defaults
defaultSE = [];
defaultUnit = 'uutc';
expectedUnit = {'index', 'uutc', 'second', 'minute', 'hour', 'day'};

% parse rules
p = inputParser;
p.addRequired('this', @(x) isobject(x) || strcmpi(class(x), 'MEFEEGLab_2p1'));
p.addOptional('start_end', defaultSE,...
    @(x) isnumeric(x) & numel(x) == 2 & x(1) <= x(2));
p.addOptional('unit', defaultUnit,...
    @(x) any(validatestring(x, expectedUnit)));

% parse and return the results
p.parse(varargin{:});
q = p.Results;

end % function

% [EOF]