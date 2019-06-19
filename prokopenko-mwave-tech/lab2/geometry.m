function [x,y] = geometry( bs, S )
    initial_conditions;
    
    X_coord(1,:) = [ 0, w/2 ];
    Y_coord(1,:) = [ h1+h2, h1+h2 ];
    
    X_coord(2,:) = [ w/2, w/2 ];
    Y_coord(2,:) = [ h1+h2, h1+h2+t ];
    
    X_coord(3,:) = [ w/2, w+w/2 ];
    Y_coord(3,:) = [ h1+h2+t, h1+h2+t ];
    
    X_coord(4,:) = [ w+w/2, w+w/2 ];
    Y_coord(4,:) = [ h1+h2+t, h1+h2 ];
    
    X_coord(5,:) = [ w/2, w+w/2 ];
    Y_coord(5,:) = [ h1+h2, h1+h2 ];
    
    X_coord(6,:) = [ w+w/2, s+w+w/2 ];
    Y_coord(6,:) = [ h1+h2, h1+h2 ];
    
    X_coord(7,:) = [ s+w+w/2, s+w+w/2 ];
    Y_coord(7,:) = [ h1+h2, h1+h2+t ];
    
    X_coord(8,:) = [ s+w+w/2, s+2*w+w/2 ];
    Y_coord(8,:) = [ h1+h2+t, h1+h2+t ];

    X_coord(9,:) = [ s+2*w+w/2, s+2*w+w/2 ];
    Y_coord(9,:) = [ h1+h2+t, h1+h2 ];
    
    X_coord(10,:) = [ s+w+w/2, s+2*w+w/2 ];
    Y_coord(10,:) = [ h1+h2, h1+h2 ];
    
    X_coord(11,:) = [ s+2*w+w/2, s+2*w+w ];
    Y_coord(11,:) = [ h1+h2, h1+h2 ];
    
    X_coord(12,:) = [ s+2*w+w, s+2*w+w ];
    Y_coord(12,:) = [ h1+h2, h2 ];
    
    X_coord(13,:) = [ s+2*w+w, s+2*w+w ];
    Y_coord(13,:) = [ h2, 0 ];
    
    X_coord(14,:) = [ s+2*w+w, 0 ];
    Y_coord(14,:) = [ 0, 0 ];
    
    X_coord(15,:) = [ 0, 0 ];
    Y_coord(15,:) = [ 0, h2 ];
    
    X_coord(16,:) = [ 0, s+2*w+w ];
    Y_coord(16,:) = [ h2, h2 ];
    
    X_coord(17,:) = [ 0, 0 ];
    Y_coord(17,:) = [ h2, h1+h2 ];


    nbs = length( X_coord(:,1) ); % quantity of segments
    d = zeros( 4, nbs );
    d( 2, : ) = 1;
    
    d( 3, 1 ) = 0; 
    d( 4, 1 ) = 30;
    
    d( 3, 2 ) = 0; 
    d( 4, 2 ) = 20;

    d( 3, 3 ) = 0;
    d( 4, 3 ) = 20;
    
    d( 3, 4 ) = 0;
    d( 4, 4 ) = 20;
    
    d( 3, 5 ) = 20;
    d( 4, 5 ) = 30;
    
    d( 3, 6 ) = 0;
    d( 4, 6 ) = 30;
    
    d( 3, 7 ) = 0;
    d( 4, 7 ) = 20;
    
    d( 3, 8 ) = 0;
    d( 4, 8 ) = 20;
    
    d( 3, 9 ) = 0;
    d( 4, 9 ) = 20;
    
    d( 3, 10 ) = 20;
    d( 4, 10 ) = 30;

    d( 3, 11 ) = 0;
    d( 4, 11 ) = 30;
    
    d( 3, 12 ) = 0;
    d( 4, 12 ) = 30;
    
    d( 3, 13 ) = 0;
    d( 4, 13 ) = 40;
    
    d( 3, 14 ) = 0;
    d( 4, 14 ) = 40;
    
    d( 3, 15 ) = 0;
    d( 4, 15 ) = 40;
    
    d( 3, 16 ) = 30;
    d( 4, 16 ) = 40;
    
    d( 3, 17 ) = 0;
    d( 4, 17 ) = 30;

    if nargin == 0
        x = nbs; % number of boundary segments
        return
    end
    
    bs1 = bs(:)';
    if find( bs1<1 | bs1>nbs )
        error('Non existent boundary segment number')
    end
    
    if nargin == 1
        x = d( :, bs1 );
        return
    end
    
    x = zeros( size(S) );
    y = zeros( size(S) );
    [m,n] = size( bs );
    
    if m == 1 && n == 1
        bs = bs*ones(size(S)); % expand bs
    elseif m ~= size(S,1) || n ~= size(S,2)
        error('bs shall be a scalar or of same size as s');
    end
    
    if ~isempty(S)
        for ll = 1:nbs
            ii = find( bs == ll );
            if length(ii)
                 x(ii) = interp1( d(1:2,ll), X_coord(ll,:), S(ii) );
                 y(ii) = interp1( d(1:2,ll), Y_coord(ll,:), S(ii) );
            end
        end
    end
end