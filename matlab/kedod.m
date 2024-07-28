function [k_dod] = kedod( dodi, dodf, cell )
% Function to calculate depth of discharge knockdown factor

run( cell )

izero = 0;

[~, ~, ~, Erev] = cellIntIdod( 0, 1, izero, cell );
[~, ~, ~, Edod] = cellIntIdod( dodi, dodf, izero, cell );

k_dod = Edod(end) / Erev(end);

