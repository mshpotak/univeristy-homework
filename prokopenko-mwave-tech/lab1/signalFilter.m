function [fi1, fi2, fi3, fi4, fq1, fq2, fq3 ,fq4] = signalFilter( n, Wn, i1, i2, i3, i4, q1, q2, q3 ,q4 )
    b1 = fir1( n, Wn );
    fi1 = 2 * filter( b1, 1, i1);
    fq1 = -2 * filter( b1, 1, q1);
    
    fi2 = 2 * filter( b1, 1, i2);
    fq2 = -2 * filter( b1, 1, q2);
    
    fi3 = 2 * filter( b1, 1, i3);
    fq3 = -2 * filter( b1, 1, q3);
    
    fi4 = 2 * filter( b1, 1, i4);
    fq4 = -2 * filter( b1, 1, q4);
end