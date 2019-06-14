function [ t, Fs, T ] = signalTime( s_bit )
    initial_conditions;         
    % s_ bit                    % samples per bit
    Fs = s_bit/t_bit;           % sampling frequency
    T = t_bit * n_bit;          % total signal duration
    t = 0 : 1/Fs : T - 1/Fs;    % time series
end