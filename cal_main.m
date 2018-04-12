%ME 578 Project Main 
%Derrik Adams
%4/3/18
%ALL UNITS ARE IN METERS
% clear all;
% clc;
function [Habitat_material_volume, Total_cost, opt_num_farm_domes, opt_num_lab_domes, opt_num_storage_domes,... 
    farm_rad, lab_rad, storage_rad, tube_length, tube_rad, barracks_length, barracks_width, barracks_height] = cal_main(people, duration, lab_equip)
%Get number of people and mission duration. This will come from JMP GUI
%input. Mission duration will be time on Mars not including the travel time
%to get there.
% people = input('Number of People: ');
% duration = input('Mission Duration (weeks): ');
% lab_equip = input('Number of Lab Equipment: ');
wall_thickness = .05;

%Based on input, calculate the volume per person needed using JMP model
vol_pp = 3.45/(1+exp(-.035338272*(duration-46.375824723))); %Based on JMP model

%Calculate the Required LAB AREA (m^2)
lab_area = cal_lab_size(people, lab_equip);

%Calculate the required FARM AREA. If mission is less than 90 days (~13 weeks) on Mars,
%then a farm is unnecessary (m^2)
if duration > 13
    farm_area = people*62;
    vol_farm_water = .5*farm_area; %500mm/total growing period over the area
else
    farm_area = 0;
end

%Calculate initial/total food supply
vol_per_meal = .3*.15*.03;
vol_per_day_pp = 3*vol_per_meal;
vol_food4trip = vol_per_day_pp*people*270; %Trip is approximately 9 months

if duration > 24
   vol_food_mars = vol_per_day_pp*people*(24*7); %This is a 6-month supply of food assuming they can grow their own
   vol_food = vol_food_mars+vol_food4trip;
else
    vol_food_mars = vol_per_day_pp*people*duration*7; %Take all the food they need if not growing any
    vol_food = vol_food_mars+vol_food4trip;
end

%Call function to calculate the needed volume of material to build the
%farm, lab, and storage dome along with the connecting tubes
[opt_num_farm_domes, opt_num_lab_domes, opt_num_storage_domes, farm_rad, lab_rad, storage_rad, tube_length, tube_rad, fls_material_vol] = cal_habitat_size(farm_area, lab_area, wall_thickness, vol_food);


%Call MIDACO to optimize the living space
executable = 'Mars_Habitat_Optimizer.exe %d %d %d';
exe_run = sprintf(executable, people, wall_thickness, vol_pp);
habitat_info = system(exe_run);

%Read in the data from the optimization run
barracks_data = dlmread('Optimized_Habitat.txt');
barracks_length = barracks_data(1);
barracks_width = barracks_data(2);
barracks_height = barracks_data(3);
barracks_material_vol = barracks_data(4);

%Calculate the total volume of habitat material needed for the entire
%structure
Habitat_material_volume = barracks_material_vol + fls_material_vol;

%Calculate the cost of materials and cost of sending it into space
Total_cost = cal_total_cost(people, Habitat_material_volume, vol_per_meal, vol_food, lab_area);
end
