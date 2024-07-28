function [ V, i, P, Crate, etai ] = cellStateP( dod, P, cell )
% Function to determine battery state
% for specified depth of discharge and specified power draw.

run( cell )

OCV = OCVfun( dod );
Rss = Rssfun( dod );

P = P * ones( size( dod ) );

% Quadratic equation to solve for current to yield desired power.
i = ( OCV - sqrt( OCV.^2 - 4.0 * Rss .* P ) ) ./ ( 2.0 * Rss );

V = OCV - Rss .* i;
P = i .* V;
etai = V ./ OCV;

Crate = i ./ irated;

if ( ~isreal(i) )
    i = 0;
    V = 0;
    P = 0;
    etai = 0;
    Crate = 0;
end
