close all; clear all; clc;
initial_conditions;

%task1.m
s_bit = 256 * 5;
[ t, Fs, T ] = signalTime( t_bit, n_bit, s_bit );

%normalized modulation
m = normilizedModulation( t, s_bit );
phi2 = normilizedPhaseModulation( m, "BPSK" );
phi4 = normilizedPhaseModulation( m, "QPSK" );

%amplitude modulation
s1 = signalAmpModulation(1, Ma, m, 0, w, t);

%frequency modulation
wm = 2 * pi / t_bit;
s2 = signalFreqModulation(1, Mf, m, 0, w, wm, t);

%phase modulation
ss4 = cos(w*t4 + M4);

[s3, m3, t3, phi3] = signalPhaseModulation( 1, byte_le, Fs, t_bit, "2", w);

[s4, m4, t4, phi4] = signalPhaseModulation( 1, byte_le, Fs, t_bit, "4", w);

[s5, m5, t5, phi5] = signalPhaseModulation( 1, byte_le, Fs, t_bit, "pi/4", w);

save('task1.mat')