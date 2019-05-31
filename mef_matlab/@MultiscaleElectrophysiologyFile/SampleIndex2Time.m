function [sample_time, sample_yn] = SampleIndex2Time(this, varargin)
% SampleIndex2Time Convert sample index to sample time
% 
% Syntax
%   [sample_time, sample_yn] = SampleIndex2Time(this, sample_index)
%   [sample_time, sample_yn] = SampleIndex2Time(__, st_unit)
% 
% Input(s):
%   this            - [obj] MultiscaleElectrophysiologyFile object
%   sample_index    - [num array] array of sample index (must be integers)
%   st_unit         - [str] (optional) sample time unit: 'uUTC' (default)
%                     or 'u', 'mSec', 'Second' or 's', 'Minute' or 'm', 'Hour' or
%                     'h' and 'Day' or 'd'.
% 
% Output(s):
%   sample_time     - [num array] sample time corresponding to sample
%                     indices (default unit: uUTC)
%   sample_yn       - [logical array] true: this sample time corresponding
%                     to physically collected data
% 
% Note:
%   An error less than one sample time may occure.
% 
% See also SampleTime2Index.

% Copyright 2019 Richard J. Cui. Created: Mon 05/06/2019  9:29:08.940 PM
% $Revision: 0.5 $  $Date: Thu 05/30/2019 11:22:03.407 PM$
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% parse inputs
% ------------
q = parseInputs(this, varargin{:});
sample_index = q.sample_index;
st_unit = q.st_unit;

% set paras
% ----------
fs = this.Header.sampling_frequency;
MPS = 1e6; % microsecond per second
sample_time = zeros(size(sample_index));
sample_yn = false(size(sample_index));
[sorted_si, orig_index] = sort(sample_index);

if isempty(this.Continuity)
    this.analyzeContinuity;
end % if
cont = this.Continuity;

% within continuous segment
% -------------------------
cont_start_end = cont{:, {'SampleIndexStart', 'SampleIndexEnd'}};
% sorted_sample_time = sample_index;
% sorted_sample_yn = sample_yn;
% num_seg = size(cont_start_end, 1); % number of segments
% for k = 1:num_seg
%     start_k = cont_start_end(k, 1);
%     end_k = cont_start_end(k, 2);
%     ind_k = sorted_si >= start_k & sorted_si <= end_k;
%     
%     if sum(ind_k) ~= 0
%         st_k = cont.SampleTimeStart(k);
%         index_diff = sorted_si(ind_k)-start_k;
%         time_diff = index_diff*MPS/fs;
%         sorted_st_k = st_k+time_diff;
%         sorted_sample_time(ind_k) = round(sorted_st_k); % uUTC integer
%         sorted_sample_yn(ind_k) = true;
%     end % if
% end % for

% choose continuity segment that in the range of sample indexes
if numel(sorted_si) == 1
    sel_cont_ind = sorted_si <= cont_start_end(:, 2) ...
        & sorted_si >= cont_start_end(:, 1);
else
    sel_cont_ind = sorted_si(1) <= cont_start_end(:, 2) ...
        & sorted_si(2) >= cont_start_end(:, 1);
end % if
sel_cont = cont(sel_cont_ind, :); % select the segment of continuity in the
                                  % range of sorted_si
sel_cont_start_end = cont_start_end(sel_cont_ind, :);                                  
[sorted_sample_time, sorted_sample_yn] = inContLoopCont(sel_cont_start_end,...
    sel_cont, sorted_si, MPS, fs);

% within discontinous segment
% ----------------------------
a = cont_start_end.';
b = cat(1, -inf, a(:), inf);
discont_start_end = reshape(b, 2, numel(b)/2).';
num_seg = size(discont_start_end, 1); % number of segments
for k = 1:num_seg
    start_k = discont_start_end(k, 1);
    end_k = discont_start_end(k, 2);
    ind_k = sorted_si > start_k & sorted_si < end_k;
    
    if sum(ind_k) ~= 0
        if start_k == -inf
            st_k = cont.SampleTimeStart(k);
            index_diff = sorted_si(ind_k)-end_k;
            time_diff = index_diff*MPS/fs;
            sorted_st_k = st_k+time_diff;
        else
            st_k = cont.SampleTimeEnd(k-1);
            index_diff = sorted_si(ind_k) - start_k;
            time_diff = (index_diff-1)*MPS/fs;
            sorted_st_k = st_k+time_diff+1;
        end % if
        sorted_sample_time(ind_k) = round(sorted_st_k); % uUTC integer
        sorted_sample_yn(ind_k) = false;
    end % if
end % for

% output
% ------
switch lower(st_unit)
    case 'msec'
        sorted_sample_time = sorted_sample_time/1e3;
    case 'second'
        sorted_sample_time = sorted_sample_time/1e6;
    case 'minute'
        sorted_sample_time = sorted_sample_time/(60*1e6);
    case 'hour'
        sorted_sample_time = sorted_sample_time/(60*60*1e6);
    case 'day'
        sorted_sample_time = sorted_sample_time/(24*60*1e6);
end % switch
sample_time(orig_index) = sorted_sample_time;
sample_yn(orig_index) = sorted_sample_yn;

end

% =========================================================================
% subroutines
% =========================================================================
function [s_ind, s_yn] = inContLoopCont(cont_se, cont, sorted_si, MPS, fs)
% within continuous segment loop through continuity segments

s_ind = zeros(size(sorted_si));
s_yn = false(size(sorted_si));

num_seg = size(cont_se, 1); % number of segments
for k = 1:num_seg
    start_k = cont_se(k, 1);
    end_k = cont_se(k, 2);
    ind_k = sorted_si >= start_k & sorted_si <= end_k;
    
    if sum(ind_k) ~= 0
        st_k = cont.SampleTimeStart(k);
        index_diff = sorted_si(ind_k)-start_k;
        time_diff = index_diff*MPS/fs;
        sorted_st_k = st_k+time_diff;
        s_ind(ind_k) = round(sorted_st_k); % uUTC integer
        s_yn(ind_k) = true;
    end % if
end % for

end % function

function q = parseInputs(varargin)

% defaults
defaultSTUnit = 'uutc';
expectedSTUnit = {'uutc', 'msec', 'second', 'minute', 'hour', 'day'};

% parse rules
p = inputParser;
p.addRequired('this', @isobject);
p.addRequired('sample_index', @isnumeric);
p.addOptional('st_unit', defaultSTUnit,...
    @(x) any(validatestring(x, expectedSTUnit)));

% parse and return the results
p.parse(varargin{:});
q.this = p.Results.this;
q.sample_index = p.Results.sample_index;
q.st_unit = p.Results.st_unit;

end % function

% [EOF]