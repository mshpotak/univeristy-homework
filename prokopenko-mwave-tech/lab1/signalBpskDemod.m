function phi = signalBpskDemod( i, q )
    phi = abs(atan2( q, i ));
end