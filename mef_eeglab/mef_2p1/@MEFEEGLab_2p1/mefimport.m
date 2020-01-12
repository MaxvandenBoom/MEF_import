function OUTEEG = mefimport(this, INEEG, varargin)
% MEFEEGLAB_2P1.MEFIMPORT Import MEF 2.1 session data into EEG structure
%
% Usage:
%   OUTEEG = mefimport(this, INEEG)
%   OUTEEG = mefimport(__, begin_stop)
%   OUTEEG = mefimport(__, begin_stop, bs_unit)
%   OUTEEG = mefimport(__, 'SelectedChannel', sel_chan, 'Password', pw)
%
% Input(s):
%   this            - [obj] MEFEEGLab_2p1 object
%   INEEG           - [struct] EEGLab dataset structure. See Note for
%                     addtional information about the details of the
%                     structure.
%   begin_stop      - [1 x 2 array] (optional) [begin time/index, stop
%                     time/index] of the signal to be extracted fromt the
%                     file (default: the entire signal)
%   bs_unit         - [str] (optional) unit of begin_stop: 'uUTC' (default),
%                     'Index', 'Second', 'Minute', 'Hour', and 'Day'
%   sel_chan        - [str array] (para) the names of the selected channels
%                     (default: all channels)
%   pw              - [str] (para) passwords of MEF file
%                     .Subject      : subject password (default - '')
%                     .Session
%                     .Data
% 
% Outputs:
%   OUTEEG           - [struct] EEGLab dataset structure. See Note for
%                      addtional information about the details of the
%                      structure.
% 
% Note:
%   Current version assumes continuous signal.
% 
%   All MEF files in one directory are assumed to be data files for
%   different channels during recording.
% 
%   Details of EEG dataset structure in EEGLab can be found at:
%   https://sccn.ucsd.edu/wiki/A05:_Data_Structures, or see the help
%   information of eeg_checkset.m.
%
% See also eeglab, eeg_checkset, pop_mefimport. 

% Copyright 2019-2020 Richard J. Cui. Created: Wed 05/08/2019  3:19:29.986 PM
% $Revision: 1.2 $  $Date: Fri 01/10/2020  5:42:05.951 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================
q = parseInputs(this, INEEG, varargin{:});
INEEG = q.INEEG;
% begin and stop points
begin_stop = q.begin_stop;
if isempty(begin_stop)
    begin_stop = this.BeginStop;
end % if
% unit
bs_unit = q.bs_unit;
% selected channel
sel_chan = q.SelectedChannel;
if isempty(sel_chan)
    sel_chan = this.ChannelName;
end % if
% password
pw = q.Password;
if isempty(pw)
    pw = this.Password;
end % if

sess_path = this.SessionPath;

% =========================================================================
% convert to EEG structure
% =========================================================================
% set EEG structure
% -----------------
if isempty(INEEG)
    % if EEGLAB is included in pathway, this can be done with eeg_emptyset.m
    OUTEEG = struct('setname', '',...
                 'filename', '',...
                 'filepath', '',...
                 'subject','',...
                 'group', '',...
                 'condition', '',...
                 'session', [],...
                 'comments', '',...
                 'nbchan', 0,...
                 'trials',0,...
                 'pnts', 0,...
                 'srate', 1,...
                 'xmin', 0,...
                 'xmax', 0,...
                 'times', [],...
                 'data', [],...
                 'icaact', [],...
                 'icawinv', [],...
                 'icasphere', [],...
                 'icaweights', [],...
                 'icachansind', [],...
                 'chanlocs', [],...
                 'urchanlocs',[],...
                 'chaninfo', [],...
                 'ref', [],...
                 'event', [],...
                 'urevent', [],...
                 'eventdescription', {},...
                 'epoch', [],...
                 'epochdescription', {},...
                 'reject', [],...
                 'stats', [],...
                 'specdata', [],...
                 'specicaact', [],...
                 'splinefile', '',...
                 'icasplinefile', '',...
                 'dipfit', [],...
                 'history', '',...
                 'saved', 'no',...
                 'etc', []);
else
    OUTEEG = INEEG; % careful, if don't clear working space
end % if

% setname
% -------
OUTEEG.setname = sprintf('Data from %s', this.Institution);

% subject
% -------
OUTEEG.subject = thsi.SubjectID;

% trials
% ------
OUTEEG.trials = 1; % assume continuous recording, not epoched

% nbchan
% ------
% MEF records each channel in different file
OUTEEG.nbchan = numel(sel_chan);

% srate
% -----
OUTEEG.srate = this.SamplingFrequency; % in Hz

% xmin, xmax (in second)
% ----------------------
% continuous data, according to the segment to be imported
if isempty(begin_stop)
    num_samples = this.Samples;
    OUTEEG.xmin = this.SampleIndex2Time(1, 'second');
    OUTEEG.xmax = this.SampleIndex2Time(num_samples, 'second');
else
    switch lower(unit)
        case 'index'
            num_samples = diff(begin_stop)+1;
            OUTEEG.xmin = this.SampleIndex2Time(begin_stop(1), 'second');
            OUTEEG.xmax = this.SampleIndex2Time(begin_stop(2), 'second');
        case 'second'
            OUTEEG.xmin = begin_stop(1);
            OUTEEG.xmax = begin_stop(2);
            bs_index = this.SampleTime2Index(begin_stop, bs_unit);
            num_samples = diff(bs_index)+1;
        otherwise
            bs_index = mef1.SampleTime2Index(begin_stop, bs_unit);
            num_samples = diff(bs_index)+1;
            OUTEEG.xmin = this.SampleIndex2Time(bs_index(1), 'second');
            OUTEEG.xmax = this.SampleIndex2Time(bs_index(2), 'second');
    end % switch
end % if

% times (in second)
% ------------------------------------------------------------
OUTEEG.times = linspace(OUTEEG.xmin, OUTEEG.xmax, num_samples); 

% pnts
% ----
OUTEEG.pnts = num_samples;

% comments
% --------
% TODO
OUTEEG.comments = sprintf('Acauisition system - %s\ncompression algorithm - %s',...
    this.AcquisitionSystem, this.CompressionAlgorithm);

% saved
% -----
OUTEEG.saved = 'no'; % not saved yet

% data and chanlocs
% -----------------
data = this.importSession(begin_stop, bs_unit, sess_path,...
    'SelectedChannel', sel_chan, 'Password', pw);
OUTEEG.data = data;
% chanlocs
% --------
chanlocs = struct([]);
channame = this.ChannelName;
for k = 1:nueml(channame)
    chanlocs(k).labels = convertStringsToChars(channame(k));
end % for
OUTEEG.chanlocs = chanlocs;

end % function

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(varargin)

% defaults
default_bs = [];
default_ut = 'uutc';
expected_ut = {'index', 'uutc', 'second', 'minute', 'hour', 'day'};
default_sc = [];
default_pw = struct('subject', '', 'session', '', 'data', '');

% parse rules
p = inputParser;
p.addRequired('this', @(x) isobject(x) & strcmpi(class(x), 'MEFEEGLab_2p1'));
p.addRequired('INEEG', @(x) isempty(x) || isstruct(x));
p.addOptional('begin_stop', default_bs,...
    @(x) isnumeric(x) & numel(x) == 2 & x(1) <= x(2));
p.addOptional('unit', default_ut,...
    @(x) any(validatestring(x, expected_ut)));
p.addParameter('SelectedChannel', default_sc, @isstring) % must be string array
p.addParameter('Password', default_pw, @isstruct);

% parse and return the results
p.parse(varargin{:});
q = p.Results;

end % function

% [EOF]
