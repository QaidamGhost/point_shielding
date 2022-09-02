**MATLAB script for determining shielding factor at the given point for calibrating cosmogenic nuclides' production rates.**

**September 2, 2022**

The MATLAB script "point_shielding.m" is written by Yizhou Yang. **See file "NOTICE" for copyright and licensing notice pertaining to the .m-file in this directory.**

## Instruction
 0. Git clone 'point_shielding'.
 1. Install 'TopoToolbox' using MATLAB's ADD-ON. You can also download it using the url "https://github.com/wschwanghart/topotoolbox/releases/download/2.4/TopoToolbox.mltbx" and install manually.
 2. Download the 'latlonutm' folder from the url 'https://github.com/IPGP/mapping-lib/tree/master/latlonutm'. Only the 'll2utm.m' is called by 'point_shielding.m'. You can also switch to the 'point_shielding' folder and run the command below in MATLAB to get the 'll2utm.m'.
```
    websave('ll2utm.m','https://raw.githubusercontent.com/IPGP/mapping-lib/master/latlonutm/ll2utm.m')
```
 3. Download the 'CRONUS Be-10/Al-26 Calculator' using the url 'https://ars.els-cdn.com/content/image/1-s2.0-S1871101407000647-mmc3.tar' and extract the tar file. Only the 'skyline.m' is called by 'point_shielding.m'. You can also switch to the 'point_shielding' folder and run the command below in MATLAB to get the 'skyline.m'.
```
    websave('skyline.m','http://stoneage.ice-d.org/math/skyline/skyline.m')
```
 4. Prepare a DEM file covering the given point. The DEM file must be in UTM projection and WGS84 datum.
 5. Use ```'addpath'``` command in MATLAB to locate the aforementioned 'll2utm.m' and 'skyline.m', if they are not put in the 'point_shielding' folder containing 'point_shielding.m'.
 6. Run the command below in MATLAB. The arguments are introduced in the 'point_shielding.m'. For default using, please set 'radius', 'strike', and 'dip' to zero before runnig the script.
```
    point_shielding(path_to_dem,lat,lon,radius,strike,dip)
```

## Software Version and Dependency
 - Matlab 2021b or higher version (Recommend).
 - TopoToolbox and its dependencies.
 - 'll2utm.m' in 'latlonutm'.
 - 'skyline.m' in 'CRONUS Be-10/Al-26 Calculator'.

## Platforms for Tests
 - AMD RYZEN R5-3600x / MSI B450m MORTAR / Windows 10 21H2

## References
 - Balco, Greg, et al. "A complete and easily accessible means of calculating surface exposure ages or erosion rates from 10Be and 26Al measurements." Quaternary geochronology 3.3 (2008): 174-195.
 - François Beauducel (2022). LL2UTM and UTM2LL (https://www.mathworks.com/matlabcentral/fileexchange/45699-ll2utm-and-utm2ll), MATLAB Central File Exchange.
 - Schwanghart, Wolfgang, and Dirk Scherler. "TopoToolbox 2–MATLAB-based software for topographic analysis and modeling in Earth surface sciences." Earth Surface Dynamics 2.1 (2014): 1-7.
