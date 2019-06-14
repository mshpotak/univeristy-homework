function y = filterGauss( signal , sigma, size )
    x = linspace(-size / 2, size / 2, size);
    gaussFilter = exp(-x .^ 2 / ( 2 * sigma ^ 2 ) );
    gaussFilter = gaussFilter / sum (gaussFilter); % normalize 
    y = filter ( gaussFilter, 1 , signal );
end