function [ size ] = cal_storage_space( num_people, resupply_rate, avg_calories )
%cal_room_size calculate the number of square meters that need to be
% dedicated to habitations for the people living on mars.
% Num_people = number of people in the settlement (linear scaler)
% resupply_rate = how often a resupply comes (30 - 1825 days)
% size = cubic meters of that need to be dedicated to storage
params;
% how long we need to store food = resupply_rate
space_per_day = water_per_day * hygene_per_day *...
                (food_per_day * avg_calories / base_calories) * num_people;
size = space_per_day * min([resupply_rate, max_time]);
end
