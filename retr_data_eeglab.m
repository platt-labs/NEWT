function [ALLEEG, EEG, CURRENTSET] = retr_data_eeglab(...
    ALLEEG, EEG, CURRENTSET, retrieve_set)
%   This is a wrapper around the eeglab function pop_newset(...) to
% retrieve a specific dataset.
%
%   Usage:
%       [ALLEEG, EEG, CURRENTSET] = retr_data_eeglab(ALLEEG, EEG, CURRENTSET, retrieve_set)
%
%   Input Parameters:
%       ALLEEG, EEG, and CURRENTSET are Required EEGLAB variables.
%       retrieve_set    : Integer value for the set to be retrieved for
%                         filtering (default '1').
%
%   Outputs:
%       ALLEEG, EEG, and CURRENTSET are necessary EEGLAB variables.
% 
if nargin ~= 4, error('Function missing arguments');
elseif rem(retrieve_set, 1) > 0 || retrieve_set == 0
    error('''retrieve_set'' should have a positive integer value');
end

% Retrieve a particular Dataset
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,...
    'retrieve', retrieve_set);
end