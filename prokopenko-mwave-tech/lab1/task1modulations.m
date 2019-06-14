close all; clear all; clc;
initial_conditions;

%task1.m
s_bit = 32;
[ t, Fs, T ] = signalTime( s_bit );

%normalized modulation
m = normilizedModulation( t, s_bit );
phi2 = normilizedPhaseModulation( m, s_bit, "BPSK" );
phi4 = normilizedPhaseModulation( m, s_bit, "QPSK" );
th = t(1 : length( phi4 ));

bg = gaussfir( 0.2, 2, 5 );
gauss_m = filter( bg, 1 , m );
gauss_phi2 = filter( bg, 1 , phi2 );
gauss_phi4 = filter( bg, 1 , phi4 );

save('task1.mat');

%figures
mkdir('task1');

h1 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.5 0.4] );
N1 = 1; N2 = 3;
subplot( N1, N2, 1 );
plot( t, m , '-k.' ); 
plotp( 't, сек', 'm(t)' ); 
title( 'ASK/FSK' );
subplot( N1, N2, 2 );
plot( t, phi2 * 180/pi, '-r.' ); 
plotp( 't, сек', 'phi(t)' );
title( 'BPSK' );
subplot( N1, N2, 3 );
plot( th, phi4 * 180/pi, '-b.' ); 
plotp( 't, сек', 'phi(t)' );
title( 'QPSK' );
saveas( h1, fullfile( 'task1', ['1_mods','.png'] ) );

h2 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.5 0.4] );
N2 = 1; N2 = 3;
subplot( N1, N2, 1 );
plot( t, gauss_m, '-k.' ); plotp( 't, сек', 'filtered m(t)' );
title( 'ASK/FSK' );
subplot( N1, N2, 2 );
plot( t, gauss_phi2 * 180/pi, '-r.' ); 
plotp( 't, сек', 'filtered phi(t)' );
title( 'BPSK' );
subplot( N1, N2, 3 );
plot( th, gauss_phi4 * 180/pi, '-b.' ); 
plotp( 't, сек', ' filtered phi(t)' );
title( 'QPSK' );
saveas( h2, fullfile( 'task1', ['1_gmods','.png'] ) );