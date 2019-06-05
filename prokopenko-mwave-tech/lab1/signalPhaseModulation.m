function [s, m, t, phi] = signalPhaseModulation( A0, data, Fs, t_data, encode, w)
    
    smp_rate = Fs * t_data;
    
    if encode == "2"
        T = t_data * length(data);
        t = 0 : 1/Fs : T - 1/Fs;
        m = zeros( size(t) );
        for i = 1 : length(data)
            if data(i) == 0
                m( (1 + ((i-1)*smp_rate)) : (i*smp_rate) ) = -1;
            else
                m( (1 + ((i-1)*smp_rate)) : (i*smp_rate) ) = 1;
            end
        end
        phi = pi * (1 - (m + 1)/2 );
        s = A0 * cos( w*t + phi );   
    else
        i1 = 1;
        i2 = 1;
        for i = 0 : length(data)-1
            if mod(i,2) == 0
                if data(i+1) == 0
                    di(i1) = -1;
                else
                    di(i1) = 1;
                end 
                i1 = i1 + 1;
            else
                if data(i+1) == 0
                    dq(i2) = -1;
                else
                    dq(i2) = 1;
                end
                i2 = i2 + 1;
            end
        end
        dI = [];
        dQ = [];
        for i = 1 : length(data)/2
            dI = [dI di(i)*ones( 1, smp_rate )];
            dQ = [dQ dq(i)*ones( 1, smp_rate )];
        end
        T = t_data * length(data)/2;
        t = 0 : 1/Fs : T - 1/Fs;
        
        if encode == "pi/4"
            phi_add = 0;
        else 
            phi_add = pi/4;
        end
        
        s = ( dI.*cos(w*t + pi/4 + phi_add) + dQ.*sin(w*t + pi/4 + phi_add) ) / sqrt(2);
        m = [dI; dQ];
        
        for i = 1 : length(m)
            if m(1,i) == 1
                if m(2,i) == 1
                    phi(i) = phi_add;
                else
                    phi(i) = 0.5 * pi + phi_add;
                end
            else
                if m(2,i) == 1
                    phi(i) = 1.5 * pi + phi_add;
                else
                    phi(i) = pi + phi_add;
                end
            end
        end
    end
    
end