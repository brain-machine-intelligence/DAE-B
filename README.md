# DAE-B: Denoising AutoEncoder Basal Ganglia Model

This repository contains MATLAB code accompanying the manuscript:  
**"Circuit mechanisms of GPe pauses account for adaptive exploration."**


## 1. System Requirements

- The code was written and tested in **MATLAB R2024a**, and is expected to run without modification in **MATLAB R2019a or later**.
- **No additional toolboxes or Add-Ons are required.** All functionality is implemented using core MATLAB functions.
- Runs on any standard desktop or laptop capable of running MATLAB. No non-standard hardware (e.g., GPUs) is required.


## 2. Installation Guide

1. Clone or download this repository.
2. Add the folder and all subfolders to your MATLAB path:
   ```matlab
   addpath(genpath('your-cloned-directory'))
3. Installation takes less than 1 minute and is typical for a MATLAB project on a standard desktop machine.


## 3. Demo

To run the code and reproduce figures:
Simply run the script corresponding to the figure you want to generate. For example:
```matlab
Fig2e_SNR  % Reproduces Figure 2e in the manuscript
```

Expected output:
Each script will generate the figure panels (in .fig, .eps, or .png depending on configuration).

Expected runtime:
On a standard desktop computer, runtime per figure script ranges from 1 to 10 minutes. 


## 4. Instructions for Use

Each figure in the manuscript corresponds to a script in /figures/. To reproduce any result:
1. Add the full directory to your MATLAB path.
2. Run the relevant script (e.g., Fig2e_SNR.m).
3. The script will internally call simulation and analysis functions from /src/ and /analysis/.

Reproduction instructions:
- No demo data is required; all data is generated during simulation.
- Due to the stochasticity in softmax-based action selection, some figure outputs may show slight trial-by-trial variability across runs.


## 5. Utilities and Licensing

This repository includes some third-party utility functions obtained from the MathWorks File Exchange:
- `vline.m` and `hline.m` by Brandon Kuczenski (BSD License)
  https://www.mathworks.com/matlabcentral/fileexchange/1039-hline-and-vline

- `shadedErrorBar.m` by Rob Campbell (BSD License)  
  https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar

All other code was written by the authors and is released under the MIT License.


