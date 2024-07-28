% Data sheet values
irated = 4.2;  % A
Vcutoff = 2.5;
Vcharge = 4.2;
Vmargin = 0.01;

% OCV Curve fit parameters
Vlin0_parm = 4.1132;
B_parm = 3 / .02;   % 3 / exponential run
D_parm = -0.0373;
E_parm = -.06;
F_parm = 2.0 * pi / .25;
G_parm = 0;
H_parm = 3.0 / 0.2547;
K_parm = -0.7593;

% Rss Curve fit parameters
R0_parm = 0.0158;
Rslope_parm = -0.0053;
RA_parm = .0800;
RB_parm = 3.0 / .0630;

% Power fade (resistance growth) parameter.
global kR_parm;
if ( isempty( kR_parm ) )
    kR_parm = 1.0;
end

% Capacity fade parameter.
global kQ_parm;
if ( isempty( kQ_parm ) )
    kQ_parm = 1.0;
end


A_parm = Vcharge - Vmargin - Vlin0_parm - E_parm * sin( - G_parm );  % Exponential drop
C_parm = D_parm / ( Vcutoff - Vlin0_parm - K_parm );

% Computation of model coefficients from data points
Qmax = kQ_parm * irated * 3600;    % Maximum capacity in As

OCVfun = @(dod) Vlin0_parm + K_parm*dod + A_parm * exp( -B_parm * dod ) ...
    + E_parm * sin( F_parm * dod - G_parm ) .* exp( -H_parm * dod )...
    + D_parm * ( dod ./ ( C_parm + 1.0 - dod ) );

Rssfun = @(dod) kR_parm * (R0_parm + Rslope_parm * dod + RA_parm * exp( - RB_parm * ( 1.0 - dod ) ));
