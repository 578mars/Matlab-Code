clc;
clear;
params
x = (0:0.5:200);
for i= 1:numel(x)
    y(i) = cal_water_recycle_weight(x(i), 50);
end
plot(x,y, '-');