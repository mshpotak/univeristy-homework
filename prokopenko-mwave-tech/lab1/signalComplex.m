function [i1, i2, i3, i4, q1, q2, q3 ,q4] = signalComplex( t, s1, s2, s3, th, s4 )
    initial_conditions;
    %ASK
    i1 = s1 .* cos( w * t );
    q1 = s1 .* sin( w * t );
    
    %FSK
    i2 = s2 .* cos( w * t );
    q2 = s2 .* sin( w * t );
    
    %BPSK
    i3 = s3 .* cos( w * t );
    q3 = s3 .* sin( w * t );
    
    %QPSK
    i4 = s4 .* cos( w * th );
    q4 = s4 .* sin( w * th );
end