function task2plot1( t, s1, s2, s3, th, s4, name )

h1 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.5 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( t, s1 , '-k.' ); 
plotp( 't, сек', 's1(t)' ); 
title( 'ASK' );
subplot( N1, N2, 2 );
plot( t, s2, '-r.' ); 
plotp( 't, сек', 's2(t)' );
title( 'FSK' );
subplot( N1, N2, 3 );
plot( t, s3 , '-m.' ); 
plotp( 't, сек', 's3(t)' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( th, s4, '-b.' ); 
plotp( 't, сек', 's4(t)' );
title( 'QPSK' );
saveas( h1, fullfile( 'task2', ['2_', name, '.png'] ) );

end