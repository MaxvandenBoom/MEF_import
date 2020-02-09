function record_offset = getSessionRecordOffset(this, unit)
% MEFSESSION.GETSESSIONRECORDOFFSET get offset time of recording in specified unit
% 
% Syntax:
%   record_offset = getSessionRecordOffset(this, unit)
% 
% Input(s):
%   this            - [obj] MEFSession_2p1 object
%   unit            - [char] unit of the output offset
% 
% Output(s):
%   record_offset   - [num] recording offset of time
% 
% Note:
% 
% Seaa slso .

% Copyright 2020 Richard J. Cui. Created:Sat 02/08/2020 10:24:41.396 PM
% $Revision: 0.1 $  $Date: Sat 02/08/2020 10:24:41.396 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================
q = parseInputs(this, unit);
unit = q.unit;

% =========================================================================
% main
% =========================================================================
this.setContinuity(this.SessionContinuity);
record_offset = this.getRecordOffset(unit); % this function needs Continuity

end % funciton

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(varargin)

% default
expected_ut = {'index', 'uutc', 'msec', 'second', 'minute', 'hour', 'day'};

% parse rules
p = inputParser;
p.addRequired('this', @isobject);
p.addRequired('unit',  @(x) any(validatestring(x, expected_ut)));

% parse and return the results
p.parse(varargin{:});
q = p.Results;

end % function

% [EOF]