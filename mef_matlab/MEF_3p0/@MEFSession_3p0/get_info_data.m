function [sess_info, unit] = get_info_data(this)
% MEFSESSION_3P0.GET_INFO_DATA get sesion information from data
%
% Syntax:
%   [sessionifo, unit] = get_info_data(this)
%
% Input(s):
%   this            - [obj] MEFSession_3p0 object
%
% Output(s):
%   unit            - [str] unit of begin_stop: 'Index' (default), 'uUTC',
%                     'Second', 'Minute', 'Hour', and 'Day'
%   sess_info       - [table] N x 13 tabel: 'ChannelName', 'SamplingFreq',
%                     'Begin', 'Stop', 'Samples' 'IndexEntry',
%                     'DiscountinuityEntry', 'SubjectEncryption',
%                     'SessionEncryption', 'DataEncryption', 'Version',
%                     'Institution', 'SubjectID', 'AcquistitionSystem',
%                     'CompressionAlgorithm', where N is the number of
%                     channels.
%
% Example:
%
% Note:
%   This function obtains information about the session from the data
%   directly.  Other information, such as session directory and password,
%   should be provided via MEFSession_2p1 object.
%
% References:
%
% See also MEFSession_3p0, get_sessinfo.

% =========================================================================
% main
% =========================================================================
% sess_path = this.SessionPath;
% pw = this.Password;
var_names = {'ChannelName', 'SamplingFreq', 'Begin', 'Stop', 'Samples',...
    'IndexEntry', 'DiscountinuityEntry', 'SubjectEncryption',...
    'SessionEncryption', 'DataEncryption', 'Version', 'Institution',...
    'SubjectID', 'AcquisitionSystem', 'CompressionAlgorithm'};
var_types = {'string', 'double', 'double', 'double', 'double', 'double',...
    'double', 'logical', 'logical', 'logical', 'string', 'string', 'string',...
    'string', 'string'};

% chan_list = dir(fullfile(sess_path, '*.mef')); % assume all channel data in one dir

% get the metadata
metadata = this.MetaData;
if isempty(metadata)
    metadata = this.read_mef_session_metadata_3p0(this.SessionPath);
    this.MetaData = metadata;
end % if

num_chan = metadata.number_of_time_series_channels; % number of channels
if num_chan < 1 % no time series channel
    sess_info = table;
    unit = '';
else % if
    unit = 'uUTC';
    sz = [num_chan, numel(var_names)];
    fp = fullfile(metadata.path, metadata.name); % session path of channels
    ts_channel = metadata.time_series_channels; % structure of time-series channel
    pw = this.processPassword(this.Password); % password
    sess_info = table('size', sz, 'VariableTypes', var_types,...
        'VariableNames', var_names);
    for k = 1:num_chan
        tsc_k = ts_channel(k); % kth channel of time series
        fn_k = [tsc_k.name, '.', tsc_k.extension]; % channel name
        % header info
        header_k = this.readHeader(fullfile(fp, fn_k), pw);
        mef_ver = sprintf('%d.%d', header_k.mef_version_major,...
            header_k.mef_version_minor);
        % analysis discountinuity
        mef3 = MultiscaleElectrophysiologyFile_3p0(fp, fn_k,...
            'Level1Password', this.Password.Level1Password,...
            'Level2Password', this.Password.Level2Password,...
            'AccessLevel', this.Password.AccessLevel);
        seg_cont_k = mef3.analyzeContinuity;
        
        
        sess_info.ChannelName(k)  = tsc_k.name;
        sess_info.SamplingFreq(k) = tsc_k.metadata.section_2.sampling_frequency;
        sess_info.Begin(k)        = tsc_k.earliest_start_time;
        sess_info.Stop(k)         = tsc_k.latest_end_time;
        sess_info.Samples(k)      = tsc_k.metadata.section_2.number_of_samples;
        % number of data blocks in each channel
        sess_info.IndexEntry(k)   = tsc_k.metadata.section_2.number_of_blocks; 
        
        sess_info.DiscountinuityEntry(k) = height(seg_cont_k);
        
        % TODO: NA in MEF 3.0
        sess_info.SubjectEncryption(k)   = false;
        sess_info.SessionEncryption(k)   = false;
        sess_info.DataEncryption(k)      = false;
        
        sess_info.Version(k)      = mef_ver;
        sess_info.Institution(k)  = tsc_k.metadata.section_3.recording_location;
        sess_info.SubjectID(k)    = tsc_k.metadata.section_3.subject_ID;
        
        % TODA: NA in MEF 3.0
        sess_info.AcquisitionSystem(k) = 'not available';
        sess_info.CompressionAlgorithm(k) = 'not available';
    end % for
end % if

end

% [EOF]