# MoDyCoEEGpipeline
The scripts here form a pipeline to preprocess, analyze, and plot EEG/ERP data collected from a 64-channel BioSemi system with 4 reference electrodes (outer canthi of each eye, above and below left eye).

## Before getting started
Before you start, make sure you have Matlab on your computer, as well as both the [EEGLAB](ftp://sccn.ucsd.edu/pub/daily/eeglab13_6_5b.zip) and [FieldTrip](ftp://ftp.fieldtriptoolbox.org/pub/fieldtrip/fieldtrip-20190419.zip) toolboxes. Their installation instructions are [here](https://sccn.ucsd.edu/eeglab/downloadtoolbox.php) and [here](http://www.fieldtriptoolbox.org/faq/should_i_add_fieldtrip_with_all_subdirectories_to_my_matlab_path/
) respectively. If you are working on one of the lab computers, these are already installed.

The pipeline runs in Matlab. If you are not yet familiar with the Matlab environment, I suggest you complete [this tutorial](https://fr.mathworks.com/help/matlab/getting-started-with-matlab.html) before you start.

You may also want to go through the tutorials provided by the toolboxes to get a feel for the process if this is not something you've done before:
- [EEGLAB tutorial](https://sccn.ucsd.edu/wiki/EEGLAB_Wiki)
- [Fieldtrip walkthrough](http://www.fieldtriptoolbox.org/walkthrough/)


## Getting started
Once you have everything installed on whichever computer you'll be doing your analysis:
- Create a folder (directory) to keep everything in one place
- Click on "Clone or download" and select "Download ZIP"
- Unzip the contents in your new experimental directory
