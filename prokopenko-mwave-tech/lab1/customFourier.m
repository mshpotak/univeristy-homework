function [ G, F, Fn ] = customFourier( signal, Fs )
    L = length(signal);
    F = Fs*(0:L-1)/L;
    Fn = Fs*( -L/2 : 1 : (L/2 - 1) )/L;
    g = fft(signal);
    G = abs(g/L);
end