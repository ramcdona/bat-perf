function [deltat, t, dods, E, V, i, P, As, etai, Erevseg, k_frrseg] = cellIntPdod( dodi, dodf, P, cell )

E0 = 0;
t0 = 0;
As0 = 0;
y0 = [t0; E0; As0];
opt = odeset('Events', @(dod,y) evtP(dod, y, P, cell), 'MaxStep',0.01 ); % 'MaxStep',0.01);

[dods, y] = ode45( @(dod, y) cellStatePddod(dod, y, P, cell), [dodi; dodf], y0, opt);

t = y(:,1);
E = y(:,2);
As = y(:,3);

[ V, i, P, ~, etai ] = cellStateP( dods, P, cell );

deltat = t(end);

if ( nargout > 9 )
    izero = 0;
    [~, ~, ~, Erev] = cellIntIdod( dodi, dodf, izero, cell );
    Erevseg = Erev(end);
    k_frrseg = E(end) / Erevseg;
end

end

function [ dxddod ] = cellStatePddod( dod, x, P, cell )
% Function to predict cell discharge vs. dod for constant power
% Modeled as a state space diff. eq. 

t  = x(1);   % Time
En = x(2);   % Energy delivered
As = x(3);   % Capacity expended

run(cell)

[ V, i ] = cellStateP( dod, P, cell );

dtddod = Qmax / i;
dEnddod = V * Qmax;
dAsddod = Qmax;

dxddod = zeros(2,1);

dxddod(1) = dtddod;
dxddod(2) = dEnddod;
dxddod(3) = dAsddod;

end

function [value,isterminal,direction] = evtP( dod, x, P, cell )

[ Vevt, i ] = cellStateP( dod, P, cell );
run(cell)

value = [Vevt-Vcutoff i];
isterminal = [1 1];
direction = [0 0];

end
