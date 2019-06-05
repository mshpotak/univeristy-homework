function [s , phi, m_new] = signalPhaseModulationAlt( A0, m, mshift, w, t )
    if mshift == 2
        phi = pi * (1 - (m + 1)/2 );
    elseif mshift == 4
        byte_le = [0 0 1 1 1 0 1 0]; % little endian
        n_bit = 8;
        t_bit = 6e-6; % s (6 mcs)
        s_bit = 12; %samples per bit
        Fs = s_bit/t_bit; %sample rate
        clear m;
        pulse_rate = t_bit * Fs;
        for i = 1 : n_bit/2
            j = i + (i-1);
            if byte_le(j) == 0
                if byte_le(j+1) == 0
                    m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = "00";
                else
                    m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = "01";
                end
            else
                if byte_le(j+1) == 0
                    m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = "10";
                else
                    m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = "11";
                end
            end
         end
         n_normal = [1, 2, 3, 4];
         n_gray = [1, 2, 4, 3];
         n = n_gray;
         for i = 1 : length(m)
            if     m(i) == "00"
                phi(i) = (pi/4) * (2*n(3) - 1);
            elseif m(i) == "01"
                phi(i) = (pi/4) * (2*n(2) - 1);
            elseif m(i) == "10" 
                phi(i) = (pi/4) * (2*n(4) - 1);
            elseif m(i) == "11"
                phi(i) = (pi/4) * (2*n(1) - 1);
            end
         end
         m_new = m;
    end
    s = A0 * cos( w*t(1:length(phi)) + phi );
end