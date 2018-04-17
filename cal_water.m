function [ meter_cubed_water, mass_water ] = cal_water( num_people, duration, water_per_day)
%CAL_WATER calculates the amount of water that a mission needs
% in order to sustain life.
% num_people: the number of people on the mission
% duration: the duration of mission in weeks only for time on mars
% water_per_day: the amount of water that each astronaut uses daily in
% gallons
% water_vol: launch volume of water for the mission in the same units
% as the water_per_day value (defaults to gallons)
if nargin < 3
    water_per_day = 3;
end
meter_cubed_per_gallon = 0.00378541; %m^3/gal
water_dens = 999.97; %kg/m^3
daily_water_use = num_people .* water_per_day;
daily_water_loss = 0.3 .* daily_water_use;
num_days = ceil(duration .* 7.0);
total_water_loss = daily_water_loss .* num_days;
water_vol = total_water_loss + daily_water_use; % gal
meter_cubed_water = water_vol / meter_cubed_per_gallon; %m^3
mass_water = meter_cubed_water * water_dens; %kg
end

