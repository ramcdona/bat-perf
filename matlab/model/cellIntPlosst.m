function [deltat, t, dods, E, V, i, P, As, etai, Erevseg, k_frrseg] = cellIntPlosst( deltat, Ploss, dodi, rev, cell )

E0 = 0;
As0 = 0;
y0 = [dodi; E0; As0];
options = odeset(); % 'MaxStep',0.01);

[t, y] = ode45( @(t, y) cellStatePlossdt(t, y, Ploss, rev, cell), [0; deltat], y0, options);

dods = y(:,1);
E = y(:,2);
As = y(:,3);

[ V, i, P, ~, etai ] = cellStatePloss( dods, Ploss, cell );

if ( nargout > 9 )
    izero = 0;
    [~, ~, ~, Erev] = cellIntIdod( dods(1), dods(end), izero, cell );
    Erevseg = Erev(end);
    k_frrseg = E(end) / Erevseg;
end

end

function [ dxdt ] = cellStatePlossdt( t, x, Ploss, rev, cell )
% Function to predict cell discharge vs. dod for constant power
% Modeled as a state space diff. eq. 

dod  = x(1);   % DOD
En = x(2);   % Energy delivered
As = x(3);   % Capacity expended

run(cell)

[ V, i ] = cellStatePloss( dod, Ploss, cell );

ddoddt = rev * i / Qmax;
dEndt = V * i;
dAsdt = i;

dxdt = zeros(2,1);

dxdt(1) = ddoddt;
dxdt(2) = dEndt;
dxdt(3) = dAsdt;
end
