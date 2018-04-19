function [ size ] = cal_lab_size( num_people, num_equip )
%cal_room_size calculate the number of square meters that need to be
% dedicated to habitations for the people living on mars.
% Num_people = number of people in the settlement (linear scaler)
% num_equip = pieces of equipment that are expected to be in operation on any
%             given day. (1-100)
% size = square meters of space that need to be dedicated to lab space
params;
% equip_sizes = randn([1,num_equip]) * equip_size_range + avg_equip_size;
% min_lab_size = sum(equip_sizes);
% people_space = num_people * lab_space_per_person;
% size = max([min_lab_size, people_space]);
% if size < 20
%     size = 20;
% end
% size = min([size, max_lab_space]);
equip_volume = num_equip * avg_equip_size;
size = equip_volume * sqrt(num_people);

end
