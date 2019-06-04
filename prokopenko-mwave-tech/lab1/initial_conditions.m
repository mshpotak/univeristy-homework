clear all; close all; clc;

%V#10
byte = [0 1 0 1 1 1 0 0]; % byte = 92;
byte_le = [0 0 1 1 1 0 1 0]; % little endian
n_bit = 8;
t_bit = 6e-6; % s (6 mcs)
w = 10e6; % Hz (10 MHz)
s_bit = 12; %samples per bit
Fs = s_bit/t_bit; %sample rate
Ma = 0.52;
Mf = 0.38;

