function [G , PHASE, f] = readFourier(signal, N, Fs, t1, t2)
    L = length(signal);
    if (t1<0)|(t1>t2)|(t2>((L-1)/Fs))
        display('ERROR');
    end

    t = 0:1/Fs:(L-1)/Fs; 
    it1 = find(t>=t1,1);
    t1 = t(it1);
    it2 = find(t>=t2,1);
    t2 = t(it2);
    L = length(signal(N,it1:it2));
    
    x = signal(1,it1:it2);
    x_m = x - mean(x);
    g = fft(x_m)/L;
    G = g(1:L/2+1);
    
    f = Fs*(0:L/2)/L;
    PHASE = phase(G); 
    G = abs(G);
    G(2:end-1) = 2*G(2:end-1);
    
end