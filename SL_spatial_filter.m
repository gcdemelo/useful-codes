%% SURFACE LAPLACIAN FOR EEG
% 
% SURFACE LAPLACIAN METHOD WITH SPHERICAL SPLINES FOR EEG TRANSFORMATION
% 
% This algorithm computes a square matrix to linearly transform the EEG
% matrix acting as a spatial filter.
% 
% 
% 
% 
% Author: Gabriel Chaves de Melo           gabrielchaves@alumni.usp.br
% Created in July 2025
% Last update: ---


%% References:

% 1) Spherical splines for scalp potential and current density mapping (Perrin et al., 1989).
% 2) A Spline Framework for Estimating the EEG Surface Laplacian Using the Euclidean Metric (Carvalhaes & Suppes, 2011). DOI: 10.1162/NECO_a_00192
% 3) The surface Laplacian technique in EEG: Theory and methods (Carvalhaes & de Barros, 2015). DOI: 10.1016/j.ijpsycho.2015.04.023
% 4) Issues and Considerations for using the scalp surface Laplacian in EEG/ERP research: A tutorial review (Kayser & Tenke, 2015). DOI: 10.1016/j.ijpsycho.2015.04.012
% 
% For the equations, see sections 3.3 and 3.5 of Carvalhaes & de Barros (2015).
% For parameters selection, refer to the articles and to the transcripts at the end of this code.
% 
% Alternative material based on the mentioned references (portuguese only):
% https://doi.org/10.17771/PUCRio.acad.34769 (Apendice B)

%% Breif explanations:
% Error messages:
% 


%% INPUTS and OUTPUTS

% INPUTS:

