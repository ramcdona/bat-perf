function [deltat, t, dods, E, V, i, P, As, etai, Erevseg, k_frrseg] = cellIntIt( deltat, i, dodi, cell )

E0 = 0;
As0 = 0;
y0 = [dodi; E0; As0];
opt = odeset( 'Events', @(t,y) evtI(t, y, i, cell) ); % 'MaxStep',0.01);

[t, y] = ode45( @(t, y) cellStateIdt(t, y, i, cell), [0; deltat], y0, opt);

dods = y(:,1);
E = y(:,2);
As = y(:,3);

[ V, i, P, ~, etai ] = cellStateI( dods, i, cell );

if ( nargout > 9 )
    izero = 0;
    [~, ~, ~, Erev] = cellIntIdod( dods(1), dods(end), izero, cell );
    Erevseg = Erev(end);
    k_frrseg = E(end) / Erevseg;
end

end

function [ dxdt ] = cellStateIdt( t, x, i, cell )
% Function to predict cell discharge/charge vs. dod for constant current
% Modeled as a state space diff. eq. 

dod = x(1);  % DOD
En = x(2);   % Energy delivered
As = x(3);   % Capacity expended

run(cell)

[ V, ~ ] = cellStateI( dod, i, cell );

ddoddt = i / Qmax;
dEndt = V * i;
dAsdt = i;

dxdt = zeros(2,1);

dxdt(1) = ddoddt;
dxdt(2) = dEndt;
dxdt(3) = dAsdt;

end

function [value,isterminal,direction] = evtI( t, x, i, cell )

dod = x(1);  % DOD

[ V, ~ ] = cellStateI( dod, i, cell );
run(cell)

value = [V - Vcutoff, V - Vcharge, dod, 1.0 - dod];
isterminal = [1 1 1 1];
direction = [0 0 0 0];

end
