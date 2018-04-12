% general params
min_time = 0; % days
max_time = 1825; %days
min_pop = 1; % people
max_pop = 200; % people

% parameters for room size calcs
min_size = 9.2903; %m^2
max_size = 13.9355; %m^2
del_size = max_size - min_size;
tran_start = 365; %days
tran_end = 1095; %days (4years)
tran_len = tran_end - tran_start;
center_offset = (tran_end - tran_start) / 2 + tran_start;

% parameters for storage space calculations
water_per_day = 0.023; %m^3
hygene_per_day = 0.0215; %m^2
food_per_day = 0.008; %m^3
base_calories = 2000; %Calories

% parameters for lab space calculations
avg_equip_size = 0.15; %m^2
equip_size_range = 0.02; %m^2
lab_space_per_person = 0.02; %m^2
max_lab_space = 46.45; %m^2 (500 sqft)
