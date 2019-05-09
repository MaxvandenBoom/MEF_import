function EEG = mefimport(EEG, filepath, filename, varargin)
% MEFIMPORT Import MEF data into EEG structure
%
% Usage:
%   EEG = mefimport(EEG, filepath, filename)
%   EEG = mefimport(EEG, filepath, filename, start_end)
%   EEG = mefimport(EEG, filepath, filename, start_end, unit)
%
% Input(s):
%   filepath        - [str] full file path
%   filename        - [str/cell str] the name(s) of the data files in the
%                     directory of 'filepath'. One file name can be in
%                     string or cell string.  More than one, the names are
%                     in cell string.
%   start_end       - [1 x 2 array] (optional) [start time/index, end time/index] of 
%                     the signal to be extracted fromt he file (default:
%                     the entire signal)
%   unit            - [str] (optional) unit of start_end: 'Index' (default), 'uUTC',
%                     'Second', 'Minute', 'Hour', and 'Day'
% 
% Outputs:
%   EEG             - [struct] EEGLab dataset structure. See Note for
%                     addtional information about the details of the
%                     structure.
% 
% Note:
%   All MEF files in one directory are assumed to be data files for
%   different channels during recording.
% 
%   Details of EEG dataset structure in EEGLab can be found at:
%   https://sccn.ucsd.edu/wiki/A05:_Data_Structures, or see the help
%   information of eeg_checkset.m.
%
% See also: 
%   eeglab, eeg_checkset. 

% Copyright 2019 Richard J. Cui. Created: Wed 05/08/2019  3:19:29.986 PM
% $Revision: 0.1 $  $Date: Wed 05/08/2019  3:19:29.986 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================
q = parseInputs(EEG, filepath, filename, varargin{:});
EEG = q.EEG;
filepath = q.filepath;
filename = q.filename;
start_end = q.start_end;
unit = q.unit;

if ischar(filename)
    fname = {filename};
else
    fname = filename;
end % if
mef = MultiscaleElectrophysiologyFile(filepath, fname{1});

% set EEG structure
% -----------------
if isempty(EEG)
    EEG = struct('setname', '',...
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
end % if

% =========================================================================
% convert to EEG structure
% =========================================================================
% setname
% -------
EEG.setname = sprintf('Data from %s', mef.Header.institution);

% filename
% --------
EEG.filename = filename;

% filepath
% --------
EEG.filepath = filepath;

% trials
% ------
EEG.trials = 1; % assume continuous recording, not epoched

% pnts
% ----
EEG.pnts = mef.Header.number_of_samples;

% nbchan
% ------
% MEF records each channel in different file
EEG.nbchan = numel(fname);

% srate
% -----
EEG.srate = mef.Header.sampling_frequency; % in Hz

% xmin, xmax
% ----------
% continuous data, the entire signal is one epoch
EEG.xmin = mef.SampleIndex2Time(1, 'second');
EEG.xmax = mef.SampleIndex2Time(mef.Header.number_of_samples, 'second');

% times
% -----
if isempty(start_end)
    [~, t] = mef.importSignal;
else
    [~, t] = mef.importSignal(start_end, unit);
end % if
EEG.times = (t-1)*1e6/mef.Header.sampling_frequency/1000;

% etc
% ---
EEG.etc = sprintf('Acauisition system is %s and compression algorithm is %s.',...
    mef.Header.acquisition_system, mef.Header.compression_algorithm);

% saved
% -----
EEG.saved = 'no'; % nost saved yet

% data and chanlocs
% -----------------
data = zeros(EEG.nbchan, length(EEG.times));
chanlocs = struct([]);
for k = 1:EEG.nbchan
    ch_k = fname{k};
    fprintf('Importing MEF data %s...\n', ch_k)
    
    mef_k = MultiscaleElectrophysiologyFile(fullfile(EEG.filepath, ch_k));
    if isempty(start_end)
        data(k, :) = mef_k.importSignal;
    else
        data(k, :) = mef_k.importSignal(start_end, unit);
    end % if
    chanlocs(k).labels = mef_k.Header.channel_name;
end % for
EEG.data = data;
EEG.chanlocs = chanlocs;

end % function

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(varargin)

% defaults
defaultSE = [];
defaultUnit = 'index';
expectedUnit = {'index', 'uutc', 'second', 'minute', 'hour', 'day'};

% parse rules
p = inputParser;
p.addRequired('EEG', @(x) isempty(x) || isstruct(x));
p.addRequired('filepath', @ischar);
p.addRequired('filename', @(x) ischar(x) || iscellstr(x) || isstring(x));
p.addOptional('start_end', defaultSE,...
    @(x) isnumeric(x) & numel(x) == 2 & x(1) <= x(2));
p.addOptional('unit', defaultUnit,...
    @(x) any(validatestring(x, expectedUnit)));

% parse and return the results
p.parse(varargin{:});
q.EEG = p.Results.EEG;
q.filepath = p.Results.filepath;
q.filename = p.Results.filename;
q.start_end = p.Results.start_end;
q.unit = p.Results.unit;

end % function

% [EOF]
