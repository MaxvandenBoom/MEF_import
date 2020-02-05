classdef MultiscaleElectrophysiologyFile < handle
    % Class MultiscaleElectrophysiologyFile process MEF channel data
    % 
    % Syntax:
    %
    % Input(s):
    %
    % Output(s):
    %
    % Note:
    % 
    % See also .
    
    % Copyright 2020 Richard J. Cui. Created: Tue 02/04/2020  2:21:31.965 PM
    % $Revision: 0.1 $  $Date: Tue 02/04/2020  2:21:31.965 PM $
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
        MEFVersion = [] % MEF version to serve; can be set only in constructor
    end %  properties: protected
    
    % MEF channel info
    % ----------------
    properties (SetAccess = protected, Hidden = true)
        FilePath        % [str] filepath of MEF channel file
        FileName        % [str] filename of MEF channel file including ext
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
        
    end % methods
end

% [EOF]