function [tvec, dodvec, Evec, Vvec, ivec, Pvec, svec] = IntPowerTimeHist( Ps, ts, dodi, rev, cell )

if ( rev == -1 )
    ts = fliplr( ts );
    Ps = fliplr( Ps );
end

tvec=[];
dodvec=[];
Evec=[];
Vvec=[];
ivec=[];
Pvec=[];
svec=[];

t0 = 0;
E0 = 0;
for i=1:length(ts)
    if ( ts(i) > 0 )
        [~, t, dods, E, V, icurrent, P] = cellIntPt( ts(i), Ps(i), dodi, rev, cell );
        
        tvec = [tvec; t+t0];
        dodvec = [dodvec; dods];
        Evec = [Evec; E+E0];
        Vvec = [Vvec; V];
        ivec = [ivec; icurrent];
        Pvec = [Pvec; P];
        svec = [svec; i*ones(size(t))];
        
        dodi = dods(end);
        t0 = tvec(end);
        E0 = Evec(end);
    end
end

if ( rev == -1 )
    tvec = fliplr( tvec );
    dodvec = fliplr( dodvec );
    Evec = fliplr( Evec );
    Vvec = fliplr( Vvec );
    ivec = fliplr( ivec );
    Pvec = fliplr( Pvec );
    svec = fliplr( svec );

    tvec = tvec(1) - tvec;
end



end
