function [m1, m2, m3, m4] = signalDemodulation( s_bit, dA, dw, dphi2, dphi4 )
    initial_conditions;

    %ASK
    A0 = 1;
    m1 = 2 * ((dA/A0) - 1) / Ma ;
    m1(m1 >= 0 ) = 1;
    m1(m1 < 0) = -1;

    %FSK
    wm = 2 * pi / t_bit;
    m2 = 2 * dw / (wm * Mf);
    m2(end+1) = m2(end);
    m2(m2 >= 0) = 1;
    m2(m2 < 0) = -1;

    %BPSK
    m3 = -(((dphi2/pi) - 1)*2 + 1);
    m3(m3 >= 0) = 1;
    m3(m3 < 0) = -1;

    %QPSK
    m4_even = zeros(size(dphi4));
    m4_odd = zeros(size(dphi4));
    for i = 1 : length(dphi4)
        if (( dphi4(i) >= 0 ) && ( dphi4(i) < pi/2 ))
            m4_even(i) = 1;
            m4_odd(i) = 1;
        elseif (( dphi4(i) >= pi/2 ) && ( dphi4(i) <= pi ))
            m4_even(i) = 0;
            m4_odd(i) = 1;
        elseif (( dphi4(i) < 0 ) && ( dphi4(i) >= -pi/2 ))
            m4_even(i) = 1;
            m4_odd(i) = 0;
        elseif (( dphi4(i) < -pi/2 ) && ( dphi4(i) >= -pi ))
            m4_even(i) = 0;
            m4_odd(i) = 0;
        end
    end

    m4byte = zeros( size(byte) );
    for i = 1 : n_bit/2
        if round( mean(m4_even( 1 + ( ( i - 1 )*s_bit ) : i*s_bit)) ) == 1
            m4byte( i + (i-1) ) = 1;
        else
            m4byte( i + (i-1) ) = 0;
        end
        if round( mean(m4_odd( 1 + ( ( i - 1 )*s_bit ) : i*s_bit)) ) == 1
            m4byte(i+1 + (i-1) ) = 1;
        else
            m4byte(i+1 + (i-1) ) = 0;
        end
    end

    m4 = zeros( 1, length(dphi4)*2);
    for i = 1 : n_bit
        if m4byte(i) == 0
            m4( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = -1;
        else
            m4( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = 1;
        end
end