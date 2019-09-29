# TED toolbox
 
-----------------------------------------------------------------------------------------
A Matlab package for MR-guided-HIFU Temporal Differences (TED) Compressed Sensing Recon
-----------------------------------------------------------------------------------------
TEmporal Differences (TED) Compressed Sensing is a method developed for accelerating thermal 
monitoring of prostate MRgHIFU. TED combines k-space subsampling, parallel imaging, and the 
proposed Compressed Sensing reconstruction framework. The method is described in a manuscript 
that was submitted to JMRI. 

This Matlab toolbox contains the TED code and two temperature reconstruction demos:
1. Agar phantom data, acquired with a Philips scanner.
2. Gel phantom data, acquiredw with a GE scanner.

In both cases, fully sampled data was acquired in-vitro and then retrospectively subsampled offline.
A practical 1D variable-density subsampling scheme was used.

## Getting Started
Clone or download the CORE-PI code. 

### Prerequisites
A liscence for Matlab is required. The code was tested with Matlab2017R. 

## Running the examples
Open the "main.m" function in Matlab, choose one example from the following list, set the desired
reduction factor (R), and run the code.


![demo1](https://github.com/EfratShimron/TED-toolbox/blob/master/figures/TED_Agar_phantom_small.png)


## Acknowledgments
The agar phantom data is courtesy of Prof. William Grissom, Vanderbilt University, TA, USA.
The gel phantom data is courtesy of Insightec Ltd., Tirat HaCarmel, Israel. 
