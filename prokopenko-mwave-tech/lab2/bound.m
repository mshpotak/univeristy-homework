function [q,g,h,r]=bound(p,e,u,t)
    N=1; % only one equation

    ne=size(e,2);
    q=zeros(N*N,ne);
    g=zeros(N,ne);
    h=zeros(N*N,2*ne);
    r=zeros(N,2*ne);

    % boundary conditions at the edge 1-4
    for i=1:4
    esegm=find(e(5,:)==i);
    h(esegm)=1;
    h(esegm+ne)=1;
    r(esegm)=0.0;
    r(esegm+ne)=0.0;
    end
    % boundary conditions at the edge 5-8
    for i=5:8
    esegm=find(e(5,:)==i);
    h(esegm)=1;
    h(esegm+ne)=1;
    r(esegm)=2;
    r(esegm+ne)=2;
    end
end 
 
