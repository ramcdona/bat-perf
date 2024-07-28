function [deltat, t, dods, E, V, i, P, As, etai, Erevseg, k_frrseg] = cellIntPlossdod( dodi, dodf, Ploss, cell )

E0 = 0;
t0 = 0;
As0 = 0;
y0 = [t0; E0; As0];
opt = odeset('Events', @(dod,y) evtPloss(dod, y, Ploss, cell), 'MaxStep',0.01 ); % 'MaxStep',0.01);

[dods, y] = ode45( @(dod, y) cellStatePlossddod(dod, y, Ploss, cell), [dodi; dodf], y0, opt);

t = y(:,1);
E = y(:,2);
As = y(:,3);

[ V, i, P, ~, etai ] = cellStatePloss( dods, Ploss, cell );

deltat = t(end);

if ( nargout > 9 )
    izero = 0;
    [~, ~, ~, Erev] = cellIntIdod( dodi, dodf, izero, cell );
    Erevseg = Erev(end);
    k_frrseg = E(end) / Erevseg;
end

end

function [ dxddod ] = cellStatePlossddod( dod, x, Ploss, cell )
% Function to predict cell discharge vs. dod for constant power
% Modeled as a state space diff. eq. 

t  = x(1);   % Time
En = x(2);   % Energy delivered
As = x(3);   % Capacity expended

run(cell)

[ V, i ] = cellStatePloss( dod, Ploss, cell );

dtddod = Qmax / i;
dEnddod = V * Qmax;
dAsddod = Qmax;

dxddod = zeros(2,1);

dxddod(1) = dtddod;
dxddod(2) = dEnddod;
dxddod(3) = dAsddod;

end

function [value,isterminal,direction] = evtPloss( dod, x, Ploss, cell )

[ Vevt, i ] = cellStatePloss( dod, Ploss, cell );
run(cell)

value = [Vevt-Vcutoff i];
isterminal = [1 1];
direction = [0 0];

end