% 'channels':   string vector with the names of all 'Nc' channels
% 'm':          integer scalar indicating spline flexibility
% 'Lep':        integer scalar indicating the number of iterations to calculate Legendre's polynomial (each iteration is a polynomial degree) (for each channel there is a summatory with Nc elements, and each element has a summatory of 'Lep' degrees of Legendre's polynomial)
% 'lambda':     scalar representing the regularization parameter (if it's equal to 0, than the splines will fit perfectly the potential values at each electrode location)
% 'r':          scalar indicating the radius of the sphere representing the head

% OUTPUT:

% 'L_filter':   matrix (Nc x Nc) that linearly transforms the original EEG potentials at the exact locations of the original channels

%%



function [L_filter] = SL_spatial_filter(channels,m,Lep,lambda,r)

% INCLUDE DEFAULT INPUT VALUES AND THE POSSIBILITY OF ENTERING A LIST OF
% CHANNELS OR POSITIONS OF THEIR OWN.

% JUST FOR TESTING:
% channels = ["AF3" "AF1" "AFz" "F5" "F1" "F2" "F6" "C3" "C4" "P3" "P4" "O1" "O2"]; m = 3; Lep = 50; lambda = 0.00001; r = 1;

if m < 2 || m > 6
    error('Spline flexibility m is out of recommended range (2 to 6).')
end


% code info - all available channels with polar coordinates and names
for coord_and_names = 1 % phi theta

    channel_names = [
    
    "Fp1"
    "Fp2"
    "Fpz"
    "AF1"
    "AF2"
    "AF3"
    "AF4"
    "AF5"
    "AF6"
    "AF7"
    "AF8"
    "AFz"
    "F1"
    "F2"
    "F3"
    "F4"
    "F5"
    "F6"
    "F7"
    "F8"
    "Fz"
    "FC1"
    "FC2"
    "FC3"
    "FC4"
    "FC5"
    "FC6"
    "FC7"
    "FC8"
    "FCz"
    "C1"
    "C2"
    "C3"
    "C4"
    "C5"
    "C6"
    "T7"
    "T8"
    "Cz"
    "CP1"
    "CP2"
    "CP3"
    "CP4"
    "CP5"
    "CP6"
    "CP7"
    "CP8"
    "CPz"
    "P1"
    "P2"
    "P3"
    "P4"
    "P5"
    "P6"
    "P7"
    "P8"
    "Pz"
    "PO1"
    "PO2"
    "PO3"
    "PO4"
    "PO5"
    "PO6"
    "PO7"
    "PO8"
    "POz"
    "O1"
    "O2"
    "Oz"
    "AF1h"
    "AF2h"
    "AF3h"
    "AF4h"
    "AF5h"
    "AF6h"
    "AFF1h"
    "AFF2h"
    "AFF3h"
    "AFF4h"
    "AFF5h"
    "AFF6h"
    "AFF7h"
    "AFF8h"
    "FFC1h"
    "FFC2h"
    "FFC3h"
    "FFC4h"
    "FFC5h"
    "FFC6h"
    "FFC7h"
    "FFC8h"
    "FCC1h"
    "FCC2h"
    "FCC3h"
    "FCC4h"
    "FCC5h"
    "FCC6h"
    "FCC7h"
    "FCC8h"
    "CCP1h"
    "CCP2h"
    "CCP3h"
    "CCP4h"
    "CCP5h"
    "CCP6h"
    "CCP7h"
    "CCP8h"
    "CPP1h"
    "CPP2h"
    "CPP3h"
    "CPP4h"
    "CPP5h"
    "CPP6h"
    "CPP7h"
    "CPP8h"
    "PPO1h"
    "PPO2h"
    "PPO3h"
    "PPO4h"
    "PPO5h"
    "PPO6h"
    "PPO7h"
    "PPO8h"
    "PO1h"
    "PO2h"
    "PO3h"
    "PO4h"
    "PO5h"
    "PO6h"
    "O1h"
    "O2h"
    
    "TP9"
    "TP10"
    "PO9"
    "PO10"
    "FT9"
    "FTT9h"
    "TTP7h"
    "TP7"
    "TPP9h"
    "FT10"
    "FTT10h"
    "TPP8h"
    "TP8"
    "TPP10h"
    "F9"
    "F10"
        ];
    
    polar_coord = [

    20	84		%	Fp1		1
    340	84		%	Fp2		2
    0	72		%	Fpz		3
    15	58		%	AF1		4
    345	58		%	AF2		5
    25	62		%	AF3		6
    335	62		%	AF4		7
    35	72		%	AF5		8
    325	72		%	AF6		9
    40	87		%	AF7		10
    320	87		%	AF8		11
    0	54		%	AFz		12
    31	43		%	F1		13
    329	43		%	F2		14
    44	54		%	F3		15
    316	54		%	F4		16
    52	68		%	F5		17
    308	68		%	F6		18
    56	81		%	F7		19
    304	81		%	F8		20
    0	36		%	Fz		21
    50	27		%	FC1		22
    310	27		%	FC2		23
    66	47		%	FC3		24
    294	47		%	FC4		25
    71	68		%	FC5		26
    289	68		%	FC6		27
    73	90		%	FC7		28
    287	90		%	FC8		29
    0	18		%	FCz		30
    90	18		%	C1		31
    270	18		%	C2		32
    90	36		%	C3		33
    270	36		%	C4		34
    90	54		%	C5		35
    270	54		%	C6		36
    90	72		%	T7		37
    270	72		%	T8		38
    0	0		%	Cz		39
    130	27		%	CP1		40
    230	27		%	CP2		41
    114	47		%	CP3		42
    246	47		%	CP4		43
    109	68		%	CP5		44
    251	68		%	CP6		45
    107	90		%	CP7		46
    253	90		%	CP8		47
    180	18		%	CPz		48
    149	43		%	P1		49
    211	43		%	P2		50
    136	54		%	P3		51
    224	54		%	P4		52
    128	68		%	P5		53
    232	68		%	P6		54
    124	81		%	P7		55
    236	81		%	P8		56
    180	36		%	Pz		57
    165	58		%	PO1		58
    195	58		%	PO2		59
    155	62		%	PO3		60
    205	62		%	PO4		61
    145	72		%	PO5		62
    215	72		%	PO6		63
    140	87		%	PO7		64
    220	87		%	PO8		65
    180	54		%	POz		66
    160	84		%	O1		67
    200	84		%	O2		68
    180	72		%	Oz		69    
    7.5	56          %	AF1h		70
    352.5	56		%	AF2h		71
    20	60          %	AF3h		72
    340	60          %	AF4h		73
    30	67          %	AF5h		74
    330	67          %	AF6h		75
    11.5	47.75	%	AFF1h		76
    348.5	47.75	%	AFF2h		77
    28.75	54.25	%	AFF3h		78
    331.25	54.25	%	AFF4h		79
    39	64          %	AFF5h		80
    321	64          %	AFF6h		81
    45.75	77		%	AFF7h		82
    314.25	77		%	AFF8h		83
    20.25	29		%	FFC1h		84
    339.75	29		%	FFC2h		85
    47.75	42.75	%	FFC3h		86
    312.25	42.75	%	FFC4h		87
    58.25	59.25	%	FFC5h		88
    301.75	59.25	%	FFC6h		89
    63	76.75		%	FFC7h		90
    297	76.75		%	FFC8h		91
    54	14  		%	FCC1h		92
    306	14      	%	FCC2h		93
    74	32          %	FCC3h		94
    286	32          %	FCC4h		95
    79.25	51.25	%	FCC5h		96
    280.75	51.25	%	FCC6h		97
    81	71          %	FCC7h		98
    279	71          %	FCC8h		99
    126	14      	%	CCP1h		100
    234	14  		%	CCP2h		101
    106	32          %	CCP3h		102
    254	32          %	CCP4h		103
    100.75	51.25	%	CCP5h		104
    259.25	51.25	%	CCP6h		105
    99	71          %	CCP7h		106
    261	71          %	CCP8h		107
    159.75	31		%	CPP1h		108
    200.25	31		%	CPP2h		109
    132.25	42.75	%	CPP3h		110
    227.75	42.75	%	CPP4h		111
    121.75	59.25	%	CPP5h		112
    238.25	59.25	%	CPP6h		113
    117	76.75		%	CPP7h		114
    243	76.75		%	CPP8h		115
    168.5	47.75	%	PPO1h		116
    191.5	47.75	%	PPO2h		117
    151.25	54.25	%	PPO3h		118
    208.75	54.25	%	PPO4h		119
    141	64          %	PPO5h		120
    219	64          %	PPO6h		121
    134.25	77		%	PPO7h		122
    225.75	77		%	PPO8h		123
    172.5	56		%	PO1h		124
    187.5	56		%	PO2h		125
    160	60          %	PO3h		126
    200	60          %	PO4h		127
    150	67          %	PO5h		128
    210	67          %	PO6h		129
    170	78          %	O1h     	130
    190	78          %	O2h         131
    
    251	108         %	TP9         132
    109	108         %	TP10		133
    145	105         %	PO9         134
    215	105         %	PO10		135
    71	108         %	FT9         136
    79.25	89		%	FTT9h		137
    99	71          %	TTP7h		138
    107	90          %	TP7         139
    115.5	94.75	%	TPP9h		140
    289	108         %	FT10		141
    280.75	89		%	FTT10h		142
    261	71          %	TPP8h		143
    253	90          %	TP8         144
    244.5	94.75	%	TPP10h		145
    56	99          %	F9      	146
    304	99          %	F10     	147

    ];
end % the 'for' is just for hiding the lines

Nc = length(channels); % number of channels from the input

ch_ind = nonzeros((channels == channel_names).*(1:length(channel_names))'); % indices corresponding to the input channels' names
pos = polar_coord(ch_ind,:); % polar coordinates of the input channels

% verifying if there are channels from the input that were not identified by this code
if length(pos(:,1)) < Nc
    if Nc-length(pos(:,1)) > 1
        error('There are %.0f unidentified channels.',Nc-length(pos(:,1)))
    else
        error('There is %.0f unidentified channel.',Nc-length(pos(:,1)))
    end
end

    % calculating matrices k_til and k

    for i = 1:Nc % i is the channel for which the Laplacian is being calculated
        soma_gm = 0;
        for j = 1:Nc % j corresponds to all the other channels that are used to calculate the Laplacian of channel i
            rj = [r*sin(pos(j,2)*2*pi/360)*cos(pos(j,1)*2*pi/360) r*sin(pos(j,2)*2*pi/360)*sin(pos(j,1)*2*pi/360) r*cos(pos(j,2)*2*pi/360)]; % polar coordinates to cartesian
            ri = [r*sin(pos(i,2)*2*pi/360)*cos(pos(i,1)*2*pi/360) r*sin(pos(i,2)*2*pi/360)*sin(pos(i,1)*2*pi/360) r*cos(pos(i,2)*2*pi/360)]; % polar coordinates to cartesian
            pe = dot(rj/r,ri/r); % dot product between position vector of electrode i and position vector of electrode j
            
            termo_gm = 0; 
            soma_gm = 0;
            for L = 1:Lep % summation to calculate gm (in theory it's 1:infinity)
                
                pl = legendreP(L,pe); % L degree Legendre polynomial => at the end of this code there is an alternative way to calculate without matlab built-in function
                
                termo_gm = pl*(2*L+1)/((L*(L+1))^m); % one element from the summatory
                soma_gm = soma_gm+termo_gm; % summing to all the other elements
            end
            gm = soma_gm/(4*pi);
            k(i,j) = gm;
            k_til(j,i) = -gm/(r^2);
        end
    end

    % QR decomposition

    T = ones(Nc,1); 
    [Q,R] = qr(T);
    Q1 = [Q(:,1)];
    Q2 = [Q(:,2:length(Q))]; 

    % calculating the filter matrix

    KNI = k+Nc*lambda*eye(length(k)); % check condition number of KNI
    cn = abs(max(eig(KNI))/min(eig(KNI))); % this is the condition number => ABSOLUTE VALUE OR NOT?
    cn_good = (cn < 10E11); % "In principle, a condition number up to 10^12 should be acceptable for splines (Sibson and Stone, 1991)" - Carvalhaes & de Barros (2015)
    
    % verifying if the numerical inversion of matrix [K+N*lambda*I] is possible
    if ~cn_good
        error('Condition number of [K+N*lambda*I] exceeds the limit of 10^12. Consider changing spline flexibility - m - and/or regularization parameter - lambda -.')
    end
    
    C = Q2*inv(Q2'*(KNI)*Q2)*Q2'; 
    
    L_filter = k_til*C;
    
end



%% EXTRA CONTENT



%% L degree Legendre polynomial ===> alternative code with same results as matlab built-in function 'legendreP(L,pe)'

% soma_pl = 0;
% for kk = 0:floor(L/2)
%     termo_pl = (((-1)^kk)*factorial(2*L-2*kk)*pe^(L-2*kk))/(factorial(kk)*factorial(L-kk)*factorial(L-2*kk));
%     soma_pl = soma_pl+termo_pl;
% end
% pl = (2^(-L))*soma_pl;                
% % end of alternative code for Legendre polynomial



%% Literature information

% ====> MY CHOICES FOR THE PARAMETERS:

% => lambda =< 10^-5. (lower values might cause numerical problems for matrix inverse - this code will acuse it if it does)
% => m = 3 or 4.
% => Lep = 50.


% =========================================================================
% ===========> Kayser & Tenke (2015) - "Issues and considerations..."

% Spline flexibility is determined by a constant m, which is an integer
% value greater than 1. (...) The most flexible spline function corresponds
% to m = 2, and increasingly more rigid splines correspond to greater 
% values of m.

% Babiloni et al. (1995) found that spline flexibility strongly influenced the optimal choice for
% lambda (i.e., greater spline flexibility required greater smoothing, with
% optimal values of lambda between 10^-9 and 10^-2, indicating that lambda correction also
% acts as a spatial filter. By comparison, spatial noise and montage density
% had only moderate impact for determining optimal values for lambda.

% ...spatial low-pass filter properties associated with less flexible
% splines (i.e., greater m constant) and more regularization or smoothing
% (i.e., greater lambda value) can – to a certain degree – mutually compensate to
% achieve optimal potential estimates. As a consequence, lambda-optimized
% CSDs obtained with different spline orders yield more similar surface
% Laplacian estimates (between-topography correlations were
% 0.6872 =< r =< 0.9970) compared to those obtained with a fixed lambda
% value (cf. Fig. 8A, which employed a default smoothing constant
% of lambda = 0.00001 for all spline orders, yielding 0.3775 =< r =< 0.9693
% for 72 channels, and 0.6054 =< r =< 0.9714 for 31 channels).
% 
% The estimation of an optimal regularization parameter from empirical
% data has an unfortunate byproduct: putative measures of interest,
% including different ERP components, EEG spectra or time-frequency
% measures, will be associated with different optimal lambda values. This concern
% also applies to different experimental conditions, study groups, or
% individual subjects. Because it is rather undesirable tomodify the spline
% computation algorithm within a given study or analysis, as a rule-ofthumb,
% previous ‘optimal’ lambda values provide an appropriate choice, and
% eliminate the possibility of an arbitrary regularization parameter selection
% (cf. Nunez and Srinivasan, 2006).We have repeatedly found that a
% lambda value of 10^-5 serves as a robust regularization constant for a wide
% range of EEG/ERP applications for a commonly-used spherical spline
% order (m=4), yielding surprisingly similar CV minima when compared
% with the CV optimum(e.g., for the N1 sink topographies shown in Fig. 9
% with m=4, optimal and default values of lambda corresponded to CV criterion
% values of 9.4952 and 9.5264, respectively).

% [ - THIS IS ABOUT LEGENDRE POLYNOMIAL SUMMATORY LIMMITS L->INFINITY - ]
% To obtain a valid solution for this iterative series to yield a sufficient 
% precision for creating a data transformation matrix, a minimum number of
% iterations are required. In general, a larger number of iterations
% will generate better results, however, as any improvements will become
% increasingly smaller with additional iterations, the computational costs
% will eventually outweigh their gain. Using a 19-channel EEG montage,
% Perrin et al. (1989) noted that a minimum of 7 iterations were required
% for a spline order of m=4 to obtain a precision of 10^-6. Because the precision
% level will be affected by the spline order and montage density, a minimum
% of 20 iterations, but preferably 50 or more, is a good choice.



% =========================================================================
% ===========> Carvalhaes & de Barros (2015) - "The Surface Laplacian..."

% Our discussion recommended to set the spline parametermas equal
% to 3 or 4 to avoid numerical issues.

% The summation over Legendre polynomials generates progressively
% higher spatial frequencies which are weighted by the factor
% (2L + 1)/( L^m (L + 1)^m ). Since this factor decreases with L, it acts 
% as a Butterworth filter that downweights high-frequency spatial 
% components.

% Our discussion recommended to set the spline parametermas equal
% to 3 or 4 to avoid numerical issues. Fig. 6 gives further insight into this
% problem. This example shows a compromise between m, the effective
% number of degrees of freedom of the spline fit, and the lower bound of
% lambda. Although small and large values ofmappear equally suitable to assess
% low degrees of freedom, say DFlambda b 10, the fact that lambda is bounded from
% below at 10^-8 prevents us from exploiting the region of DFlambda N 20 properly
% without setting m=3 or 4. One may try to circumvent this limitation
% by decreasing the lower bound of lambda toward zero, but as explained in
% Section 3.2 this has the problem of impoverishing the numerical conditioning,
% thus reinforcing our above recommendation.

% [ - ABOUT THE CONDITION NUMBER FOR INVERTING THE COEFFICIENT MATRIX - ]
% In principle, a condition number up to 10^12 should be acceptable for
% splines (Sibson and Stone, 1991).



% =========================================================================
% ===========> Carvalhaes & Suppes (2011) - "A Spline Framework for..."

% ...the condition number for the coefficient matrix of equation 2.1 is 
% usually high, and it gets rapidly worse by increasing m for montages with
% more than 64 electrodes. Therefore, one has little room for selecting m in
% practice—typically 2 =< m =< 6 (Babiloni et al., 1995).




