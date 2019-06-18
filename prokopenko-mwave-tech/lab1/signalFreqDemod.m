function dw = signalFreqDemod( i, q, Fs )
    L = length(i) - 1;
    dw = zeros( 1, L );
    for k = 1 : L
        dw(k) = Fs * ( i(k)*q(k+1) - i(k+1)*q(k) ) / sqrt( (i(k)^2 + q(k)^2)*(i(k+1)^2 + q(k+1)^2) );
    end
end