function [deltat, t, dods, E, V, i, P, As, etai, Erevseg, k_frrseg] = cellIntVdod( dodi, dodf, Vset, cell )

E0 = 0;
t0 = 0;
As0 = 0;
y0 = [t0; E0; As0];
opt = odeset('Events', @(dod,y) evtV(dod, y, Vset, cell), 'MaxStep',0.01 ); % 'MaxStep',0.01);

[dods, y] = ode45( @(dod, y) cellStateVddod(dod, y, Vset, cell), [dodi; dodf], y0, opt);

t = y(:,1);
E = y(:,2);
As = y(:,3);

[ V, i, P, ~, etai ] = cellStateV( dods, Vset, cell );

deltat = t(end);

if ( nargout > 9 )
    izero = 0;
    [~, ~, ~, Erev] = cellIntIdod( dodi, dodf, izero, cell );
    Erevseg = Erev(end);
    k_frrseg = E(end) / Erevseg;
end

end

function [ dxddod ] = cellStateVddod( dod, x, V, cell )
% Function to predict cell discharge vs. dod for target voltage
% Modeled as a state space diff. eq. 

t  = x(1);   % Time
En = x(2);   % Energy delivered
As = x(3);   % Capacity expended

run(cell)

[ V, i ] = cellStateV( dod, V, cell );

dtddod = Qmax / i;
dEnddod = V * Qmax;
dAsddod = Qmax;

dxddod = zeros(2,1);

dxddod(1) = dtddod;
dxddod(2) = dEnddod;
dxddod(3) = dAsddod;

end

function [value,isterminal,direction] = evtV( dod, x, V, cell )

[ ~, i ] = cellStateV( dod, V, cell );
run(cell)

value = i;
isterminal = [1];
direction = [-1];

end
