function analysis(signal, N, Fs)
    L = length(signal(N,:));
    t = 0:1/Fs:(L-1)/Fs;
    x = signal(1,:);
    x1 = x(1:end-1);
    x2 = x(2:end);
    
    S1 = 2;
    S2 = 2;
    figure();
    subplot(S1,S2,1);
    plot(x1,x2,'k.');
    xlabel('f(X)');
    ylabel('f(X+1)');
    
    subplot(S1,S2,2);
    plot(x1,x2./x1,'k.');
    xlabel('f(X)');
    ylabel('f(X+1)/f(X)');

    subplot(S1,S2,3);
    plot(x1,x2-x1,'k.');
    xlabel('f(X)');
    ylabel('f(X+1)-f(X)');
    
    subplot(S1,S2,4);
    plot(x,abs(x),'k.');
    xlabel('f(X)');
    ylabel('abs(f(X))');
    
%     figure()
%     m = std(x);
%     edges = [-1+min(x),-1*abs(m),abs(m),1+max(x)];
%     h = histogram(x,edges);
    
    figure()
    dx = (x2-x1)./t(2:end);
    plot(t(2:end),dx);
    xlabel('X');
    ylabel('d(f(X))');
    
    figure()
    x_m = x - mean(x);
    f = Fs*(0:L/2)/L;
    g = fft(x_m);
    G = abs(g/L);
    G = G(1:L/2+1);
    G(2:end-1) = 2*G(2:end-1);
    plot(f,G);
    xlabel('Frequency, Hz');
    ylabel('Amplitude');
end