function [ALLEEG, EEG, CURRENTSET, b] = apply_multifilt_eeglab(...
    ALLEEG, EEG, CURRENTSET, cutoff_freqs, dataset_names, retrieve_set)
%   This is a wrapper around the function filter_data_eeglab(...).
%
%   Usage:
%       [ALLEEG, EEG, CURRENTSET] = apply_multifilt_eeglab(ALLEEG, EEG, CURRENTSET, cutoff_freqs)
%       [ALLEEG, EEG, CURRENTSET, b] = apply_multifilt_eeglab(ALLEEG, EEG, CURRENTSET, cutoff_freqs)
%       
%       [...] = apply_multifilt_eeglab(ALLEEG, EEG, CURRENTSET, cutoff_freqs, dataset_names)
%       [...] = apply_multifilt_eeglab(ALLEEG, EEG, CURRENTSET, cutoff_freqs, [], retrieve_set)
%       [...] = apply_multifilt_eeglab(ALLEEG, EEG, CURRENTSET, cutoff_freqs, dataset_names, retrieve_set)
%
%   Input Parameters:
%       ALLEEG, EEG, and CURRENTSET are Required EEGLAB variables.
%       
%       cutoff_freqs    : Double Array of the cut-off frequencies (in Hz).
%                         Define '0' as the first value for Low-Pass
%                         Filtering. Define '0' as the last element for
%                         High-pass filtering. All other pairs will be
%                         considered as band-pass filtering.
%
%   Other Parameters: (optional, but recommended)
%       dataset_names   : Array or Set of names (character-set/array). The
%                         default values will be 'filter_f1_f2_data', where
%                         f1 and f2 are the filtered frequencies.
%       retrieve_set    : Integer value for the set to be retrieved for
%                         filtering (default '1').
%
%   Outputs:
%       ALLEEG, EEG, and CURRENTSET are necessary EEGLAB variables.
%       b               : (optional) Set of filter coefficient matrices.
%
temp = reshape(unique(cutoff_freqs, 'stable'), 1, max(size(cutoff_freqs)));
if (cutoff_freqs(end) == 0)
    cutoff_freqs = [temp, 0];
end, clear temp;
switch(nargin)
    case {4}
        dataset_names = [];
        retrieve_set = 1;
    case {5}
        retrieve_set = 1;
    case {6}
        if rem(retrieve_set, 1) > 0 || retrieve_set == 0
            error('''retrieve_set'' should have a positive integer value');
        end
    otherwise
        error('Incorrect or missing input arguments');
end
if ~isempty(dataset_names)...
        && length(cutoff_freqs) - 1 ~= length(dataset_names)
    error('Mismatched dataset_names');
end

% Loop over the iterations of Datasets
b = [];
for el = 1:length(cutoff_freqs)-1
    % Retrieve dataset_name
    if isempty(dataset_names)
        dataset_name = sprintf('filter_%0.2f_%0.2f_data',...
            cutoff_freqs(el), cutoff_freqs(el+1));
    else
        dataset_name = dataset_names{el};
    end
    
    % Retrieve the Original Dataset
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,...
        'retrieve', retrieve_set);
    
    % Filter the Data and Save it as a New Set
    [ALLEEG, EEG, CURRENTSET, b_el] = filter_data_eeglab(...
        ALLEEG, EEG, CURRENTSET,...
        cutoff_freqs(el), cutoff_freqs(el+1),...
        dataset_name);
    b = [b, {b_el}];
end
end