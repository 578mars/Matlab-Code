function [ equip_weight ] = cal_water_recycle_weight( num_people, duration )
% cal_water_recycle_weight - calculates the weight of the equipment that is required
% for water recycling on the mission
% num_people: number of people that are going on the mission
% duration: the duration of the mission in weeks
% equip_weight: the weight in kg of the recycling equipment for the mission
%info from 
%https://spaceflightsystems.grc.nasa.gov/repository/NRA/tm206956v1%20living%20together%20%20in%20space.pdf
people_per_unit = 6;
water_processor_weight = 476; %kg per six people
urine_processor_weight = 128; %kg per six people
annual_wp_weight = 478; %kg per six people
annual_up_weight = 175; %kg per six people

num_units_required = ceil(num_people / people_per_unit);
hardwear_weight = num_units_required * (water_processor_weight + urine_processor_weight);
% I'm going to assume that the consumables for the processors are replaced every quarter
% i.e., every 3 months.
consumable_replacement_interval = 13; %weeks
weeks_per_year = 52;
consumable_interval_weight = (consumable_replacement_interval / weeks_per_year) * (annual_up_weight + annual_wp_weight);
num_consumable_intervals = ceil(duration / consumable_replacement_interval);
consumable_weight = num_consumable_intervals * consumable_interval_weight; %kg
equip_weight = hardwear_weight + consumable_weight; % kg
end