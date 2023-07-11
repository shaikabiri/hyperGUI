# hyperGUI
A Versatile Tool for Hyperspectral Image Analysis and Data Extraction

## User Guide
HyperGUI is based on two datasets which can be accessed via these links: [A dataset for benchtop hyperspectral image](https://gsi.geodata.gov.ie/downloads/Bedrock/Data/Hyperspectral_Sample_data.zip) and [a dataset for aerial hyperspectral image](https://data.mendeley.com/datasets/5ph8ms8p5n/2). Checking these sample datasets will help with utilizing the software.

### Benchtop sample
- For a benchtop sample first load the raw and hdr files of the image while selecting laboratory as type of hyperspectral image.

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/136814e7-b986-4dd3-a373-d0612f22482f)

</kbd>

<br><br>

- If available upload the raw and hdr files of the white and dark current seperately.

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/b0359ad0-5247-469e-8978-3d8a0c11b139)

</kbd>

<br><br>

- After loading the data and references, and dark/white current calibration or dark pixel subtraction in case no references are available can be selected to perform.

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/766d97d4-64ed-410e-9b68-6d59727546ac)

</kbd>

<br><br>

- When the calibration is finished, the calibrated image can be displayed by refereshing the image with changing the scroller for wavelength in the sidebar.

<kbd>

  ![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/d100be15-ccdc-4412-b3a1-6130dcca0c1b)

</kbd>

<br><br>

- The calibrated image can be saved to a MATLAB, R or Python dataframe using the sidepanel. Optionally the wavelengths can be saved in case needed.

<kbd>

  ![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/36c8e091-fc8c-4e75-8034-cf00dccee8fb)

</kbd>

<br><br>

- The image can be displayed either as a monochromatic image for each spectrum, pseudo-RGB for three spectra or pseudo-RGB for three most important components of PCA. For RGB image after selecting wavelengths, render should be clicked. This is to save computational resources. 

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/a8548ccf-a5ad-4d86-8f37-ee826628a8de)

</kbd>

<br><br>

- For PCA a spectral range can be selected to perform the PCA on. Calculate PCA should be clicked to start PCA calculation. After PCA is finsihed by clickinng on the next button, variance explained by PCA component will be plotted. If a reduced PCA data is needed for saving, a proportion of variance explained can be selected to automatically save the data by number of components needed to reach that degree of variance. The saving format will be determined by the same selector as before.

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/0033ae9e-f1fc-477c-95f5-7df49e53567b)

</kbd>

<br><br>

- For cropping  select the crop tool from left corner of display section, and click and drag the mouse on the region of interest. This can be done regardless of type of image that is being displayed.

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/700f3d66-a9f8-4f3f-8b65-6ddcbe8f131e)

</kbd>

<br><br>

- To plot spectra select the plot signal tool from left corner of display section and select the desired range below, then click and drag the mouse on the region of interest. Clear button can be used to clear the plots and ROIs. 

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/6e17a9b6-64a8-4ad0-a630-79c1dccfd193)

</kbd>

### Aerial Sample
- To load an aerial sample change the type of hyperspectral image to aerial and load the raw and hdr file. 

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/ba1fb744-6f1a-464e-aaf7-cb677b7aac10)

</kbd>

<br><br>

- For ground references, the shapefiles and spectral data of ground references should be loaded. Make sure shapefiles are in .shp format alongside their .shx and .dbf files and references are in raw ENVI and hdr format. Also references shapefile and spectral files should be named in an ordered fashion. 

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/7c8338a5-3b3a-4a38-9900-fcab4582978a)

</kbd>

<br><br>

- After loading all the files linear calibration or in the case that references are not available, dark pixel subtraction can be performed. 

<kbd>
  
![image](https://github.com/shaikabiri/hyperGUI/assets/114778345/3d82ac30-bf61-40a3-a389-44f838cd493e)

</kbd>

<br><br>

- The calibrated image can be saved as a raster file.

<br><br>

- The rest of functions is the same as for benchtop sample. 

## Copyright for the used data

- Benchtop data: From Irish Public Sector Data (Geological Survey Ireland) licensed under a Creative Commons Attribution 4.0 International (CC BY 4.0) licence.
<br><br>
- Aerial data: From Jha, Sudhanshu Shekhar; C.V.S.S, Manohar Kumar; Nidamanuri, Rama Rao (2020), “Multi-platform optical remote sensing dataset for target detection”, Mendeley Data, V2, doi: 10.17632/5ph8ms8p5n.2, licensed under a Creative Commons Attribution 4.0 International (CC BY 4.0) licence.












