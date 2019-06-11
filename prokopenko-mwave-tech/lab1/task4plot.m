close all; clear all; clc;
load('task4.mat');

figure(2)
plot( t, s1, t, s2 )

figure(3)
plot(F1n, fftshift(G1iq) )
xlim([-1e6,1e6])

plot(F,G);
xlabel('Frequency, Hz');
ylabel('Amplitude');
