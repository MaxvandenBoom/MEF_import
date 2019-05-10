function varargout = gui_mefimport(varargin)
% GUI_MEFIMPORT Graphic UI for importing MEF datafile
% 
% Syntax:
%   [filepath, filename, start_end, unit] = gui_mefimport()
% 
% Input(s):
% 
% Output(s):
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
% Note:
%   gui_mefimport does not import MEF by itself, but instead gets the
%   necessary information about the data and then relys on mefimport.m to
%   import MEF data into EEGLab.
% 
% See also pop_mefimport, mefimport.

% Copyright 2019 Richard J. Cui. Created: Sun 04/28/2019  9:51:01.691 PM
% $Revision: 0.2 $  $Date: Thu 05/09/2019 10:31:59.845 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_mefimport_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_mefimport_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function gui_mefimport_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% initialization
% --------------
set(handles.checkbox_segment, 'Value', 0)
set(handles.pushbutton_deselall, 'Enable', 'off')
set(handles.uitable_channel,'Data', [], 'Enable', 'off')
set(handles.popupmenu_unit, 'String', {'Index', 'uUTC', 'mSec', 'Second',...
    'Hour', 'Day'})
set(handles.edit_start, 'Enable', 'Off')
set(handles.edit_end, 'Enable', 'Off')
set(handles.uitable_channel, 'Enable' , 'Off')

uiwait();

function varargout = gui_mefimport_OutputFcn(hObject, eventdata, handles)
if isempty(handles)
    varargout{1}= [];
    varargout{2}= '';
    guinpx= findobj('Tag', 'MEFIMPORT');
    delete(guinpx)
    return
else
    varargout{1} = handles.EEG;
    varargout{2} = handles.command;
end

function [start_end, unit] = gerStartend(list_mef, handles)
% get start and end point

filepath = list_mef.folder;
filename = list_mef.name;

unit_list = get(handles.popupmenu_unit, 'String');
choice = get(handles.popupmenu_unit, 'Value');
unit = unit_list{choice};

mef = MultiscaleElectrophysiologyFile(filepath, filename);
uutc_start = mef.Header.recording_start_time;
uutc_end = mef.Header.recording_end_time;
start_end_index = mef.SampleTime2Index([uutc_start, uutc_end]);
switch lower(unit)
    case 'index'
        start_end = start_end_index;
    otherwise
        start_end = mef.SampleTime2Index([uutc_start, uutc_end], unit);
end % switch

function pushbutton_folder_Callback(hObject, eventdata, handles)
% get data folder and obtain corresponding data information

% get data folder
% ---------------
filepath= uigetdir;
if filepath == 0
    return
else
    set(handles.edit_path, 'String', filepath);
end

% get data info
% -------------
list_mef = dir(fullfile(filepath, '*.mef'));
if isempty(list_mef)
    return
end % if

% get start and end points of imported signal
start_end = gerStartend(list_mef(1), handles);
set(handles.edit_start, 'String', num2str(start_end(1)))
set(handles.edit_end, 'String', num2str(start_end(2)))

% get channel information
num_mef = numel(list_mef); % number of mef/channels in the folder
colname = get(handles.uitable_channel, 'ColumnName');
num_colname = numel(colname);
Table = cell(num_mef, num_colname);
rownames = cell(num_mef, 1);
for k = 1:num_mef
    fp_k = list_mef(k).folder;
    fn_k = list_mef(k).name;
    mef = MultiscaleElectrophysiologyFile(fp_k, fn_k);
    Table{k, 1} = mef.Header.channel_name;
    Table{k, 2} = mef.Header.sampling_frequency;
    Table{k, 3} = mef.Header.number_of_samples;
    Table{k, 4} = mef.Header.number_of_index_entries;
    Table{k, 5} = mef.Header.number_of_discontinuity_entries;
    Table{k, 6} = true;
    
    rownames{k} = num2str(k);
end % for
set(handles.uitable_channel, 'Data', Table, 'RowName', rownames, 'Enable' , 'Off')
set(handles.pushbutton_deselall, 'Enable', 'On')


function edit_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_path_Callback(hObject, eventdata, handles)


