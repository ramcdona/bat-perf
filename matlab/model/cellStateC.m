function [ V, i, P, Crate, etai ] = cellStateC( dod, Crate, cell )
% Function to determine battery state
% for specified depth of discharge and specified current.

run( cell )

Crate = Crate * ones( size( dod ) );

i = Crate * irated;
OCV = OCVfun( dod );
V = OCV - Rssfun( dod ) .* i;
P = i .* V;
etai = V ./ OCV;
