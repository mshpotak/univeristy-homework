function [s, A] = signalAmpModulation( A0, M, m, phi, w, t )
    A = A0 * ( 1 + (M/2) * m);
    s = A .* cos( w*t + phi );
end