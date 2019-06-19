close all; clear all; clc;
initial_conditions;

%2 ��������� � ������
Xlim = [ -0.01*(w+2*w+s) 1.01*(w+2*w+s) ];
Ylim = [ -0.1*(h1+h2+t) 1.1*(h1+h2+t) ];
fig1 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
pdegplot('geometry');
[ P, E, T ] = initmesh('geometry');
Q = pdetriq( P, T );
disp([ '����������� ���������� ������������ = [', num2str(min(Q)), ']'] );
pdemesh( P, E, T ); 

xlim( Xlim ); ylim( Ylim );
xlabel('��'); ylabel('��');
title('��������� � ������');

mkdir('task1');
saveas( fig1, fullfile( 'task1', 'initgeom.png' ) );

%3 �������������� �����������
fig2 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
B = 0; F = 0;
A = ones( 1, length(T) );
zone30 = find( T(4,:) == 30 );
A(zone30) = eps1;
zone40 = find( T(4,:) == 40 ); 
A(zone40) = eps2;
zone20 = find( T(4,:) == 20 );

psi = assempde( 'bound', P, E, T, A, B, F );
pdesurf( P, T, psi )
%daspect([1 1 0.004])
%xlim( Xlim ); ylim( Ylim );
xlabel('��'); ylabel('��');
title('������������� �����������');
zlabel('PSI'); 
grid on;
[ dpsi_dx, dpsi_dy ] = pdegrad( P, T, psi );

mkdir('task2');
saveas( fig2, fullfile( 'task2', 'psi.png' ) );

%4 ������ ������������ ����������������� ���� ���-����
Ex_tr = -dpsi_dx;
Ey_tr = -dpsi_dy;
Hx_tr = (sqrt(A)).*dpsi_dy./Z0;
Hy_tr = (-1).*((sqrt(A)).*dpsi_dx./Z0);

% �������� �������� �� ������� ����������� ��������� � ���� 
Ex_tr = pdeprtni( P, T, Ex_tr );
Ey_tr = pdeprtni( P, T, Ey_tr );
Hx_tr = pdeprtni( P, T, Hx_tr );
Hy_tr = pdeprtni( P, T, Hy_tr );
 
% ���������� �����
b1 = w+2*w+s;
b2 = h1+h2+t;
n = 100;
x = linspace(0,b1,n);
y = linspace(0,b2,n);
 
% �������� ����������� ����� � ��������������
Ex_qu = tri2grid( P, T, Ex_tr, x, y);
Ey_qu = tri2grid( P, T, Ey_tr, x, y);
Hx_qu = tri2grid( P, T, Hx_tr, x, y);
Hy_qu = tri2grid( P, T, Hy_tr, x, y);
 
% ���������� ������� ����� �������������� ����
fig3 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
hplot1 = pdegplot('geometry');
set( hplot1, 'color', 'k', 'linestyle', '--');
streamslice( x, y, Ex_qu, Ey_qu, 3), axis equal, axis tight;
xlabel('��'); ylabel('��');
title('������� ����� �������������� ���� E');

mkdir('task3');
saveas( fig3, fullfile( 'task3', 'elines.png' ) );

%5 ���������� ������� ����� ���������� ����
fig4 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
hplot2 = pdegplot('geometry');
set( hplot2, 'color', 'k', 'linestyle', '--' );
streamslice( x, y, Hx_qu, Hy_qu, 3), axis equal, axis tight;
xlabel('��'); ylabel('��');
title('������� ����� ���������� ���� H')
saveas( fig4, fullfile( 'task3', 'hlines.png' ) );
 
% ������ ����������� ��������������� �������������
[ AR, A1, A2, A3 ] = pdetrg( P, T );
psi1 = assempde( 'bound', P, E, T, 1, B, F );
[ dpsi_dx1, dpsi_dy1 ] = pdegrad( P, T, psi1 );
D = sum( ( dpsi_dx1.*dpsi_dx1 + dpsi_dy1.*dpsi_dy1 ).*AR );
psi = assempde( 'bound', P, E, T, A, B, F );
[ dpsi_dx, dpsi_dy ] = pdegrad( P, T, psi);
N = sum( A.*( dpsi_dx.*dpsi_dx + dpsi_dy.*dpsi_dy ).*AR );
 
% ĳ���������� ����������
Eef = N/D;
disp(['���������� ��������������� ������������� = [', num2str(Eef),']']);
% ������ ��������. ���������
D_z = sum( (sqrt(A)).*( dpsi_dx.*dpsi_dx + dpsi_dy.*dpsi_dy ).*AR );
Z = Z0*(phi1-phi2)*(phi1-phi2)/D_z;
disp(['������������������ ������������� = [', num2str(Z), ']']);