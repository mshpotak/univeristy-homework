
function [x,y]=geomenry_w(bs,s)

    load -ascii i.txt i

    %перша лінія
    X_coord(1,:)=[100-i 100-i];
    Y_coord(1,:)=[200 220];
    X_coord(2,:)=[100-i 400];
    Y_coord(2,:)=[220 220];
    X_coord(3,:)=[400 400];
    Y_coord(3,:)=[220 200];
    X_coord(4,:)=[400 100-i];
    Y_coord(4,:)=[200 200];

    %друга лінія
    X_coord(5,:)=[450 450];
    Y_coord(5,:)=[200 220];
    X_coord(6,:)=[450 750+i];
    Y_coord(6,:)=[220 220];
    X_coord(7,:)=[750+i 750+i];
    Y_coord(7,:)=[220 200];
    X_coord(8,:)=[750+i 450];
    Y_coord(8,:)=[200 200];

    X_coord(9,:)=[000 000];
    Y_coord(9,:)=[000 100];
    X_coord(10,:)=[000 000];
    Y_coord(10,:)=[100 200];
    X_coord(11,:)=[000 000];
    Y_coord(11,:)=[200 300];
    X_coord(12,:)=[000 850];
    Y_coord(12,:)=[300 300];
    X_coord(13,:)=[850 850];
    Y_coord(13,:)=[300 200];
    X_coord(14,:)=[850 850];
    Y_coord(14,:)=[200 100];
    X_coord(15,:)=[850 850];
    Y_coord(15,:)=[100 000];
    X_coord(16,:)=[850 0000];
    Y_coord(16,:)=[000 000];
    X_coord(17,:)=[000 850];
    Y_coord(17,:)=[100 100];
    X_coord(18,:)=[000 100-i];
    Y_coord(18,:)=[200 200];
    X_coord(19,:)=[400 450];
    Y_coord(19,:)=[200 200];
    X_coord(20,:)=[750+i 850];
    Y_coord(20,:)=[200 200];


    nbs=length(X_coord(:,1)); % quantity of segments
    d=zeros(4,nbs);
    d(2,:)=1;

    d(3,1:3)=50;
    d(4,1:3)=00;

    d(3,5:7)=50;
    d(4,5:7)=00;

    d(3,[4 8 ])=20;
    d(4,[4 8 ])=00;

    d(3,18:20)=50;
    d(4,18:20)=20;

    d(3,11:13)=00;
    d(4,11:13)=50;

    d(3,[9 15 16])=00;
    d(4,[9 15 16])=40;

    d(3,17)=20;
    d(4,17)=40;

    d(3,[10 14])=00;
    d(4,[10 14])=20;

    if nargin==0,
    x=nbs; % number of boundary segments
    return
    end
    bs1=bs(:)';
    if find(bs1<1 | bs1>nbs),
    error('Non existent boundary segment number')
    end
    if nargin==1,
    x=d(:,bs1);
    return
    end
    x=zeros(size(s));
    y=zeros(size(s));
    [m,n]=size(bs);
    if m==1 & n==1,
    bs=bs*ones(size(s)); % expand bs
    elseif m~=size(s,1) | n~=size(s,2),
    error('bs shall be a scalar or of same size as s');
    end
    if ~isempty(s),
        for ll=1:nbs
        ii=find(bs==ll);

            if length(ii)
            x(ii)=interp1( d(1:2,ll), X_coord(ll,:), s(ii));
            y(ii)=interp1( d(1:2,ll), Y_coord(ll,:), s(ii));
            end
        end
    end
end