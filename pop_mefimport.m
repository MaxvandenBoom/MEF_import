function [EEG, cmd] = pop_mefimport(EEG, filepath, filename, varargin)
% POP_MEFIMPORT Import MEF data into EEGLab with GUI
%
% Usage:
%   >>  OUTEEG = pop_sample( INEEG, type, param3 );
%
% Inputs:
%   INEEG   - input EEG dataset
%   type    - type of processing. 1 process the raw
%             data and 0 the ICA components.
%   param3  - additional parameter.
%    
% Outputs:
%   OUTEEG  - output dataset
%
% See also:
%   SAMPLE, EEGLAB 

% Copyright 2019 Richard J. Cui. Created: Tue 05/07/2019 10:33:48.169 PM
% $Revision: 0.1 $  $Date: Tue 05/07/2019 10:33:48.169 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% the command output is a hidden output that does not have to
% be described in the header

EEG = struct([]); % this initialization ensure that the function will return something
                  % if the user press the cancel button    
cmd = '';

% display help if not enough arguments
% ------------------------------------
if nargin < 2
	help pop_sample;
	return;
end;	

% pop up window
% -------------
if nargin < 3
	promptstr    = { 'Enter the parameter:' };
	inistr       = { '0' };
	result       = inputdlg( promptstr, 'Title of window', 1,  inistr);
	if length( result ) == 0 return; end;

	param3   	 = eval( [ '[' result{1} ']' ] ); % the brackets allow to process matlab arrays
end;

% call function sample either on raw data or ICA data
% ---------------------------------------------------
if typeproc == 1
	sample( EEG.data );
else
	if ~isempty( EEG.icadata )
		sample( EEG.icadata );
	else
		error('You must run ICA first');
	end;	
end;	 

% return the string command
% -------------------------
cmd = sprintf('pop_sample( %s, %d, [%s] );', inputname(1), typeproc, int2str(param3));

return;
