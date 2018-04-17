%Function to calculate the total required material needed for the entire
%habitat structure

function [opt_num_farm_domes, opt_num_lab_domes, opt_num_storage_domes, farm_rad, lab_rad, storage_rad, L_final, ri, v_min_final] = cal_habitat_size(A_farm, A_lab, wall_thickness, vol_food, recycle_equip_vol, vol_farm_water, vol_personal_water)
%     A_farm = 0;
%     A_lab = 20;
%     wall_thickness = .05;
%     vol_food = 44; 
count = 1;
%Calculate the required radius of a dome for storing the food to get the
%required area. This should allow us to see if more than one dome is
%necessary

%Calculate the volume of storage space required for water and water
%reclamation units
vol_storage = vol_food + vol_farm_water + vol_personal_water + recycle_equip_vol;
storage_radius = (3*vol_storage/(4*pi))^(1/3);
A_storage = pi*storage_radius^2;

%Test different maximum radii to find the one that produces the lowest
%total volume of material necessary
for i=2:.01:15
    
%Set maximum radius of the dome in meters    
max_radius(count) = i; %m
max_area = pi*max_radius(count)^2; %m^2

%Calculate the minumum number of domes for each section required
num_living_domes = 1;
num_storage_domes = ceil((A_storage/max_area));
num_farm_domes = ceil((A_farm/max_area));
num_lab_domes = ceil((A_lab/max_area));

%Find the total number of domes required for the entire habitat
num_domes = num_farm_domes + num_lab_domes + num_living_domes + num_storage_domes;

%Set the area of each dome. Each type of dome will have a different size,
%but all domes of a certain type will be the same size
if A_farm == 0
   A_farm_dome = 0;
else
    A_farm_dome = A_farm/num_farm_domes;
end
A_lab_dome = A_lab/num_lab_domes;
A_storage_dome = A_storage/num_storage_domes;

%Calculate the required volume of material for one dome for FARM
if A_farm_dome ==0
    V_farm = 0;
else
    V_farm = 4/6*pi*(((A_farm_dome/pi)^(.5)+ wall_thickness)^3-(A_farm_dome/pi)^(1.5));
end

%Calculate the required volume of material for one dome for LAB
V_lab = 4/6*pi*(((A_lab_dome/pi)^(.5)+ wall_thickness)^3-(A_lab_dome/pi)^(1.5));

%Calculate the required volume of material for one dome for STORAGE
V_storage = 4/6*pi*(((A_storage_dome/pi)^(.5)+ wall_thickness)^3-(A_storage_dome/pi)^(1.5));

%Calculate the total volume of material needed for just the domes
V_domes = V_farm*num_farm_domes + V_lab*num_lab_domes + V_storage;

%Calculate the required volume of material for all of the connection tubes
L = max_radius(count)/4+4; %Length of tube (m)
ro = 2.05; %outside radius (m)
ri =  2; %inside radius (m)
num_tubes = num_domes-1;

V_tubes = 1/2*(pi*L*(ro^2-ri^2))*num_tubes;

%Calculate the total volume of material needed for the habitat
total_material(count) = V_domes + V_tubes;
count = count+1;
end

%Plot the total volume 
% plot(max_radius,total_material)

%% Essentially what the following code does is pull the information for the
%best case from the matrices created in the above for loop.

%Determine the optimal radius
k=find(total_material == min(total_material));
opt_max_rad = max_radius(k);
vol_material_flst = min(total_material);


%Calculate the optimal max area for the domes. This is essentially the
%largest a dome can be to minimize the material. 
opt_area = pi*opt_max_rad^2; %m^2

%Calculate the minumum number of domes for each section required based on
%the optimal area from above.
opt_num_farm_domes = ceil((A_farm/opt_area));
opt_num_lab_domes = ceil((A_lab/opt_area));
opt_num_storage_domes = ceil((A_storage/opt_area));

%Find the total number of domes required (include standard central hub
%dome)
opt_num_domes = opt_num_farm_domes + opt_num_lab_domes + opt_num_storage_domes + 1;

%Find the optimal volume of material for the tubes
L_final = opt_max_rad/4+4;
opt_num_tubes = opt_num_domes-1;
V_tubes_final = 1/2*(pi*L_final*(ro^2-ri^2))*opt_num_tubes;

%Calculate the radius of each dome type based on optimal radius information
%found
if opt_num_farm_domes == 0
    opt_a_farm = 0;
else
    opt_a_farm = A_farm/opt_num_farm_domes;
end
farm_rad = (opt_a_farm/pi)^.5;

opt_a_lab = A_lab/opt_num_lab_domes;
lab_rad = (opt_a_lab/pi)^.5;
opt_a_storage = A_storage/opt_num_storage_domes;
storage_rad = (opt_a_storage/pi)^.5;

%The domes must be larger than the connection tube radius and large enough
%to stand in if they are to be useful. Therefore, the minimum radius of
%each dome regardless of the type must be 2.5m. 
if farm_rad < 2.5 && farm_rad ~= 0
    farm_rad =2.5;
end

if lab_rad < 2.5
    lab_rad = 2.5;
end

if storage_rad < 2.5
    storage_rad = 2.5;
end

%Recalculate the volume of material needed in the case that one of these
%radii were changed
%Calculate the required volume of material for one dome for FARM
V_farm_final = 4/6*pi*((farm_rad+wall_thickness)^3 - farm_rad^3);

%Calculate the required volume of material for one dome for LAB
V_lab_final = 4/6*pi*((lab_rad+wall_thickness)^3 - lab_rad^3);

%Calculate the required volume of material for one dome for STORAGE
V_storage_final = 4/6*pi*((storage_rad+wall_thickness)^3 - storage_rad^3);

%Calculate the total volume of material needed for just the domes
V_domes_final = V_farm_final*opt_num_farm_domes + V_lab_final*num_lab_domes + V_storage_final*opt_num_storage_domes;

%Calculate the final minimum value of material volume necessary for the
%Farm, Lab, Storage, and Tubes
v_min_final = V_domes_final + V_tubes_final;
end