function [deltat, t, dods, E, V, i, P, As, etai, Erevseg, k_frrseg] = cellIntIdod( dodi, dodf, i, cell )

E0 = 0;
t0 = 0;
As0 = 0;
y0 = [t0; E0; As0];
opt = odeset('Events', @(dod,y) evtI(dod, y, i, cell), 'MaxStep',0.01 ); % 'MaxStep',0.01);

[dods, y, te, ye, ie] = ode45( @(dod, y) cellStateIddod(dod, y, i, cell), [dodi; dodf], y0, opt);

t = y(:,1);
E = y(:,2);
As = y(:,3);

[ V, i, P, ~, etai ] = cellStateI( dods, i, cell );

deltat = t(end);

if ( nargout > 9 )
    izero = 0;
    [~, ~, ~, Erev] = cellIntIdod( dodi, dodf, izero, cell );
    Erevseg = Erev(end);
    k_frrseg = E(end) / Erevseg;
end

end

function [ dxddod ] = cellStateIddod( dod, x, i, cell )
% Function to predict cell discharge/charge vs. dod for constant current
% Modeled as a state space diff. eq. 

t  = x(1);   % Time
En = x(2);   % Energy delivered
As = x(3);   % Capacity expended

run(cell)

[ V, ~ ] = cellStateI( dod, i, cell );

dtddod = Qmax / i;
dEnddod = V * Qmax;
dAsddod = Qmax;

dxddod = zeros(2,1);

dxddod(1) = dtddod;
dxddod(2) = dEnddod;
dxddod(3) = dAsddod;

end

function [value,isterminal,direction] = evtI( dod, x, i, cell )

[ V, ~ ] = cellStateI( dod, i, cell );
run(cell)

value = V - Vcutoff;
isterminal = 1;
direction = 0;

end
