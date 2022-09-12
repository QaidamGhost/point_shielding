function shielding_factor=point_shielding(path_to_dem,lat,lon,radius,strike,dip)

%% Determine the shielding factor at the given point for calibrating cosmogenic nuclides' production rates.
% Some dependencies are needed. See README.md.

%% Arguments:
% path_to_dem: the path to DEM file using UTM projection and WGS84 datum
% (unitless; string)
% lat: latitude of the point (degree; scalar)
% lon: longitude of the point (degree; scalar)
% radius: ignore the shielding effect of the DEM cells within the given
% radius of the given point (meter; scalar)
% strike: strike azimuth of the point's surface (dip direction subtracts 90
% degree) (degree; scalar)
% dip: dip of the point's surface (degree; scalar)

%% Output:
% shielding_factor: shielding factor (unitless; scalar)

    % lat=38.6087;lon=94.1242;
    % lat=38.820272;lon=93.503892;

    % check and download the dependencies
    if ~exist("ll2utm.m","file")
        websave('ll2utm.m','https://raw.githubusercontent.com/IPGP/mapping-lib/master/latlonutm/ll2utm.m');
    end
    if ~exist("skyline.m","file")
        websave('skyline.m','http://stoneage.ice-d.org/math/skyline/skyline.m');
    end

    % load DEM file
    DEM = GRIDobj(path_to_dem);
    % convert lat/lon to UTM coordinates in WGS84 datum
    [X,Y]=ll2utm(lat,lon);

    % check if the point is within the range of DEM
    if X>max(DEM.georef.SpatialRef.XWorldLimits) || X<min(DEM.georef.SpatialRef.XWorldLimits) || Y>max(DEM.georef.SpatialRef.YWorldLimits) || Y<min(DEM.georef.SpatialRef.YWorldLimits) 
        error("Input point exceeds the range of DEM.");
    end

    % determine the row and column indexes of the point in the DEM cells
    n=round(interp1(DEM.georef.SpatialRef.XWorldLimits,DEM.georef.SpatialRef.XIntrinsicLimits,X));
    m=round(interp1(DEM.georef.SpatialRef.YWorldLimits,[DEM.georef.SpatialRef.YIntrinsicLimits(2),DEM.georef.SpatialRef.YIntrinsicLimits(1)],Y));
    
    % initialization
    azimuths360=0:1:360;
    elevations360=zeros(1,361);
    for i=1:DEM.georef.SpatialRef.YIntrinsicLimits(2)
        for j=1:DEM.georef.SpatialRef.XIntrinsicLimits(2)
            % determine the distance between the point and a DEM cell
            delta_Y=(i-m)*DEM.georef.SpatialRef.SampleSpacingInWorldY;
            delta_X=-(j-n)*DEM.georef.SpatialRef.SampleSpacingInWorldX;
            delta_Z=DEM.Z(i,j)-DEM.Z(m,n);
            delta_D=sqrt(delta_Y^2+delta_X^2);

            % calculate azimuths
            if delta_Y==0
                if delta_X>=0
                    azimuths=90;
                elseif delta_X<0
                    azimuths=270;
                end
            elseif delta_Y~=0
                if delta_Y>0 && delta_X>=0
                    azimuths=atan(delta_X/delta_Y)*180/pi;
                elseif delta_Y<0 && delta_X>=0
                    azimuths=atan(delta_X/delta_Y)*180/pi+180;
                elseif delta_Y<0 && delta_X<0
                    azimuths=atan(delta_X/delta_Y)*180/pi+180;
                elseif delta_Y>0 && delta_X<0
                    azimuths=atan(delta_X/delta_Y)*180/pi+360;
                end
            end

            % calculate elevations
            % elevations are defined in the link below:
            % http://stoneage.ice-d.org/math/skyline/skyline_in.html
            if delta_Z<0
                elevations=0;
            elseif delta_Y==0 && delta_X==0
                elevations=0;
            elseif delta_D<=radius
                elevations=0;
            else
                elevations=atan(delta_Z/delta_D)*180/pi;
            end
            % merged into azimuths' 360 direction
            index=find(azimuths360==round(azimuths));
            if elevations360(index) < elevations
                elevations360(index) = elevations;
            end
        end
    end

    % delete 0 azimuth, or 'skyline.m' will return errors
    elevations360(length(elevations360))=elevations360(length(elevations360))+elevations360(1);
    elevations360(1)=[];
    azimuths360(1)=[];
    % calculate shielding factor
    [shielding_factor,~,~]=skyline(azimuths360,elevations360,strike,dip);
    % print results
    fprintf('The SHIELDING FACTOR is %.5f at latitude %.4f and longitude %.4f.\n',shielding_factor,lat,lon);
end
