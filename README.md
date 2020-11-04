# Neo-EEGLAB Wrapper Toolbox (_NEWT_)
This is a library of wrappers over the [EEGLAB](https://sccn.ucsd.edu/eeglab/download.php)'s functions. This library includes wrappers over the basic functionalities of importing, cleaning (filtering), channel-based ICA, and artefact-rejection (using Multiple Artefact Rejection Algorithm, a.k.a. [MARA](https://irenne.github.io/artifacts/)).

_Note: This repository is a work-in-progress and the functions are updated every once in a while._

## Initializing the Toolbox
Make sure that EEGLAB is already downloaded on your system, and the [path to the toolbox is specified](https://www.mathworks.com/help/matlab/matlab_env/add-remove-or-reorder-folders-on-the-search-path.html).

Clone the toolbox using git commandline or download and unzip using the GUI. Then, initialize the toolbox by specifying the path as mentioned above, or locally specify the path by adding:

```Matlab
addpath('\Your\...\path\...\to\...\neo_eeglab_wrapper_toolbox');  % initialize NEWT
```

## Using the functions in the Toolbox:
Detailed usage of each function can be found using the `help` command in MATLAB command-line.

| Functionality | Wrapper Functions |
| --- | --- |
| Import EEG Data | [import_data_eeglab](./import_data_eeglab.m) |
| Rereferencing Channels | [reref_channels_eeglab](./reref_channels_eeglab.m) |
| Filter Dataset | 1. [filter_data_eeglab](./filter_data_eeglab.m)<newline>2. [apply_multifilt_eeglab](./apply_multifilt_eeglab.m) |
| Retrieving a Dataset | [retr_data_eeglab](./retr_data_eeglab.m) |
| Artefact Rejection | [reject_artefacts_eeglab](./reject_artefacts_eeglab.m) |

<!-- However, an example script is for processing a set of multiple-channel EEG data is provided here:

```Matlab
% Import Data using Array [ check: help import_data_eeglab ]
[ALLEEG, EEG, CURRENTSET, ALLCOM] = import_data_eeglab('eeg_raw_data', fs, 'path\to\eeg_channel_locations.ced', 'raw');

% Filter Data [ check: help filter_data_eeglab ]
[ALLEEG, EEG, CURRENTSET] = filter_data_eeglab(ALLEEG, EEG, CURRENTSET, 1, 50, 'raw_filtered');

% Multiple Filters [ check: help apply_multifilt_eeglab ]
[ALLEEG, EEG, CURRENTSET, b] = apply_multifilt_eeglab(ALLEEG, EEG, CURRENTSET, [1,4,7.5,12,30], {'delta','theta','alpha','beta'}, 1);

% Retrieve Data [ check: help retr_data_eeglab ]
[ALLEEG, EEG, CURRENTSET] = retr_data_eeglab(ALLEEG, EEG, CURRENTSET, 2);

eeg_data = EEG.data;

% Remove Artefacts [ check: help reject_artefacts_eeglab ]
[ALLEEG, EEG, CURRENTSET, ALLCOM, MARA_info] = reject_artefacts_eeglab(ALLEEG, EEG, CURRENTSET, 'eeg_data', fs, 'eeg_clean_data', 'path\to\eeg_channel_locations.ced');

% Post-artefact removal Filtering
[ALLEEG, EEG, CURRENTSET] = filter_data_eeglab(ALLEEG, EEG, CURRENTSET, 1, 50, 'eeg_clean_data_filtered');

% Reflect Code on EEGLAB via GUI (actual EEGLAB function)
eeglab redraw;
``` -->

# References
1. EEGLAB toolbox for neuro-electrophysiological signal-processing, Swartz Center for Computational Neuroscience (University of California San Diego), found at: https://sccn.ucsd.edu/eeglab/index.php.
2. Multiple Artefact Rejection Algorithm (MARA), EEGLAB Plug-In, found at: https://irenne.github.io/artifacts/

# Licenses
This repository licensed under the terms of the [MIT license](https://github.com/sparky-electrode/newt/blob/master/LICENSE).