function checkbox_segment_Callback(hObject, eventdata, handles)
CB1= get(handles.checkbox_segment, 'Value');
Table= get(handles.uitable_channel, 'Data');
if CB1 == 1
    set(handles.uitable_channel, 'Enable', 'on')
    set(handles.uitable_channel, 'Data', Table)
    set(handles.uitable_channel,'ColumnEditable',[false false false true]);
    set(handles.uitable_channel,'CellSelectionCallback',@uitable_channel_CellSelectionCallback)
    set(handles.pushbutton_deselall, 'Enable', 'on')
else
    set(handles.uitable_channel, 'Enable', 'off')
    set(handles.pushbutton_deselall, 'Enable', 'off')
end

function SelectedCells= uitable_channel_CellSelectionCallback(hObject, eventdata, handles)
SelectedCells = eventdata.Indices;


function pushbutton_ok_Callback(hObject, eventdata, handles)
ED1= get(handles.edit_path, 'String');
Table= get(handles.uitable_channel, 'Data');
eventIdx= cell2mat(Table(:,4));
selEvent= Table(eventIdx,1);

[filepath, filename]= fileparts(ED1);

[progr_ver, dim, fs, n_chs, CH_LABS, DATA, EVENT_STRUCT, ICA]= read_npx(filename, filepath,selEvent);

EEG= eeg_emptyset;
EEG.setname= [filename '.set'];
EEG.filename= [filename '.npx'];
EEG.subject= '';
EEG.group= '';
EEG.condition= '';
EEG.session= [];
EEG.comments= ['Original File: ' filepath filesep filename '.npx'];
EEG.nbchan= n_chs;

if ndims(DATA) == 3
    EEG.trials= size(DATA,3);
else
    EEG.trials= 1;
end

EEG.pnts= size(DATA,2);
EEG.srate=fs;
EEG.xmin= 0;
EEG.xmax= EEG.pnts/EEG.srate;
EEG.times= [];
EEG.data= DATA;

if ~isempty(ICA)
    EEG.icawinv= ICA.InvW;
    EEG.icasphere= ICA.Sp;
    EEG.icaweights= ICA.W;
    EEG.icachansind= 1:1:n_ICAcomps;
end

EEG.chanlocs =[];

for i= 1:size(CH_LABS, 1)
    EEG.chanlocs(1,i).labels= CH_LABS(i,:);
end

offset= 0;

for i=1: length(EVENT_STRUCT)
       
    Event_name= EVENT_STRUCT(i,1).name;
    Event_class= EVENT_STRUCT(i,1).Class;
        
    isF= isfield(EVENT_STRUCT(1,1), 'VSB');
    if isF ==1
        Event_occ= length(EVENT_STRUCT(i,1).VSB);
        
        for j= 1:Event_occ
            
            k= offset+ j;
            EEG.event(k).type= Event_name;
            EEG.event(k).position= [];
            EEG.event(k).latency= EVENT_STRUCT(i,1).VSB(j);
            
            if  Event_class== 1
                EEG.event(k).duration= 0;
            elseif Event_class== 2
                EEG.event(k).duration= (EVENT_STRUCT(i,1).VSE(j)- EVENT_STRUCT(i,1).VSB(j)) ;
            end
        end
         offset= length(EEG.event);  
    else
        Event_occ=0;
    end
     
end

[EEG] = eeg_checkset(EEG);
disp('Done')

handles.EEG= EEG;
handles.command= '';
guidata(hObject,handles);
uiresume();


function pushbutton_cancer_Callback(hObject, eventdata, handles)

uiresume();
guimef= findobj('Tag', 'MEFIMPORT');
delete(guimef)


function pushbutton_deselall_Callback(hObject, eventdata, handles)
Table= get(handles.uitable_channel, 'Data');
[r,c]= size(Table);
for i=1:r
    Table{i,4}= true;
end
set(handles.uitable_channel, 'Data', Table)


function MEFIMPORT_CloseRequestFcn(hObject, eventdata, handles)
EEG= [];
command= '';
handles.EEG= EEG;
handles.command= command;
guidata(hObject,handles);
uiresume();
guimef= findobj('Tag', 'MEFIMPORT');
delete(guimef)

function edit_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_start as text
%        str2double(get(hObject,'String')) returns contents of edit_start as a double


% --- Executes during object creation, after setting all properties.
function edit_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_end as text
%        str2double(get(hObject,'String')) returns contents of edit_end as a double


% --- Executes during object creation, after setting all properties.
function edit_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_unit.
function popupmenu_unit_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_unit


% --- Executes during object creation, after setting all properties.
function popupmenu_unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% [EOF]
