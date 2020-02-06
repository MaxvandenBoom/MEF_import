function varargout = get_sessinfo(this)
% MEFSESSION.GET_SESSINFO Get session information from MEF data
%
% Syntax:
%   [channame, start_end, unit, sess_info] = get_sessinfo(this)
% 
% Input(s):
%   this            - [obj] MEFSession object
% 
% Output(s):
%   channame        - [str/cell str] the name(s) of the data channel in the
%                     directory of session. One file name can be in string
%                     or cell string.  If more than one, the names are in
%                     cell string.
%   begin_stop      - [1 x 2 array] [begin time/index, stop time/index] of 
%                     the entire signal
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
% See also MEFSession_2p1, get_info_data.

% Copyright 2020 Richard J. Cui. Created: Fri 01/03/2020  4:19:10.683 PM
% $ Revision: 0.4 $  $ Date: Thu 02/06/2020  1:20:08.343 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% Main process
% =========================================================================
% table of channel info
% ---------------------
[sess_info, unit] = this.get_info_data;

if isempty(sess_info)
    channame = '';
    fs = NaN;
    samples = NaN;
    num_data_block = [];
    num_time_gap = [];
    begin_stop = [];
    unit = '';
    institution = '';
    subj_id = '';
    acq_sys = '';
    comp_alg = '';
    warning('MEFSession_2p1:get_sessinfo',...
        'The session is likely empty.')
else
    this.SessionInformation = sess_info;
    if this.checkSessValid == true
        channame = sess_info.ChannelName';
        fs = unique(sess_info.SamplingFreq);
        samples = unique(sess_info.Samples);
        num_data_block = unique(sess_info.IndexEntry);
        num_time_gap = unique(sess_info.DiscountinuityEntry)-1;
        begin_stop = [unique(sess_info.Begin), unique(sess_info.Stop)];
        institution = unique(sess_info.Institution);
        subj_id = unique(sess_info.SubjectID);
        acq_sys = unique(sess_info.AcquisitionSystem);
        comp_alg = unique(sess_info.CompressionAlgorithm);
    else
        warning('MEFSession_3p0:get_sessinfo',...
            'The session is either empty or the data are not consistent. Please check messages')
        sess_info = table;
        channame = '';
        fs = NaN;
        samples = NaN;
        num_data_block = [];
        num_time_gap = [];
        begin_stop = [];
        unit = '';
        institution = '';
        subj_id = '';
        acq_sys = '';
        comp_alg = '';
    end % if
end % if

% update paras of MEFSession
% --------------------------
this.ChannelName = channame;
this.SamplingFrequency = fs;
this.Samples = samples;
this.DataBlocks = num_data_block;
this.TimeGaps = num_time_gap;
this.BeginStop = begin_stop;
this.Unit = unit;
this.Institution = institution;
this.SubjectID = subj_id;
this.AcquisitionSystem = acq_sys;
this.CompressionAlgorithm = comp_alg;
this.SessionInformation = sess_info;

% =========================================================================
% Output
% =========================================================================
if nargout > 0
    varargout{1} = channame;
end % if
if nargout > 1
    varargout{2} = begin_stop;
end % if
if nargout > 2
    varargout{3} = unit;
end % if
if nargout > 3
    varargout{4} = sess_info;
end % if

end % function MEF_sessinfo

% =========================================================================
% Subroutines
% =========================================================================


% [EOF]