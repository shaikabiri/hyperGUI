# hyperGUI
A Versatile Tool for Hyperspectral Image Analysis and Data Extraction

## User Guide
HyperGUI is based on two datasets which can be accessed via these links: [A dataset for benchtop hyperspectral image](https://gsi.geodata.gov.ie/downloads/Bedrock/Data/Hyperspectral_Sample_data.zip) and [a dataset for aerial hyperspectral image](https://data.mendeley.com/datasets/5ph8ms8p5n/2). Checking these sample datasets will help with utilizing the software.

### Benchtop sample
For a benchtop sample first load the raw and hdr files of the image while selecting labratory as type of hyperspectral.
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/136814e7-b986-4dd3-a373-d0612f22482f)

If available upload the raw and hdr files of the white and dark current seperately.
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/b0359ad0-5247-469e-8978-3d8a0c11b139)

After loading the data and references, and dark/white current calibration or dark pixel subtraction in case no references are available can be selected to perform.
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/766d97d4-64ed-410e-9b68-6d59727546ac)

When the calibration is finished, the calibrated image can be displayed by refereshing the image with changing the scroller for wavelength in the sidebar.
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/d100be15-ccdc-4412-b3a1-6130dcca0c1b)

The calibrated image can be saved to a MATLAB, R or Python dataframe using the sidepanel. Optionally the wavelengths can be saved in case needed.
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/36c8e091-fc8c-4e75-8034-cf00dccee8fb)

The image can be displayed either as a monochromatic image for each spectrum, pseudo-RGB for three spectra or pseudo-RGB for three most important components of PCA. For RGB image after selecting wavelengths, render should be clicked. This is to save computational resources. 
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/a8548ccf-a5ad-4d86-8f37-ee826628a8de)

For PCA a spectral range can be selected to perform the PCA on. Calculate PCA should be clicked to start PCA calculation. After PCA is finsihed by clickinng on the next button, variance explained by PCA component will be plotted. If a reduced PCA data is needed for saving, a proportion of variance explained can be selected to automatically save the data by number of components needed to reach that degree of variance. The saving format will be determined by the same selector as before.
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/0033ae9e-f1fc-477c-95f5-7df49e53567b)

For cropping  select the crop tool from left corner of display section, and click and drag the mouse on the region of interest. This can be done regardless of type of image that is being displayed.
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/700f3d66-a9f8-4f3f-8b65-6ddcbe8f131e)

To plot spectra select the plot signal tool from left corner of display section and select the desired range below, then click and drag the mouse on the region of interest. Clear button can be used to clear the plots and ROIs. 
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/6e17a9b6-64a8-4ad0-a630-79c1dccfd193)









