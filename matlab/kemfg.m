function [k_mfg] = kemfg( C, cell )
% Function to calculate manufacturer's rated discharge knockdown

run( cell )

Czero = 0;
dodi = 0.0;
dodf = 1.0;

[~, ~, ~, Emfg] = cellIntCdod( dodi, dodf, C, cell );
[~, ~, ~, Erev] = cellIntCdod( dodi, dodf, Czero, cell );

k_mfg = Emfg(end) / Erev(end);

