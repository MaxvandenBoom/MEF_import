% Compile mex files required to process MEF files

% Copyright 2019-2020 Richard J. Cui. Created: Wed 05/29/2019  9:49:29.694 PM
% $Revision: 0.3 $  $Date: Fri 01/31/2020 11:39:08.995 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% MEF 2.0
% -------

% MEF 2.1
% -------
cd mef_2p1/ % assume 'mef_2p1' is the subdirectory

fprintf('===== Processing MEF 2.1 format =====\n')
fprintf('Building read_mef_header_2p1.mex*\n')
mex -output read_mef_header_2p1 read_mef_header_mex_2p1.c mef_lib_2p1.c

fprintf('\n')
fprintf('Building decompress_mef_2p1.mex*\n')
mex -output decompress_mef_2p1 decompress_mef_mex_2p1.c mef_lib_2p1.c

cd ..

% MEF 3.0
% -------
cd mef_3p0/ % assume 'mef_3p0' is the subdirectory

fprintf('\n')
fprintf('===== Processing MEF 3.0 format =====\n')
fprintf('Building read_mef_session_metadata_3p0.mex*\n')
mex -output read_mef_session_metadata_3p0 read_mef_session_metadata.c meflib/meflib/meflib.c meflib/meflib/mefrec.c matmef_mapping.c mex_datahelper.c

fprintf('\n')
fprintf('Building read_mef_ts_data_3p0.mex*\n')
mex -output read_mef_ts_data_3p0 read_mef_ts_data.c matmef_data.c meflib/meflib/meflib.c meflib/meflib/mefrec.c

cd ..

% [EOF]