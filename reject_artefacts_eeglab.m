function [ALLEEG, EEG, CURRENTSET, MARA_info]...
  = reject_artefacts_eeglab(ALLEEG, EEG, CURRENTSET,...
    dataset_name, prob_threshold)
%   This is a wrapper around the functions pop_runICA(...) and MARA(...).
%
%   Usage:
%       [ALLEEG, EEG, CURRENTSET, ALLCOM, MARA_info] = reject_artefacts_eeglab(ALLEEG, EEG, CURRENTSET)
%       [ALLEEG, EEG, CURRENTSET, ALLCOM, MARA_info] = reject_artefacts_eeglab(ALLEEG, EEG, CURRENTSET, dataset_name)
%       [ALLEEG, EEG, CURRENTSET, ALLCOM, MARA_info] = reject_artefacts_eeglab(ALLEEG, EEG, CURRENTSET, dataset_name, prob_threshold)
%
%   Input Parameters:
%       ALLEEG, EEG, and CURRENTSET are Required EEGLAB variables.
%
%   Other Parameters: (optional, but recommended)
%       
%       dataset_name    : character array for naming the new, ICA-pruned
%                         dataset. The default values will be 'EEG_Data'
%                         followed by the date and time the function was
%                         executed by the local of the system.
%       prob_threshold  : Adjusted value for thresholding the probability
%                         values for Artefact rejection. Must remain
%                         between 0 and 1. Default value = '0.5';
%
%   Outputs:
%       ALLEEG, EEG, and CURRENTSET are necessary EEGLAB variables.
%       
%       MARA_info       : A MARA-structure of output statistics for
%                         artefact classification.
%
switch(nargin)
    case{3}
        prob_threshold = 0.5;
        dataset_name = sprintf('EEG_Data_%s', (datestr('now')));
    case{4}
        prob_threshold = 0.5;
    case{5}
        if isempty(dataset_name)
            dataset_name = sprintf('EEG_Data_%s', (datestr('now')));
        end
    otherwise, error('Missing Entries and/or Arguments');
end

% Run ICA
EEG = pop_runica(EEG, 'extended', 1, 'icatype', 'runica');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );

% Process MARA
[~, MARA_info] = MARA(EEG);
[min_probability, temp] = min(MARA_info.posterior_artefactprob);
MARA_info.posterior_artefactprob(temp(1)) = MARA_info.posterior_artefactprob(temp) - 0.0001;

artefacts = MARA_info.posterior_artefactprob >= prob_threshold...
    & MARA_info.posterior_artefactprob >= min_probability;

EEG = pop_subcomp( EEG, find(artefacts, length(artefacts)-1) ); % Reject IC's

% OutPut
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', sprintf('%s_pruned', dataset_name), 'gui', 'off');
end