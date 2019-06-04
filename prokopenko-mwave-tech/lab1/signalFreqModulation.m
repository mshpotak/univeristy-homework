function s = signalFreqModulation( A0, M, m, phi, w, wm, t )
    s = A0 * cos(( w + wm .* (M/2) .* m) .* t + phi );
end