function [ V, i, P, Crate, etai ] = cellStateV( dod, V, cell )
% Function to determine battery state
% for specified depth of discharge and specified voltage.

run( cell )

OCV = OCVfun( dod );
Rss = Rssfun( dod );

V = V * ones( size( dod ) );

i = ( OCV - V ) ./ Rss;
P = i .* V;
etai = V ./ OCV;

Crate = i ./ irated;
