function [X, t] = import_sess(this, varargin)
% MEFSESSION_2P1.IMPORT_SESS import session of MEF 2.1 data
% 
% Syntax:
%   [X, t] = import_sess(this, begin_stop, bs_unit, sel_chan)
%   [X, t] = import_sess(__, pw)
% 
% Input(s):
%   this            - [obj] MEFSession_2p1 object
%   begin_stop      - [num] 1 x 2 array of begin and stop points of
%                     importing the session
%   bs_unit         - [str] unit of begin_stop: 'uUTC'
%   sel_chan        - [str array] the names of the selected channels
%   bs_unit         - [str] unit of begin_stop: 'uUTC','Index', 'Second', 
%                     'Minute', 'Hour', and 'Day'.
%   pw              - [struct] (para) password structure
%                     .Session      : session password
%                     .Subject      : subject password
%                     .Data         : data password
% 
% Output(s):
%   X               - [num array] M x N array, where M is the number of
%                     channels and N is the number of signals extracted
%   t               - [num] 1 x N array, time indeces of the signals
% 
% Note:
%   Import data from different channels of the session.
% 
% See also importSignal, importSession.

% Copyright 2020 Richard J. Cui. Created: Thu 02/06/2020  3:40:19.634 PM
% $Revision: 0.1 $  $Date: Thu 02/06/2020  3:40:19.634 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================

end

% =========================================================================
% subroutines
% =========================================================================

% [EOF]