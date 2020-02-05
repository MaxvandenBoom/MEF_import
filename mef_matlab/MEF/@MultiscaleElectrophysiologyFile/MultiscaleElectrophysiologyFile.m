classdef MultiscaleElectrophysiologyFile < handle
    % Class MultiscaleElectrophysiologyFile process MEF channel data
    % 
    % Syntax:
    %   this = MultiscaleElectrophysiologyFile;
    %
    % Input(s):
    %
    % Output(s):
    %
    % Note:
    % 
    % See also .
    
    % Copyright 2020 Richard J. Cui. Created: Tue 02/04/2020  2:21:31.965 PM
    % $Revision: 0.2 $  $Date: Wed 02/05/2020  9:58:04.511 AM $
    %
    % 1026 Rocky Creek Dr NE
    % Rochester, MN 55906, USA
    %
    % Email: richard.cui@utoronto.ca

    % =====================================================================
    % properties
    % =====================================================================
    % MEF information
    % ---------------
    properties (SetAccess = protected)
        MEFVersion = []     % MEF version to serve; can be set only in 
                            % constructor
        MPS = 1e6           % microseconds per seconds
        ChanSamplingFreq    % sampling frequency of channel (Hz)
        SampleTimeInterval  % sample time interval = [lower, upper] (uUTC),
                            % indicating the lower and upper bound of the
                            % time interval between two successive samples
    end %  properties: protected
    
    % MEF channel info
    % ----------------
    properties (SetAccess = protected, Hidden = true)
        FilePath            % [str] filepath of MEF channel file
        FileName            % [str] filename of MEF channel file including ext
        Header              % [struct] header information of MEF file
        BlockIndexData      % [table] data of block indices (see 
                            % readBlockIndexData.m for the detail)
        Continuity          % [table] data segments of conituous sampling (see 
                            % analyzeContinuity.m for the detail)
    end % properties: protected, hidden

    % =====================================================================
    % methods
    % =====================================================================
    % the constructor
    % ----------------    
    methods
        
    end
    
    % other metheds
    % -------------
    methods
        sti = getSampleTimeInterval(this, varargin) % boudn of sampling interval
    end % methods
end

% [EOF]