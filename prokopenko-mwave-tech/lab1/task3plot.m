function task3plot( t, i , q, F, G, fname )

    h1 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.55 0.4] );
    N1 = 1; N2 = 3;
    subplot( N1, N2, 1 );
    plot( t, i , '-k.' ); 
    plotp( 't, ���', 'i(t)' ); 
    title( '��������� ������������' );
    subplot( N1, N2, 2 );
    plot( t, q, '-r.' ); 
    plotp( 't, ���', 'q(t)' );
    title( '������������ ������������' );
    subplot( N1, N2, 3 );
    plot( F, fftshift(G) , '-b.' ); 
    plotp( 'f, ��', '���������' ); 
    title( '������ ������������' );
    saveas( h1, fullfile( 'task3', ['3_', fname,'.png'] ) );

end