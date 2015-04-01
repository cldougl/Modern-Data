

%Add data for flightplans (taken from https://flightplandatabase.com)
%Paris Charles de Gaulle to Newark Liberty Intl
flight.Lat = [49.00974 49.03169 49.06917 49.08333 49.22111 49.32139 ...
                49.39722 49.41056 49.43389 49.44889 49.47528 49.50000 ...
                49.05278 49.00000 48.00000 46.00000 44.00000 43.00000 ...
                43.07222 43.00000 42.19778 41.28189 41.16306 40.88147 ...
                40.80096 40.69363];
flight.Lon = [2.56262 1.22086 -0.25000 -1.17833 -2.04611 -3.55056...
                -4.98111 -5.26639 -5.82278 -6.21806 -7.02139 -8.00000 ...
                -11.76833 -15.00000 -20.00000 -30.00000 -40.00000 ...
                -50.00000 -57.86806 -60.00000 -67.00000 -70.02672 ...
                -70.56357 -71.78663 -72.46166 -74.16856];
% Hong Kong Intl to London Heathrow      
flight2.Lat = [22.29628 22.31197 22.32796 22.16003 22.08261 22.21667 ...
                28.57667 42.85000 50.19972 52.37500 54.20417 54.99000 ...
                55.59333 55.76667 56.45000 57.10000 57.51667 57.70000 ...
                57.98333 58.37500 58.48833 58.43333 58.18167 57.85389 ...
                57.55056 57.16500 56.33978 55.54618 54.84056 54.18569 ...
                53.06484 52.39472 51.55846 51.46477];
flight2.Lon = [113.89799 113.94696 113.99728 114.06008 113.84875 ...
                113.62500 109.44833 93.63333 81.36750 76.07167 70.75639 ...
                68.20000 64.49000 62.91667 59.13333 55.28333 52.65000 ...
                50.26667 46.90000 42.35833 39.14500 32.53333 28.49000 ...
                25.91611 23.08306 19.92472 15.28603 12.27193 9.88750 ...
                7.91070 4.72514 2.50250 -0.19627 -0.48695];
% Los Angeles Intl to Tokyo Haneda Intl
flight3.Lat = [33.94313 35.48456 36.88433 38.44375 40.09891 42.2325 ...
                42.47957 46.94703 47.47209 48.29989 48.50194 49.05217 ...
                50.68425 53.25217 53.62167 53.99959 56.19442 57.11495 ...
                57.46413 57.77503 58.05753 57.95219 57.73767 57.53631 ...
                54.92769 53.74642 53.40878 51.65764 49.71067 46.21667 ...
                42.39106 41.91667 40.42000 38.90631 38.32538 37.14886 ...
                36.74437 35.54825];
flight3.Lon = [-118.40892 -119.09731 -119.81514 -121.55164 -122.23635 ...
                -122.84113 -122.91293 -124.14928 -124.23066 -124.62706 ...
                -124.84815 -125.45508 -127.36519 -131.80708 -133.80500 ...
                -136.00160 -144.00174 -148.50199 -150.53094 -152.33983 ...
                -165.21522 -170.76094 -174.16794 -176.80139 171.98017...
                169.23181 168.23983 163.64494 159.34675 153.00333 ...
                147.47575 146.86000 144.99667 143.22799 142.46599 ...
                140.97569 140.34985 139.78855];


%source: http://www.mathworks.com/help/map/examples/plotting-a-3-d-dome-as-a-mesh-over-a-globe.html

grs80 = referenceEllipsoid('grs80','km');

%Construct a basic globe display using axesm and globe.
figure('Renderer','opengl')
ax = axesm('globe','Geoid',grs80,'Grid','on', ...
    'GLineWidth',1,'GLineStyle','-',...
    'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
axis equal off
view(3)

% Add low-resolution global topography, coastlines, and rivers to the globe.
load topo
geoshow(topo,topolegend,'DisplayType','texturemap')
demcmap(topo)
land = shaperead('landareas','UseGeoCoords',true);
plotm([land.Lat],[land.Lon],'Color','black')
rivers = shaperead('worldrivers','UseGeoCoords',true);
plotm([rivers.Lat],[rivers.Lon],'Color','blue')
plotm([flight.Lat],[flight.Lon],'Color','red')
plotm([flight2.Lat],[flight2.Lon],'Color','yellow')
plotm([flight3.Lat],[flight3.Lon],'Color','green')


%parse figure 

pf = fig2plotly(gcf,'open',false,'strip',false,'filename', ...
    'Earth & Flight Plans', 'fileopt','overwrite'); 

%---ADJUST THE TRACE STYLE--%

%-latitude lines-% 
%pf.data{1}.line.color = 'rgb(39, 78, 19)';
pf.data{1}.line.color = 'rgb(80, 20, 80)';
pf.data{1}.line.width = 0.75; 
pf.data{1}.name = 'Latitude';  

%-longitude lines-%
pf.data{2}.line.color = 'rgb(80, 20, 80)';
pf.data{2}.line.width = 0.75; 
pf.data{2}.name = 'Longitude'; 

%-surface water-%
pf.data{3}.colorscale = {{0,'rgb(31, 119, 180)'}, {1, 'rgb(10, 50, 100)'}};
pf.data{3}.opacity = 0.4; 

%-border lines-%
pf.data{4}.line.color = 'rgb(230, 255, 230)';
pf.data{4}.line.width = 2.5; 
pf.data{4}.name = 'Land Borders'; 

%-rivers-%
pf.data{5}.line.color = 'rgb(31, 119, 180)';
pf.data{5}.line.width = 0.9;
pf.data{5}.name = 'Rivers'; 

%-flight plans-%
pf.data{6}.line.color = 'rgb(250, 20, 20)';
pf.data{6}.line.width = 3;
pf.data{6}.name = 'Paris -> NYC'; 

pf.data{7}.line.color = 'rgb(240, 200, 40)';
pf.data{7}.line.width = 3;
pf.data{7}.name = 'Hong Kong -> London'; 

pf.data{8}.line.color = 'rgb(20, 250, 140)';
pf.data{8}.line.width = 3;
pf.data{8}.name = 'LA -> Tokyo'; 

   
%---ADJUST THE LAYOUT--%

pf.layout.scene.bgcolor = 'rgb(0, 0, 0)';
pf.layout.showlegend = true; 

%--xaxis--%
pf.layout.scene.xaxis.showgrid = false; 
pf.layout.scene.xaxis.zeroline = false; 
pf.layout.scene.xaxis.showspikes = false; 
pf.layout.scene.xaxis.showticklabels = false; 

%--yaxis--%
pf.layout.scene.yaxis.showgrid = false; 
pf.layout.scene.yaxis.zeroline = false; 
pf.layout.scene.yaxis.showspikes = false; 
pf.layout.scene.yaxis.showticklabels = false; 

%--zaxis--%
pf.layout.scene.zaxis.showgrid = false; 
pf.layout.scene.zaxis.zeroline = false; 
pf.layout.scene.zaxis.showspikes = false; 
pf.layout.scene.zaxis.showticklabels = false;

%--Graph the MATLAB figure online in Plotly!--%
pf.plotly; 