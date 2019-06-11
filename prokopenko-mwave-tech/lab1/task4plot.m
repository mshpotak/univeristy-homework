close all; clear all; clc;
load('task4.mat');

<<<<<<< HEAD
figure(1)
plot(F1, G1) 

figure(2)
plot(F1n, fftshift(G1iq) )
xlim([-1e6,1e6])
=======
plot(F,G);
xlabel('Frequency, Hz');
ylabel('Amplitude');
>>>>>>> 52ec42b65459b3c6f763ce9064565184e26ae70e
