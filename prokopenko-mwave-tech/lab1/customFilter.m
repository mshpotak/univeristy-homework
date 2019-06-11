function [y, f] = customFilter( x, N, Wn )
    f = fir1( N, Wn );
    y = filtfilt( f, 1 , x );
end