function [s , phi] = signalPhaseModulation( A0, m, mshift, w, t )
    if mshift == 2
        m = (m + 1)/2;
        phi = pi * (1 - m);
    elseif mshift == 4
        m = (m + 1)/2;
        n = [1, 2, 3, 4];
        for i = 1 : length(m)-1
            if m(i) == 0
                if m(i+1) == 0 
                    phi(i) = (pi/4) * (2*n(3) - 1);
                else
                    phi(i) = (pi/4) * (2*n(2) - 1);
                end
            else
                if m(i+1) == 0 
                    phi(i) = (pi/4) * (2*n(4) - 1);
                else
                    phi(i) = (pi/4) * (2*n(1) - 1);
                end
            end
        end
      phi = [ phi phi(end) ];
    end
    s = A0 * cos( w*t + phi );
end