function [G, F] = myFourier( signal, Fs )

    L = length(signal);
    F = Fs*(0:L-1)/L;
    g = fft(signal);
    G = abs(g/L);
    
end