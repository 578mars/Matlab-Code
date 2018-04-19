%ME 578 Project Main
%Derrik Adams
%4/3/18
%ALL UNITS ARE IN METERS
% clear all;
% clc;
 function [Habitat_material_volume, Total_cost, opt_num_farm_domes, opt_num_lab_domes, opt_num_storage_domes,...
     farm_rad, lab_rad, storage_rad, tube_length, tube_rad, barracks_length, barracks_width, barracks_height, num_panels_total] = cal_main(people, duration, lab_equip)

%Get number of people and mission duration. This will come from JMP GUI
%input. Mission duration will be in weeks and will be the time on Mars not including the travel time
%to get there.
% people = input('Number of People: ');
% duration = input('Mission Duration (weeks): ');
% lab_equip = input('Number of Lab Equipment: ');
wall_thickness = .05;

%Based on input, calculate the volume per person needed using JMP model
vol_pp = 3.45/(1+exp(-.035338272*(duration-46.375824723))); %Based on JMP model

%Calculate the water needed for the people during the mission 
[person_water_vol, person_water_mass] = cal_water(people, duration);

%Calculate the weight needed for the water recycling equipment
[recycle_equip_mass, recycle_equip_power, recycle_equip_vol] = cal_water_recycle_weight(people, duration);

%Calculate the Required LAB AREA (m^2)
lab_area = cal_lab_size(people, lab_equip);

%Call MIDACO to optimize the living space
executable = 'Mars_Habitat_Optimizer.exe %d %d %d';
exe_run = sprintf(executable, people, wall_thickness, vol_pp);
habitat_info = system(exe_run);

%Read in the data from the optimization run
barracks_data = dlmread('Optimized_Habitat.txt');
barracks_length = barracks_data(1) + 1;
barracks_width = barracks_data(2) + 1;
barracks_height = barracks_data(3);
barracks_material_vol = barracks_data(4);


%Calculate volume of food per day per person
vol_per_meal = .3*.15*.03; %m^3
vol_per_day_pp = 3*vol_per_meal; %volume of food for one person per day

%Calculate the volume of food necessary for the trip to Mars
vol_food4trip = vol_per_day_pp*people*270*2; %Trip is approximately 9 months (270 days) * 2 for both ways

%Calculate the required FARM AREA. If mission is less than 90 days (~13 weeks) on Mars,
%then a farm is definitely unnecessary (m^2)
if duration > 13
    farm_area = people*61;
    vol_farm_water = 0;%.5*farm_area; %500mm/total growing period over the area
else
    farm_area = 0;
    vol_food_mars = vol_per_day_pp*people*duration*7;
    vol_farm_water = 0;
end


