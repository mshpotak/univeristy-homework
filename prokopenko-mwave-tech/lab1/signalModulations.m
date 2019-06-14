function [s1, s2, s3, s4] = signalModulations( t, m, phi2, th, phi4 )
    initial_conditions;
    
    %ASK
    A0 = 1;
    aphi = 0;
    A = A0 * ( 1 + (Ma/2) * m);
    s1 = A .* cos( w*t + aphi );
    
    %FSK
    fphi = 0;
    wm = 2 * pi / t_bit;
    s2 = A0 * cos(( w + wm .* (Mf/2) .* m) .* t + fphi );
    
    %BPSK
    s3 = A0 * cos( w*t + phi2 ); 
    
    %QPSK
    s4 = A0 * cos( w*th + phi4 ); 
    
end