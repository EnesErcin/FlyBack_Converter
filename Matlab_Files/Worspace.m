
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% DC Analysis %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Given Parameters
Vs = 24;
Vo = 48;
P_out = 50;

%%% Arbitarily choosen parameters
D = 0.5;
D_n = 1- D;
fsw = 100e3;

%%% Basic Parameters for Simulink

N1 = Vs;
N2_N1 = Vo/Vs*(D_n)/D;
N2 = N2_N1 *N1;
N1_N2 = 1/N2_N1;
n = N1_N2;
R_L = P_out/Vo;

%%% Appling Design Criteria
L_m_min = (D_n^2)*R_L*(N1_N2^2)/(2*fsw);
L_m = L_m_min*1.05;

Max_Cur_Ripple_Inductor = Vs*D/(L_m*fsw);
assert(L_m > L_m_min);

Output_V_rip = 0.05;
C_min=D/(R_L*fsw*Output_V_rip);
C= C_min;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Small Signal Analysis %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Arbitarily choosen parameters
r_c =  0.1;
r_ds = 0.5;
r_l =  0.01; 

tau = n^3*(D_n)^2*C*R_L*r_c + ( (C*r_l)*(R_L + r_c) + L_m )*( n- D*(n-1) );
rho = L_m*C*(R_L + r_c)*(n-D*(n-1));
gamma = n^3*D_n^2*R_L+(n-D*(n-1));

damp_ratio = tau/(2*(rho*gamma)^0.5);

angular_corner_freq = ( (n^3*(1-D)^2*R_L + (n-D*(n-1)*r_l) ) / (L_m*C*(R_L + r_c)*(n-D*(n-1)) ) )^0.5;

Gain_Constant = ( (n^2*D*D_n*R_L*r_c ) / (L_m*(R_L + r_c)*(n-D*(n-1))) );

w_zn = 1/(C*r_c);
