function [ V, i, P, Crate, etai ] = cellStateI( dod, i, cell )
% Function to determine battery state
% for specified depth of discharge and specified current.

run( cell )


i = i * ones( size( dod ) );

Crate = i ./ irated;
OCV = OCVfun( dod );
V = OCV - Rssfun( dod ) .* i;
P = i .* V;
etai = V ./ OCV;
