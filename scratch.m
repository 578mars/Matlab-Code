clc;
clear;
params
x = (0:0.5:200);
for i= 1:numel(x)
    y(i) = cal_lab_size(x(i), 15);
end
plot(x,y, '*');