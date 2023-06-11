clc; clear; 
% Run this script before simulink simulation !! 
% Checkout read me section to understand the each parameters meaning
% Read the analysis paper to get insigth on the system theoratically

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
R_L = Vo^2/P_out;


%%% Appling Design Criteria
L_m_min = (D_n^2)*R_L*(N1_N2^2)/(2*fsw);
L_m = L_m_min*1.05;

Max_Cur_Ripple_Inductor = Vs*D/(L_m*fsw);
assert(L_m > L_m_min);

Output_V_rip = 0.05;
C_min=D/(R_L*fsw*Output_V_rip);
C= C_min*1.2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Small Signal Analysis %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Arbitarily choosen parameters
r_c =  0.4;
r_ds = 0.3;
r_l =  0.2; 

%%% Derivated paremeters
tau = n^3*(D_n)^2*C*R_L*r_c + ( (C*r_l)*(R_L + r_c) + L_m )*( n- D*(n-1) );
rho = L_m*C*(R_L + r_c)*(n-D*(n-1));
gamma = n^3*D_n^2*R_L+(n-D*(n-1));

damp_ratio = tau/(2*(rho*gamma)^0.5);

angular_corner_freq = ( (n^3*(1-D)^2*R_L + (n-D*(n-1)*r_l) ) / (L_m*C*(R_L + r_c)*(n-D*(n-1)) ) )^0.5;

Gain_Constant = ( (n^2*D*D_n*R_L*r_c ) / (L_m*(R_L + r_c)*(n-D*(n-1))) );

w_zn = 1/(C*r_c);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Error Compansation Type 3 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Enter parameters here

phase_margin = 45;
assert(phase_margin>=45);
V_p = 3;
R_1_comp = 1e3;
fco = 10e3;

%%% @ 10kHz 
%%% Bode plot of the ac equvalent circuit parameters
phase_converter = -149;
converter_gain = -2.78; 


%%% Derivations of other parameters
pwm_gain = 20*log10(1/V_p);
phase_comp = phase_margin - phase_converter;
K = tan((phase_comp+90)/4)^2;
total_gain = -(converter_gain + pwm_gain);
G_mag = 10^(total_gain/20);

R_2_comp = G_mag*R_1_comp/(K^0.5);
C_1_comp = (K^0.5)/(2*pi*fco*R_2_comp);
C_2_comp = (2*pi*fco*R_2_comp*(K^0.5))^-1;
C_3_comp = (K^0.5)/(2*pi*fco*R_1_comp);
R_3_comp = (2*pi*fco*R_2_comp*(K^0.5)*C_3_comp)^-1;


