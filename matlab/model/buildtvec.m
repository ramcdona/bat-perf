function tvec = buildtvec( deltat )

tsum = cumsum( deltat );

tvec = zeros( 1, 2 * length(deltat) );
tvec( 3:2:end-1 ) = tsum( 1:end-1 );
tvec( 2:2:end ) = tsum;

end
