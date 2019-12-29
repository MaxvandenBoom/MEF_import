function [x, t] = importSignal(this, varargin)
% MULTISCALEELECTROPHYSIOLOGYFILE_2P1.IMPORTMEF Import MEF 2.1 data into MATLAB
% 
% Syntax:
%   [x, t] = importSignal(this)
%   [x, t] = importSignal(this, start_end)
%   [x, t] = importSignal(this, start_end, st_unit)
% 
% Imput(s):
%   this            - [obj] MultiscaleElectrophysiologyFile_2p1 object
%   start_end       - [1 x 2 array] [start time/index, end time/index] of 
%                     the signal to be extracted fromt he file (default:
%                     the entire signal)
%   st_unit         - [str] unit of start_end: 'Index' (default), 'uUTC',
%                     'Second', 'Minute', 'Hour', and 'Day'
% 
% Output(s):
%   x               - [num array] extracted signal
%   t               - [num array] time indices of the signal in the file
% 
% Note:
% 
% See also .

% Copyright 2019 Richard J. Cui. Created: Mon 04/29/2019 10:33:58.517 PM
% $Revision: 0.7 $  $Date: Sun 12/29/2019  4:43:20.432 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================
q = parseInputs(this, varargin{:});
start_end = q.start_end;
st_unit = q.st_unit;
switch lower(st_unit)
    case 'index'
        se_index = start_end;
    otherwise
        se_index = this.SampleTime2Index(start_end, st_unit);
end % switch
% check
if se_index(1) < 1
    se_index(1) = 1; 
    fprintf('WARNING: Reqested data samples before the recording are discarded.\n')
end % if
if se_index(2) > this.Header.number_of_samples
    se_index(2) = this.Header.number_of_samples; 
    fprintf('WARNING: Reqested data samples after the recording are discarded.\n')
end % if
wholename = fullfile(this.FilePath, this.FileName);

% verbose
num_samples = diff(start_end)+1;
if num_samples > 2^20
    verbo = true; 
else
    verbo = false;
end % if

% =========================================================================
% load the data
% =========================================================================
pw = this.SessionPassword;
if verbo, fprintf('-->Loading...'), end % if
x = decompress_mef(wholename, se_index(1), se_index(2), pw);
x = double(x(:)).'; % change to row vector
% find the indices corresponding to physically collected data
if nargout == 2
    t = se_index(1):se_index(2);
end % if
if verbo, fprintf('Done!\n'), end % if

end

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(this, varargin)

% defaults
start_ind = this.SampleTime2Index(this.Header.recording_start_time);
end_ind = this.SampleTime2Index(this.Header.recording_end_time);
defaultSE = [start_ind, end_ind];
defaultSTUnit = 'index';
expectedSTUnit = {'index', 'uutc', 'second', 'minute', 'hour', 'day'};

% parse rules
p = inputParser;
p.addRequired('this', @isobject);
p.addOptional('start_end', defaultSE,...
    @(x) isnumeric(x) & numel(x) == 2 & x(1) <= x(2));
p.addOptional('st_unit', defaultSTUnit,...
    @(x) any(validatestring(x, expectedSTUnit)));

% parse and return the results
p.parse(this, varargin{:});
q.start_end = p.Results.start_end;
q.st_unit = p.Results.st_unit;

end % function

% [EOF]
