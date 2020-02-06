classdef MEFSession < handle
    % Class MEFSESSION processes MEF session
    % 
    % Syntax:
    %   this = MEFSession;
    %
    % Input(s):
    % 
    % Output(s):
    %
    % See also .
    
    % Copyright 2020 Richard J. Cui. Created: TThu 02/06/2020 10:07:26.965 AM
    % $Revision: 0,1 $  $Date: Thu 02/06/2020 10:07:26.965 AM $
    %
    % 1026 Rocky Creek Dr NE
    % Rochester, MN 55906, USA
    %
    % Email: richard.cui@utoronto.ca
    
    % =====================================================================
    % properties
    % =====================================================================
    % properties of importing session
    % -------------------------------
    properties
        SelectedChannel     % channels selected
        StartEnd            % start and end points to import the session
        SEUnit              % unit of StartEnd
    end % properties

    % properties of session information
    % ---------------------------------
    properties        
        SessionPath         % session directory
        Password            % password structure of the session
    end % properties
    
    % =====================================================================
    % methods
    % =====================================================================
    % the constructor
    % ----------------    
    methods

    end % methods
    
    % other metheds
    % -------------
    methods
        
    end % methods
end

% [EOF]