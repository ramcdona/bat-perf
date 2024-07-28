function [ dod ] = cellDODVP( V, P, cell )
% Function to determine battery dod where V, P coincide.
run( cell )

% This horribly ugly statement is an attempt to optimize this into a single
% line.  It is equivalent to
%
% OCV = OCVfun( x );
% Rss = Rssfun( x );
% i = ( OCV - sqrt( OCV.^2 - 4.0 * Rss .* P ) ) ./ ( 2.0 * Rss );
% i = real ( i );
% V1 = OCV - Rss .* i;
% dV = V1 - V;
%

dod = fzero( @(x) OCVfun( x ) ...
    - Rssfun( x ) .* real(( OCVfun( x ) - sqrt( OCVfun( x ).^2 - 4.0 * Rssfun( x ) .* P ) ) ./ ( 2.0 * Rssfun( x ) ))...
    - V...
    , [0 1]);

end
