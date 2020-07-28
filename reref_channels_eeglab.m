function [ALLEEG, EEG, CURRENTSET] = reref_channels_eeglab( ALLEEG, EEG,...
    CURRENTSET, old_ref, new_ref, dataset_name, keep_old_ref )
%   This function is an wrapper over the EEGLAB function 'pop_reref'. As
% of now, this function supports a choice between the use of a single
% channel as a new reference and the average across all electrodes.
%
%   Upcoming Function Update:
%     Multiple-channel referencing and inclusion of referencing options
% such as dipoles, selective average and weighted mean.
%
%   Usage:
%     [ALLEEG EEG CURRENTSET] = reref_channels_eeglab(ALLEEG, EEG, CURRENTSET)
%     [...] = reref_channels_eeglab(..., old_ref, new_ref)
%     [...] = reref_channels_eeglab(..., old_ref, new_ref, dataset_name)
%
%   Inputs:
%     ALLEEG, EEG, and CURRENTSET are the usual EEGLAB functions.
%
%     old_ref           : Array/Structure/Table/Integer value defining the
%                         old reference channel. If new_ref is either 0,
%                         false or empty (default is '[]'), then the
%                         channels are rereferenced to their average.
%
%     new_ref           : Character-Array/Positive Integer value defining
%                         the new reference channel. If new_ref is either
%                         0, false or empty (default is '[]'), then the
%                         channels are rereferenced to their average.
%
%   Optional Parameters:
%
%     dataset_name      : Character Array value for naming the filtered
%                         dataset. Default is 'reref_data'.
%
%     keep_old_ref      : Binary option to preserve the old reference when
%                         re-referencing to another channel. Possible
%                         values = 'on' or 'off'. Default value is 'off'.
%
%   Outputs:
%     ALLEEG, EEG, and CURRENTSET are the usual EEGLAB functions.
%
%   References: <a href="https://sccn.ucsd.edu/wiki/I.4:_Preprocessing_Tools#Re-referencing_the_data">EEGLAB - Rereferencing during Pre-processing</a>.
if isempty(EEG.chanlocs), fprintf('\n%s\n\t%s\n',...
        'Edit channel locations before using this function.',...
        'Refer to ''pop_chanedit'' (use ''help'' in command window).');
end

% Initializing Rereference Channel
chan_len = size(EEG.data, 1);
chan_len_appended = sprintf('%d', chan_len+1);
switch(nargin)
    case{3}
        old_ref = [];
        new_ref = [];
        dataset_name = 'reref_data';
        keep_old_ref = 'off';
    case{4}
        old_ref = myCheckRef(old_ref);
        new_ref = [];
        dataset_name = 'reref_data';
        keep_old_ref = 'off';
    case{5}
        old_ref = myCheckRef(old_ref);
        new_ref = myCheckRef(new_ref, struct2table(EEG.chanlocs));
        dataset_name = 'reref_data';
        keep_old_ref = 'off';
    case{6}
        old_ref = myCheckRef(old_ref);
        new_ref = myCheckRef(new_ref, struct2table(EEG.chanlocs));
        if strcmp(dataset_name, ''), dataset_name = 'reref_data'; end
        keep_old_ref = 'off';
    case{7}
        old_ref = myCheckRef(old_ref, 0);
        new_ref = myCheckRef(new_ref, struct2table(EEG.chanlocs));
        if strcmp(dataset_name, ''), dataset_name = 'reref_data'; end
        if isempty(keep_old_ref), keep_old_ref = 'off';
        else keep_old_ref = lower(keep_old_ref);
        end
    otherwise, error('Incorrect or Missing Arguments');
end
if isnumeric(old_ref)
    if old_ref == -1, error('Incorrect Argument found: ''old_ref'''); end
end
if isnumeric(new_ref)
    if new_ref == -1, error('Incorrect Argument found: ''new_ref'''); end
end

% Check EEG Set and Error-Check
EEG = eeg_checkset( EEG );
if isempty(new_ref), keep_old_ref = 'off';
    disp('Re-referencing to the Average...');
elseif isempty(old_ref)
    error('Empty ''old_ref'' is illegal if ''new_ref'' is defined.');
else
    disp('Re-referencing to the new Channel...');
end

if isfield(EEG.chaninfo, 'nodatchans') && isempty(EEG.chaninfo.nodatchans)
    % Set Path Location
    path_to_the_channel_locations = sprintf(...
        '%s/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp',...
        mySearchPath('eeglab'));
    
    % Define 'dataset_name'
    if ~exist('dataset_name', 'var'), dataset_name = 'reref_data'; end
    
    % Edit Channel Locations - Add AF7 as the Reference
    EEG = pop_chanedit(EEG, 'append', chan_len,...
        'changefield', {chan_len+1, 'labels', old_ref.labels},...
        'setref', {chan_len_appended, old_ref.labels},...
        'lookup', path_to_the_channel_locations,...
        'setref', {chan_len_appended, old_ref.labels});
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    
    % Rereferencing the Channels and add the old reference back
    EEG = pop_reref( EEG, new_ref, 'refloc', struct(...
        'labels', {old_ref.labels}, 'type', {''},...
        'theta', {old_ref.theta},...
        'radius', {old_ref.radius},...
        'X', {old_ref.X},...
        'Y', {old_ref.Y},...
        'Z', {old_ref.Z},...
        'sph_theta', {old_ref.sph_theta},...
        'sph_phi', {old_ref.sph_phi},...
        'sph_radius', {old_ref.sph_radius},...
        'urchan', {chan_len+1},...
        'ref', {old_ref.labels},...
        'datachan', {0}), 'keepref', keep_old_ref );
else
    % Rereferencing the Channels and add the old reference back
    if ~isempty(new_ref)
        fprintf('\nNew Reference Channel is #%02d\n', new_ref);
    end, EEG = pop_reref( EEG, new_ref, 'keepref', keep_old_ref );
end

% Define the new data set name
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', dataset_name);
end

%% Functional Dependencies
function out_ref = myCheckRef(in_ref, ref_table)
if nargin == 1, new_set = 0; ref_table =...
        removevars(readtable(sprintf('%s/chan_locs_81cap.txt',...
        mySearchPath('neo_eeglab_wrapper_toolbox'))), {'Number','Var11'});
else, new_set = 1;
end

if isempty(in_ref)
    out_ref = [];
elseif in_ref == false
    out_ref = [];
elseif isnumeric(in_ref)
    if in_ref == 0, out_ref = [];
    elseif new_set && in_ref < length(ref_table.labels)
        out_ref = in_ref;
    else, out_ref = -1;
    end
elseif ischar(in_ref)
    out_ref = table2struct(ref_table(strcmpi(ref_table.labels, in_ref),:));
elseif istable(in_ref)
    out_ref = table2struct(in_ref);
elseif isstruct(in_ref)
    out_ref = in_ref;
else
    out_ref = -1;
end

if new_set == 1 && isstruct(out_ref)
    out_ref = find(strcmpi(ref_table.labels, out_ref.labels), 1);
end
end

function out_val = mySearchPath(searchval)
p = split(path,':');
for el_iter = 1:length(p)
    if xor( contains(searchval, 'neo_eeglab'),...
            contains(p{el_iter}, 'neo_eeglab') ), continue; end
    el_split = strfind(p{el_iter}, searchval);
    if ~isempty(el_split), p = p{el_iter}; break; end
end

el_p = join(split(p,{'\\','\'}), '/');
el_p = split(el_p{:}, searchval);
el_el_p = split(el_p{2}, '/');
out_val = sprintf('%s%s%s', el_p{1}, searchval, el_el_p{1});
end