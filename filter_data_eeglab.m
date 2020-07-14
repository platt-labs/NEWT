function [ALLEEG, EEG, CURRENTSET, b] = filter_data_eeglab(...
    ALLEEG, EEG, CURRENTSET, lower_cutoff, upper_cutoff, dataset_name)
%   This function requires EEGLAB to be running with data already imported
% and the structure 'EEG' to contain a non-empty variable 'data'.
% 
% 	Usage:
%       [ALLEEG, EEG, CURRENTSET] = filter_data_eeglab(ALLEEG, EEG, CURRENTSET, lower_cutoff, upper_cutoff)
%       [ALLEEG, EEG, CURRENTSET, b] = filter_data_eeglab(ALLEEG, EEG, CURRENTSET, lower_cutoff, upper_cutoff)
%       
%       [...] = filter_data_eeglab(ALLEEG, EEG, CURRENTSET, lower_cutoff, upper_cutoff, dataset_name)
% 
%   Input Parameters:
%       ALLEEG, EEG, and CURRENTSET Required EEGLAB variables.
%       
%       lower_cutoff    : Double value for the lower cut-off frequency (in
%                         Hz) for the filter. For High-pass filtering,
%                         make this value 0.
%       upper_cutoff    : Double value for the upper cut-off frequency (in
%                         Hz) for the filter. For Low-pass filtering,
%                         make this value 0.
% 
%   Optional Parameters:
%       dataset_name    : Character Array value for naming the filtered
%                         dataset. Default value is 'filtered_data'.
% 
%   Outputs:
%       ALLEEG, EEG, and CURRENTSET are necessary EEGLAB variables.
%       b               : (optional) Matrix of filter coefficients.
% 
if nargin < 6 || isempty(dataset_name)
    dataset_name = 'filtered_data';
end

% Filter Data
[EEG, ~, b] = pop_eegfiltnew(EEG, lower_cutoff, upper_cutoff);

% New EEG Dataset
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,...
    'setname', dataset_name, 'gui', 'off');

% Generate Output
EEG = eeg_checkset( EEG );
end