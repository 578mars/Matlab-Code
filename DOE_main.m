%Code to run Main as a function and plot the results to see if there's a
%trend...
clear all
DOE = dlmread('Habitat_DOE.txt');
people = DOE(:,1);
duration = DOE(:,2);
lab_equip = DOE(:,3);
for i = 1:length(people)
    Habitat_material(i) = Main(people(i),duration(i),lab_equip(i));
end

x = 1:1:i;
plot(x,Habitat_material);