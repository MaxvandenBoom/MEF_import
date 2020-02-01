% READ_MEF_TS_DATA_3P0 Read the MEF3 data from a time-series channel
%	
% Syntax:
%   data = read_mef_ts_data_3p0(channel_path)
%   data = read_mef_ts_data_3p0(__, password)
%   data = read_mef_ts_data_3p0(__, password, range_type)
%   data = read_mef_ts_data_3p0(__, password, range_type, begin, stop)
% 
% Input(s):
%   channel_path    - [char] path (absolute or relative) to the MEF3 
%                     channel folder
%   password        - [char] (opt) password to the MEF3 data; Pass empty 
%                     string/variable if not encrypted (default = [])
%   range_type      - [char] (opt) modality that is used to define the 
%                     data-range to read, either 'time' or 'samples'
%                     (default = samples)
%   begin           - [array] (opt) Start-point for the reading of data 
%                     (either as a timepoint or samplenumber); Pass -1 to
%                     start at the first sample of the timeseries. if
%                     range_type is 'smaples', the first sample begins at 1
%                     using Matlab convention. (default = -1)
%   stop            - [array] (opt) End-point to stop the reading data
%                     (either as a timepoint or samplenumber); Pass -1 as
%                     value to end at the last sample of the timeseries
%                     (default = -1)
%
% Output(s): 
%   data            - A vector of doubles holding the channel data
%
% Note:
%   When the rangeType is set to 'samples', the function simply returns the
%   samples as they are found (consecutively) in the datafile, without any
%   regard for time or data gaps; Meaning that, if there is a time-gap
%   between samples, then these will not appear in the result returned. In
%   contrast, the 'time' rangeType will return the data with NaN values in
%   place for the missing samples.
%
% See also .

%   Copyright 2020, Max van den Boom (Multimodal Neuroimaging Lab, Mayo
%   Clinic, Rochester MN) <https://github.com/MaxvandenBoom/matmef>.
%   Adapted from PyMef (by Jan Cimbalnik, Matt Stead, Ben Brinkmann, and
%   Dan Crepeau)
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. This program is distributed in the hope that
%   it will be useful, but WITHOUT ANY WARRANTY; without even the implied
%   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%   the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <https://www.gnu.org/licenses/>.

% Copyright 2020 Richard J. Cui. Adapted: Fri 01/31/2020 11:59:20.073 PM
% $Revision: 0.2 $  $Date: Sat 02/01/2020  4:42:56.294 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% [EOF]