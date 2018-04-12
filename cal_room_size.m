%function [ size ] = cal_room_size( num_people, stay_length )
%cal_room_size calculate the number of square meters that need to be
% dedicated to habitations for the people living on mars.
% Num_people = number of people in the settlement (linear scaler)
% Stay_length = duration of stay in days (0 - 1825 days)
% size = square meters of that need to be dedicated to habitations
DOE = dlmread('Habitat_DOE.txt');
num_people = DOE(:,1);
stay_length = DOE(:,2).*10;

params;
for i=1:length(num_people)
one_room_size = (del_size/pi)*atan((stay_length(i)-center_offset)...
    *15/tran_len) + del_size/2 + min_size;
size(i) = num_people(i) * one_room_size;
end

%end
plot(num_people,size,'o')
hold on
plot(stay_length,size,'o')