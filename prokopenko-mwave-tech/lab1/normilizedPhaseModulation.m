function phi = normilizedPhaseModulation( m, s_bit, type )
    initial_conditions;
    if type == "QPSK"
        b1 = byte(  mod( 1 : length(byte), 2) == 1  );
        b2 = byte(  mod( 1 : length(byte), 2) == 0  );
        phi = zeros( 1, length(m)/2 );
        for i = 1 : n_bit/2
            if b1(i) == 1
                if b2(i) == 1
                    phi( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = 0.25 * pi;
                else
                    phi( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = 1.75 * pi;
                end
            else
                if b2(i) == 1
                    phi( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = 0.75 * pi;
                else
                    phi( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = 1.25 * pi;
                end
            end
        end
    elseif type == "BPSK"
        phi = pi * ( 1 - (m + 1)/2 );
    end
end