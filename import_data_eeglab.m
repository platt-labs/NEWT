function [ALLEEG, EEG, CURRENTSET, ALLCOM] = import_data_eeglab(...
    data, sample_rate, channel_location, dataset_name, varargin)
%   This is a Wrapper around the import utility of EEGLAB. It takes input
% as the required parameters for the data and channels using the data, to
% generate an EEGLAB-based wrapper for simple import of EEG data.
% 
%   Usage :
%       [ALLEEG EEG CURRENTSET ALLCOM] = import_data_eeglab(data, sample_rate)
%       [ALLEEG EEG CURRENTSET ALLCOM] = import_data_eeglab(data, sample_rate, channel_location)
%       [ALLEEG EEG CURRENTSET ALLCOM] = import_data_eeglab(data, sample_rate, channel_location, dataset_name)
%       
%       [ALLEEG EEG CURRENTSET ALLCOM] = import_data_eeglab(data, channel_select)
%       [ALLEEG EEG CURRENTSET ALLCOM] = import_data_eeglab(data, channel_select, channel_location)
%       [ALLEEG EEG CURRENTSET ALLCOM] = import_data_eeglab(data, channel_select, channel_location, dataset_name)
%       [ALLEEG EEG CURRENTSET ALLCOM] = import_data_eeglab(data, channel_select, channel_location, dataset_name, Name, Value)
% 
%   Input Parameters:
%       data                :   String value specifying the variable or
%                               location of the EDF/EDF+ file. If the data
%                               is a variable, it must be a N x M matrix of
%                               double-float values, such that M is the
%                               number of evenly-spaced epochs per channel
%                               and N is the total number of channels.
% 
%   Conditional Input Parameters:
%       sample_rate         :   Double value specified for the Sampling
%                               Rate of the N x M matrix data in Hz.
%       OR
%       
%       channel_select      :   Double array of the channel indices to be
%                               selected in the case of EDF/EDF+ file.
%                               Input a default value of '0' to select all
%                               the channels from the EDF file.
% 
%   Optional Parameters:
%       channel_location    :   string-type input or struct-type input.
%                               String-type supports the location with
%                               respect to the current directory or full
%                               path to the file. struct-type is the entire
%                               'chanlocs' structure. In absence of the
%                               parameter, the 'chanloc' parameter of the
%                               structs in EEG/ALLEEG will show empty ([]).
%       dataset_name        :   Name of the imported Dataset in EEGLAB.
%                               Default name will be 'imported_dataset'
%                               followed by the date and time of the run.
% 
%   Name-Value Pairs:
%       'refs'              :   looks for a double array of integer values
%                               to be used as references.
% 
%   Outputs:
%       [ALLEEG EEG CURRENTSET ALLCOM] are the outputs for any EEGLAB-based
%       operation.
% 
temp = join(split(datestr(datetime('now')), ' '), '_');
temp = sprintf('imported_dataset_%s', temp{1});
args = getArgs(struct());

% Check for missing values
switch (nargin)
    case {2}
        channel_location = 0;
        dataset_name = temp;
    case {3}
        dataset_name = temp;
    case {4}
        if isempty(channel_location), channel_location = 0; end
    otherwise
        if rem(nargin, 2)
            error('Incprrect inputs to the function import_data_eeglab(...)');
        else
            if isempty(channel_location), channel_location = 0; end
            if isempty(dataset_name), dataset_name = temp; end
            for i = 1:length(varargin)/2
                args = getArgs(args, varargin{i*2 - 1}, varargin{i*2});
            end, clear i;
        end
end, clear temp;
channel_select = sample_rate;

% Initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Import of Data
if length(split(data, '.edf')) == 1
    EEG = pop_importdata('dataformat', 'array', 'nbchan', 0,...
        'data', data, 'srate', sample_rate, 'pnts', 0, 'xmin', 0);
else
    switch((1 * ~max(isempty(channel_select) | channel_select == 0)...
            + 2 * (~isempty(args.refs))))
        case{0}
            EEG = pop_biosig(data);
        case{1}
            EEG = pop_biosig(data, 'channels', channel_select);
        case{2}
            EEG = pop_biosig(data,...
                'ref', args.refs, 'refoptions', {'keepref' 'off'});
        case{3}
            EEG = pop_biosig(data, 'channels', channel_select,...
                'ref', args.refs, 'refoptions', {'keepref' 'off'});
    end
%     if isempty(channel_select) | channel_select == 0
%         EEG = pop_biosig(data);
%     else
%         EEG = pop_biosig(data, 'channels', channel_select);
%     end
end
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,...
    'setname', dataset_name, 'gui', 'off');

% Check for Channel Location Specification
if ismatrix(channel_location) && ischar(channel_location)
    EEG = pop_chanedit(EEG, 'lookup', channel_location,...
        'load', {channel_location, 'filetype', 'autodetect'});
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
end

% Generate Output
EEG = eeg_checkset( EEG );
end

% Get Variable Arguments
function [output_struct] = getArgs(output_struct, in_name, in_val)
% Check for Fields
if ~isfield(output_struct, 'refs'), output_struct.refs = []; end

% Edit Fields
if nargin > 1
    switch(in_name)
        case{'refs'}, output_struct.refs = in_val;
        otherwise, error('Unrecognized variable ''%s''', in_name);
    end
end
end