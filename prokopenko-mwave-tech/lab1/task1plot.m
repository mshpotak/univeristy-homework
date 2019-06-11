close all; clear all; clc;
load('task1.mat');

figure(1);
plot(t,m,'.r-');
grid on;

figure(2);
plot(t3,phi3*180/pi,'.r-');
grid on;

figure(3);
plot(t4,phi4*180/pi,'.r-.',t5,phi5*180/pi,'.b-.');
grid on;