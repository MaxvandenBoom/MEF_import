% Compile mex files required to process MEF files

% Copyright 2019-2020 Richard J. Cui. Created: Wed 05/29/2019  9:49:29.694 PM
% $Revision: 0.4 $  $Date: Sun 02/02/2020  4:51:32.145 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% find the directory of make_mex_mef file
% =========================================================================
cur_dir = pwd; % current directory
p = fileparts(mfilename('fullpath')); % director of make_mex_mef.m

% =========================================================================
% processing mex for MEF 2.0 file
% =========================================================================

% =========================================================================
% processing mex for MEF 2.1 file
% =========================================================================
cd([p, '/mef_2p1/']) % assume 'mef_2p1' is the subdirectory

fprintf('===== Processing MEF 2.1 format =====\n')
fprintf('Building read_mef_header_2p1.mex*\n')
mex -output read_mef_header_2p1 read_mef_header_mex_2p1.c mef_lib_2p1.c

fprintf('\n')
fprintf('Building decompress_mef_2p1.mex*\n')
mex -output decompress_mef_2p1 decompress_mef_mex_2p1.c mef_lib_2p1.c

cd(cur_dir)

% =========================================================================
% processing mex for MEF 3.0 file
% =========================================================================
cd([p, '/mef_3p0/matmef/']) % assume 'mef_3p0' is the subdirectory

fprintf('\n')
fprintf('===== Processing MEF 3.0 format =====\n')
fprintf('Building read_mef_session_metadata_3p0.mex*\n')
mex -output read_mef_session_metadata read_mef_session_metadata.c meflib/meflib/meflib.c meflib/meflib/mefrec.c matmef_mapping.c mex_datahelper.c

fprintf('\n')
fprintf('Building read_mef_ts_data_3p0.mex*\n')
mex -output read_mef_ts_data read_mef_ts_data.c matmef_data.c meflib/meflib/meflib.c meflib/meflib/mefrec.c

cd(cur_dir)

% [EOF]