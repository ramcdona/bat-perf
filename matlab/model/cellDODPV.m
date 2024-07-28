function [ dod ] = cellDODPV( V, P, cell )
% Function to determine battery dod where V, P coincide.
run( cell )

% This horribly ugly statement is an attempt to optimize this into a single
% line.  It is equivalent to
%
% OCV = OCVfun( x );
% Rss = Rssfun( x );
% i = ( OCV - V ) ./ Rss;
% P1 = i .* V;
% dP = P1 - P;

dod = fzero( @(x) (( OCVfun( x ) - V ) ./ Rssfun( x ) ) .* V - P, [0 1] );

end
