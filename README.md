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
| Import EEG Data | 1.1. [import_data_eeglab](./import_data_eeglab.m) |
| Rereferencing Channels | 2.1. [reref_channels_eeglab](./reref_channels_eeglab.m) |
| Filter Dataset | 3.1. [filter_data_eeglab](./filter_data_eeglab.m)<br>3.2. [apply_multifilt_eeglab](./apply_multifilt_eeglab.m) |
| Retrieving a Dataset | 4.1. [retr_data_eeglab](./retr_data_eeglab.m) |
| Artefact Rejection | 5.1. [reject_artefacts_eeglab](./reject_artefacts_eeglab.m) |

<!-- -->
| Functionality | Wrapper Functions | Comments |
| --- | --- | --- |
| Import EEG Data | 1.1. [import_data_eeglab](./import_data_eeglab.m) | currently only allows for matlab arrays and EDF files to be imported. |
| Rereferencing Channels | 2.1. [reref_channels_eeglab](./reref_channels_eeglab.m) | Rereferencing to a common mode or differential mode is not coded and needs to be done manually. |
| Filter Dataset | 3.1. [filter_data_eeglab](./filter_data_eeglab.m)<br>3.2. [apply_multifilt_eeglab](./apply_multifilt_eeglab.m) | Single filter function.<br>Multiple filters stored as multiple datasets. |
| Retrieving a Dataset | 4.1. [retr_data_eeglab](./retr_data_eeglab.m) |  |
| Artefact Rejection | 5.1. [reject_artefacts_eeglab](./reject_artefacts_eeglab.m) | Runs ICA and MARA both. For Individually training the parameters using the IC's, try manual rejection. |
<!-- -->

# References
1. EEGLAB toolbox for neuro-electrophysiological signal-processing, Swartz Center for Computational Neuroscience (University of California San Diego), found at: https://sccn.ucsd.edu/eeglab/index.php.
2. Multiple Artefact Rejection Algorithm (MARA), EEGLAB Plug-In, found at: https://irenne.github.io/artifacts/

# Licenses
This repository licensed under the terms of the [MIT license](https://github.com/sparky-electrode/newt/blob/master/LICENSE).