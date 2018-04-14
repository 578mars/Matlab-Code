%Function to calculate the approximated total mission cost
%There are two parts to this total cost: total cost of supplies and
%approximate cost of sending that to space

%Look for cost estimating relationships

function [total_cost] = cal_total_cost(num_people, material_volume,vol_food_pm, vol_food, equipment_area)

%Define cost of HABITAT MATERIALS
habitat_material_density = 4.43; %kg/m^3 (Ti-6Al-4V)
habitat_material_cost = 50; %$/kg (approximate)

%Define cost of FOOD
num_meals = vol_food/vol_food_pm;
food_mass = num_meals*.83/3; %According to paper, 1 day allotment per person is .83kg (with packaging included)
food_cost_per_kg = 10; %$/kg (total guess)

%Define cost of LAB EQUIPMENT
equipment_cost = 1000; %$/m^2 (total guess)
equipment_unit_mass = 100; %kg/m^2
equipment_mass = equipment_unit_mass*equipment_area;

%Define human average mass for rocket costs
human_mass = 75; %kg

%Average cost to send 1kg of mass into space
space_cost = 22000; %$/kg 

%Calculate just raw material cost
total_habitat_material_cost = material_volume * habitat_material_density * habitat_material_cost;
total_food_cost = food_mass * food_cost_per_kg;
total_equipment_cost = equipment_area * equipment_cost;

%Calculate the total mass of stuff being sent to get "rocket cost"
total_mass = (material_volume*habitat_material_density) + food_mass + equipment_mass + (num_people*human_mass);

total_rocket_cost = total_mass*space_cost; 

total_cost = total_rocket_cost + total_habitat_material_cost+total_food_cost+total_equipment_cost;