clear all; close all; clc;

%V#10
byte = [0 1 0 1 1 1 0 0]; % byte = 92;
byte_le = [0 0 1 1 1 0 1 0]; % little endian
n_bit = 8;
t_bit = 6; % s (6 mcs)
f = 10; % Hz (10 MHz)
w = 2 * pi * f;
Fs = 20*f; %sampling rate
s_bit = Fs * t_bit; %samples per bit
Ma = 0.52;
Mf = 0.38;