%Determine if it's cheaper to just take food or to build a farm and grow it:
if duration > 13
    
    %Calculate the amount of food needed to just take it
    vol_food_mars_nf = vol_per_day_pp * people * duration * 7; %total volume of food if not farming
    vol_food_nf = vol_food_mars_nf + vol_food4trip; %total volume of food for the trip and for mars
    farm_area_nf = 0;
    vol_farm_water_nf = 0;
    total_water_nf = vol_farm_water_nf + person_water_vol;
    
    %Assuming no farm, calculate material needed for everything else
    [opt_num_farm_domes_nf, opt_num_lab_domes_nf, opt_num_storage_domes_nf, farm_rad_nf, lab_rad_nf, storage_rad_nf, tube_length_nf, tube_rad_nf, fls_material_vol_nf] = cal_habitat_size(farm_area_nf, lab_area, wall_thickness, vol_food_mars_nf, recycle_equip_vol, vol_farm_water_nf, person_water_vol);
   
    %Caculate power requirements with no farm
    [total_daily_power_nf, farm_panels_nf, total_panels_nf, farm_panel_weight_nf, total_panel_weight_nf] = cal_power(people, farm_area_nf, barracks_length, barracks_width, lab_area, storage_rad_nf, recycle_equip_power);
    
    %Calculate cost of not using farms but taking food
    Habitat_material_volume_nf = barracks_material_vol + fls_material_vol_nf;
    
    %Calculate the cost of materials and cost of sending it into space
    Total_cost_nf = cal_total_cost(people, Habitat_material_volume_nf, vol_per_meal, vol_food_nf, lab_area, total_panel_weight_nf, total_water_nf, recycle_equip_mass);
    
    
    %Calculate the cost of farming on Mars rather than just taking it all
    if duration < 24
        vol_food_mars_f = vol_per_day_pp * people * duration/2 * 7; %Take an additional food supply of 1/2 the duration on mars just in case
    else
        vol_food_mars_f = vol_per_day_pp * people* 90 * 2; %If over 6 month mission, take enough food to have while growing initial crop and an extra 90 days worth just in case
    end
    vol_food_f = vol_food_mars_f + vol_food4trip;
    total_water_f = person_water_vol + vol_farm_water;
    
    %Call function to calculate the needed volume of material to build the
    %farm, lab, and storage dome along with the connecting tubes
    [opt_num_farm_domes_f, opt_num_lab_domes_f, opt_num_storage_domes_f, farm_rad_f, lab_rad_f, storage_rad_f, tube_length_f, tube_rad_f, fls_material_vol_f] = cal_habitat_size(farm_area, lab_area, wall_thickness, vol_food_mars_f, recycle_equip_vol, vol_farm_water, person_water_vol);
    
    %Caculate power requirements with a farm
    [total_daily_power_f, farm_panels_f, total_panels_f, farm_panel_weight_f, total_panel_weight_f] = cal_power(people, farm_area, barracks_length, barracks_width, lab_area, storage_rad_f, recycle_equip_power);
    
    
    %Calculate the total volume of habitat material needed for the entire
    %structure
    Habitat_material_volume_f = barracks_material_vol + fls_material_vol_f;
    
    %Calculate the cost of materials and cost of sending it into space
    Total_cost_f = cal_total_cost(people, Habitat_material_volume_f, vol_per_meal, vol_food_f, lab_area, total_panel_weight_f, total_water_f, recycle_equip_mass);
    
    if Total_cost_nf < Total_cost_f
        Habitat_material_volume = Habitat_material_volume_nf;
        Total_cost = Total_cost_nf;
        opt_num_farm_domes = opt_num_farm_domes_nf;
        opt_num_lab_domes = opt_num_lab_domes_nf;
        opt_num_storage_domes = opt_num_storage_domes_nf;
        farm_rad = farm_rad_nf;
        lab_rad = lab_rad_nf;
        storage_rad = storage_rad_nf;
        tube_length = tube_length_nf;
        tube_rad = tube_rad_nf;
        num_panels_total = total_panels_nf;
    else
        Habitat_material_volume = Habitat_material_volume_f;
        Total_cost = Total_cost_f;
        opt_num_farm_domes = opt_num_farm_domes_f;
        opt_num_lab_domes = opt_num_lab_domes_f;
        opt_num_storage_domes = opt_num_storage_domes_f;
        farm_rad = farm_rad_f;
        lab_rad = lab_rad_f;
        storage_rad = storage_rad_f;
        tube_length = tube_length_f;
        tube_rad = tube_rad_f;
        num_panels_total = total_panels_f;
    end
else
    %If duration is less than 13 weeks, just calculate everything
    %Assuming no farm, calculate material needed for everything else
    [opt_num_farm_domes, opt_num_lab_domes, opt_num_storage_domes, farm_rad, lab_rad, storage_rad, tube_length, tube_rad, fls_material_vol] = cal_habitat_size(farm_area, lab_area, wall_thickness, vol_food_mars, recycle_equip_vol, vol_farm_water, person_water_vol);
    vol_food = vol_food4trip+vol_food_mars;
    total_water_vol = person_water_vol;
    
    %Caculate power requirements with no farm
    [total_daily_power, farm_panels, total_panels, farm_panel_weight, total_panel_weight] = cal_power(people, farm_area, barracks_length, barracks_width, lab_area, storage_rad, recycle_equip_power);
    num_panels_total = total_panels;
    
    %Calculate total volume needed
    Habitat_material_volume = barracks_material_vol + fls_material_vol;
    
    %Calculate the cost of materials and cost of sending it into space
    Total_cost = cal_total_cost(people, Habitat_material_volume, vol_per_meal, vol_food, lab_area, total_panel_weight, total_water_vol, recycle_equip_mass);
end
    
end

