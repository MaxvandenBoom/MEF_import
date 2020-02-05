function seg_cont = analyzeContinuity(this, varargin)
% MultiscaleElectrophysiologyFile_3p0.analyzeContinuity analyze continuity of sampling in MEF 3.0 data
%   
% Syntax:
%   seg_cont = analyzeContinuity(this)
%   seg_cont = analyzeContinuity(this, wholename)
%   seg_cont = analyzeContinuity(this, wholename, password)
% 
% Imput(s):
%   this            - [obj] MultiscaleElectrophysiologyFile object
%   wholename       - [str] (opt) filepath + filename of MEF file
%   access_level    - [num] (opt) access level of data
%   password        - [str] (opt) character string of password
% 
% Output(s):
%   seg_cont        - [table] N x 7, information of segments of continuity
%                     of sampling in the data file.  The 7 variable names
%                     are:
%                     BlockStart        : [num] index of start data block
%                     BlockEnd          : [num] index of end data block
%                     SampleTimeStart   : [num] sample time of start
%                                         recording (in uUTC)
%                     SampleTimeEnd     : [num] sample time of end
%                                         recording (in uUTC)
%                     SampleIndexStart  : [num] sample index of start
%                                         recording
%                     SampleIndexEnd    : [num] sample index of end
%                                         recording
%                     SegmentLength     : [num] the total number of samples
%                                         in this segment of continuity
%                                         sampling
% 
% Note:
%   See the details of MEF 3.0 file at https://msel.mayo.edu/codes.html
% 
% See also .

% Copyright 2020 Richard J. Cui. Created: Wed 02/05/2020 10:19:17.599 AM
% $Revision: 0.1 $  $Date: Wed 02/05/2020 10:19:17.599 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

end

% [EOF]