function [ power_req, panels_req_farm, total_panel_req, farm_panel_weight, total_panel_weight ] = cal_power( num_people, farm_size, habitation_len, habitation_width, lab_area, storage_rad, water_power )
%CAL_POWER - Caluculates the power and solar panels required for the base on mars.
%INPUTS:
%num_people - the number of people in the mission
%farm_size - the size of the farm in sq meters
%habitation_len - length of the habitation in meters
% habitation_width - width of the habitation in meters
%lab_area - the size of the lab in meters^2
%storage_rad - radius of the storage area
%water_power - the total amount of power required by the water reclamation system

%OUTPUTS:
%power_req - the total power in Whr/day that the base requires
% panels_req_farm - the number of solar panels that are required for the farm
% total_panel_req - the total number of solar panels that are required for the entire base
% farm_panel_weight - the weight of the solar panels for the farm
% total_panel_weight - the weight of the solar panels required to support the entire base

%power requirements
%light assumed to be needed for 16 hrs per day
% coverage = -0.1162 + 0.005535 * wattage
% Lights are typically 600-ish watts
farm_light_time = 16; %hrs
min_per_hour = 60;
sec_per_min = 60;
farm_light_seconds = farm_light_time * min_per_hour * sec_per_min;
grow_light_power = 600; %2atts
grow_light_daily_power = 600 * farm_light_time * min_per_hour * sec_per_min;
grow_light_coverage = -0.1162 + 0.005535 * grow_light_power;
% panels are assumed to be 20% Efficient
% per https://nssdc.gsfc.nasa.gov/planetary/factsheet/marsfact.html
% mars recieves and average of 586 w/m^2 for ~16hr/day
% panel size is approx 1.75m^2 and around 18 kg
panel_efficiency = 0.2;
panel_percent_gen = 0.7; %the percentage of sunlight time that the panels actually produce power
mars_daylight_hours = 16;
panel_size = 1.75; % m^2
panel_weight = 18; % kg
panel_power_per_day = 586 * min_per_hour * sec_per_min * mars_daylight_hours * panel_efficiency * panel_percent_gen; % joules

n_grow_lights_reqd = ceil(farm_size / grow_light_coverage);
daily_farm_power_reqd = n_grow_lights_reqd * grow_light_daily_power; %joules
panels_req_farm = ceil(daily_farm_power_reqd / panel_power_per_day);
farm_panel_weight = panels_req_farm * panel_weight;

%calculations for the habitation lighting
% per osha 1926.56 10 foot-candles is a min light value
lit_hours = 16; % 16 hours per day of lighting
foot_candle_req = 10;
lumen_per_foot_candle = 10.76; %per m^2
lumen_required_per_sqmeter = foot_candle_req * lumen_per_foot_candle; %per m^2
watt_per_lumen = 0.007532; % per light output jmp file
lit_ratio = 0.5; %represents the ratio of lights that are on at any given time

hab_sq_meter = habitation_len * habitation_width;
lab_sq_meter = lab_area;
storage_sq_meter = pi * storage_rad^2;
lit_sq_meter = hab_sq_meter + lab_sq_meter + storage_sq_meter;
lumen_required = lit_sq_meter * lumen_required_per_sqmeter;
lit_watt_requrired = lumen_required * watt_per_lumen;
lit_power_per_day = lit_watt_requrired * lit_hours * min_per_hour * sec_per_min * lit_ratio; % joules
lit_panels_reqd = lit_power_per_day / panel_power_per_day;
lit_panels_weight = lit_panels_reqd * panel_weight;

%calculation for water recycling operation
water_panels_reqd = water_power / panel_power_per_day;
water_panels_weight = water_panels_reqd * panel_weight;

%calculation for oxygen generation
% per https://spaceflightsystems.grc.nasa.gov/repository/NRA/tm206956v1%20living%20together%20%20in%20space.pdf
oxygen_power_reqd = 1470; %watts
oxygen_hours_per_day = 24;
oxygen_daily_power = oxygen_power_reqd * oxygen_hours_per_day * min_per_hour * sec_per_min; %joules
oxygen_panels_reqd = oxygen_daily_power / panel_power_per_day;
oxygen_panel_weight = oxygen_panels_reqd / panel_weight;

total_panel_req = ceil(panels_req_farm + lit_panels_reqd + water_panels_reqd + oxygen_panels_reqd);
total_panel_weight = farm_panel_weight + lit_panels_weight + water_panels_weight + oxygen_panel_weight;

power_req = daily_farm_power_reqd + lit_power_per_day + water_power + oxygen_daily_power;

end

