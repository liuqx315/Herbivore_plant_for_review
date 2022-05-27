# The code are for published paper by Zhenpeng Ge and Quan-Xing Liu, Foraging behaviors lead to spatiotemporal self-similar dynamics in grazing ecosystems,  Ecology Letters, 2022, 25(2):378-390. DOI: 10.1111/ele.13928

## Herbivore_plant
The numerical models are peroformed in three different computing environment, i.e., MATLAB2019b, cupy, and pyopencl, respectively. 

Use "Grazing_CPU_movie.m" to watch the movie of the simulation in MATLAB.

Use "Grazing_GPU.m" to generate the data from the simulation in MATLAB.

Use "Herbivore_Plant_cupy.ipynb" to generate the data from the simulation in Jupyter lab (or Jupyter notebook) with python. 

Use "Herbivore_Plant_pyopencl.ipynb" to produce Figure 5b of the paper in Jupyter lab (or Jupyter notebook) with python.

Use "Circularly_averaged_structure_factor_raster.m" calculate structure factors of spatial pattern.

Use "Raster_TL_DF_Convolution.m" calculate density flucutation of spatial pattern.

"Spatial_wavelength.zip" gives an example to compute spatial wavelengths (patch size) of spatial patterns, please follow the procedures in the document.

"Imageanalysis.zip" provides the codes to do the point pattern analysis of the sheep in Figure 1f, please follow the procedures in the document.
