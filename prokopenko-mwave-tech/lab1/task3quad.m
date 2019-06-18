%task3quad.m
close all; clear all; clc;
load('task2.mat');

%Signals without Gauss
[ i1, i2, i3, i4, q1, q2, q3, q4] = signalComplex( t, s1, s2, s3, th, s4 );
%[ ~, G1, G2, G3, ~, G4] = signalSpectres( Fs, i1 + 1i*q1, i2 + 1i*q2, i3 + 1i*q3, i4 + 1i*q4);

n = 20;
Wn = 0.08;
[ fi1, fi2, fi3, fi4, fq1, fq2, fq3 ,fq4] = signalFilter( n, Wn, i1, i2, i3, i4, q1, q2, q3 ,q4 );
[ ~, fG1, fG2, fG3, ~, fG4] = signalSpectres( Fs, fi1 + 1i*fq1, fi2 + 1i*fq2, fi3 + 1i*fq3, fi4 + 1i*fq4);

%Signals with Gauss
[ gi1, gi2, gi3, gi4, gq1, gq2, gq3, gq4] = signalComplex( t, gs1, gs2, gs3, th, gs4 );
%[ ~, gG1, gG2, gG3, ~, gG4] = signalSpectres( Fs, gi1 + 1i*gq1, gi2 + 1i*gq2, gi3 + 1i*gq3, gi4 + 1i*gq4);

n = 20;
Wn = 0.07;
[ gfi1, gfi2, gfi3, gfi4, gfq1, gfq2, gfq3 ,gfq4] = signalFilter( n, Wn, gi1, gi2, gi3, gi4, gq1, gq2, gq3 ,gq4 );
[ ~, gfG1, gfG2, gfG3, ~, gfG4] = signalSpectres( Fs, gfi1 + 1i*gfq1, gfi2 + 1i*gfq2, gfi3 + 1i*gfq3, gfi4 + 1i*gfq4);

L = length(i1);
F123 = Fs*( -L/2 : 1 : (L/2 - 1) )/L;

L = length(i4);
F4 = Fs*( -L/2 : 1 : (L/2 - 1) )/L;

save('task3.mat');

mkdir('task3');
task3plot( t, fi1, fq1, F123, fG1, 'ask' );
task3plot( t, fi2, fq2, F123, fG2, 'fsk' );
task3plot( t, fi3, fq3, F123, fG3, 'bpsk' );
task3plot( th, fi4, fq4, F4, fG4, 'qpsk' );
task3plot( t, gfi1, gfq1, F123, gfG1, 'Gask' );
task3plot( t, gfi2, gfq2, F123, gfG2, 'Gfsk' );
task3plot( t, gfi3, gfq3, F123, gfG3, 'Gbpsk' );
task3plot( th, gfi4, gfq4, F4, gfG4, 'Gqpsk' );