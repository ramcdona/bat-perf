function [ V, i, P, Crate, etai ] = cellStateR( dod, R, cell )
% Function to determine battery state
% for specified depth of discharge and specified load resistance.

run( cell )

OCV = OCVfun( dod );
Rss = Rssfun( dod );

% Solve for current through series resistor
i = OCV ./ ( Rss + R );

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
