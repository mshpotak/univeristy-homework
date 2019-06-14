function m = normilizedModulation( t, s_bit) 
    initial_conditions;
    m = zeros( size(t) );
    for i = 1 : n_bit
        if byte(i) == 0
            m( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = -1;
        else
            m( (1 + ((i-1)*s_bit)) : (i*s_bit) ) = 1;
        end
    end
end