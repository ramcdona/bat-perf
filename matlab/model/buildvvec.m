function vvec = buildvvec( val )

vvec = zeros( 1, 2 * length(val) );
vvec( 1:2:end-1 ) = val;
vvec( 2:2:end ) = val;

end
