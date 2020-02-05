function bid = readBlockIndexData(this, varargin)
% MultiscaleElectrophysiologyFile_3p0.READBLOCKINDEXDATA read block index data from MEF 3.0 file
% 
% Syntax:
%   bid = readBlockIndexData(this)
%   bid = readBlockIndexData(__, channel)
% 
% Imput(s):
%   this            - [obj] MultiscaleElectrophysiologyFile_3p0 object
%   channel         - [struct] (opt) channel metadata structure
% 
% Output(s):
%   bid             - [N x 7 table] N is the number of blocks indexed. Each
%                     row has seven varialbes:
%                     Segment       : [num] the INDEX of segment of the 
%                                     recorded data block
%                     Block         : [num] the INDEX of the block in the 
%                                     segment
%                     FileOffset    : [num] offset in bytes of the 1st data
%                                     in the block in MEF 3.0 file
%                     StartTime     : [num] lower bound of the first sample
%                                     time recorded in the block (in uUTC)
%                     EndTime       : [num] upper bound of the last sample
%                                     time recorded in the block (in uUTC)
%                     StartSample   : [num] INDEX of the 1st sample of the
%                                     block in MEF file (1st sample index
%                                     in the file is zero in MEF file;
%                                     change to Matlab convention to start
%                                     at one)
%                     NumOfSamples  : [num] number of samples in the block
% 
% Note:
%   All indexes start at one (1), using matlab convention.
% 
%   See the details of MEF file at https://msel.mayo.edu/codes.html.
% 
% See also .

% =========================================================================
% parse inputs
% =========================================================================

end

% =========================================================================
% subroutines
% =========================================================================

% [EOF]