function [deltat, t, dods, E, V, i, P, As, etai, Erevseg, k_frrseg] = cellIntRt( deltat, R, dodi, cell )

E0 = 0;
As0 = 0;
y0 = [dodi; E0; As0];
opt = odeset( 'Events', @(t,y) evtR(t, y, R, cell) ); % 'MaxStep',0.01);

[t, y] = ode45( @(t, y) cellStateRdt(t, y, R, cell), [0; deltat], y0, opt);

dods = y(:,1);
E = y(:,2);
As = y(:,3);

[ V, i, P, ~, etai ] = cellStateR( dods, R, cell );

if ( nargout > 9 )
    izero = 0;
    [~, ~, ~, Erev] = cellIntIdod( dods(1), dods(end), izero, cell );
    Erevseg = Erev(end);
    k_frrseg = E(end) / Erevseg;
end

end

function [ dxdt ] = cellStateRdt( t, x, R, cell )
% Function to predict cell discharge/charge vs. dod for constant load R
% Modeled as a state space diff. eq. 

dod = x(1);  % DOD
En = x(2);   % Energy delivered
As = x(3);   % Capacity expended

run(cell)

[ V, i ] = cellStateR( dod, R, cell );

ddoddt = i / Qmax;
dEndt = V * i;
dAsdt = i;

dxdt = zeros(2,1);

dxdt(1) = ddoddt;
dxdt(2) = dEndt;
dxdt(3) = dAsdt;

end

function [value,isterminal,direction] = evtR( t, x, R, cell )

dod = x(1);  % DOD

[ V, ~ ] = cellStateR( dod, R, cell );
run(cell)

value = [V - Vcutoff, V - Vcharge, dod, 1.0 - dod];
isterminal = [1 1 1 1];
direction = [0 0 0 0];

end
