close all; clear all; clc;
load('task4.mat');

figure(1)
plot(F1, G1) 

figure(2)
plot(F1n, fftshift(G1iq) )
xlim([-1e6,1e6])