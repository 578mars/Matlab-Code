%ME 578 - Mars Hut Project
%Derrik Adams
%4/5/18
%Main script to take in user input from JMP and call cal_main to compute
%the total material needed for the entire habitat, the total cost of
%acquiring and shipping it, and to obtain the number and dimensions of each
%type of dome in the structure
clear all
DOE = dlmread('Habitat_DOE_thousand.txt');
people = DOE(:,1);
duration = DOE(:,2);
lab_equip = DOE(:,3);
for i = 1:length(people)
    [Habitat_material_volume(i), Total_cost(i), Num_Farm_Domes(i), Num_Lab_Domes, Num_Storage_Domes,... 
    Radius_Farm, Radius_Lab, Radius_Storage, Tube_Length, Tube_Radius, Barracks_Length, Barracks_Width, Barracks_Height] = cal_main(people(i),duration(i),lab_equip(i));
end
% x = 1:1:i;
Habitat_material_volume = Habitat_material_volume';
Total_cost = Total_cost';
Num_Farm_Domes = Num_Farm_Domes';
plot(x,Habitat_material);
% 
% people = input('Number of People: ');
% duration = input('Mission Duration (weeks): ');
% lab_equip = input('Number of Lab Equipment: ');
% 
% 
% [Habitat_material_volume, Total_cost, Num_Farm_Domes, Num_Lab_Domes, Num_Storage_Domes,... 
%     Radius_Farm, Radius_Lab, Radius_Storage, Tube_Length, Tube_Radius, Barracks_Length, Barracks_Width, Barracks_Height] = cal_main(people,duration,lab_equip);