function [ V, i, P, Crate, etai ] = cellStatePloss( dod, Ploss, cell )
% Function to determine battery state
% for specified cell power loss.

run( cell )

OCV = OCVfun( dod );
Rss = Rssfun( dod );

Ploss = Ploss * ones( size( dod ) );

% Ploss = i^2 * Rss;
i = sqrt( Ploss ./ Rss );

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
