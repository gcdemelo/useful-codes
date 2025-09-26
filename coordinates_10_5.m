%% (pt-br) Nomes e coordenadas polares e cartesianas dos eletrodos do sistema 10-5
% 
% Autor: Gabriel Chaves de Melo           gabrielchaves@alumni.usp.br
% 
% UNICAMP - IFGW - Grupo de Neurofísica
% Campinas - SP - BRASIL
% 
% Arquivo criado em julho de 2025
% Última atualização: ---
% 
% 
%% Convenção para as coordenadas polares - Carvalhaes e de Barros (2015):
% 
% A cabeça tem geometria esférica;
% Considere a origem do sistema de referência no centro da esfera:
% - O eixo x é na direção nuca-nariz, sendo positivo indo para o nariz e
% negativo indo para a nuca.
% - O eixo y é na direção orelha-orelha, sendo positivo para a esquerda e
% negativo para a direita.
% - O eixo z é na vertical, sendo positivo para cima e negativo para baixo.
% Convenção para coordenadas polares:
% theta => [0 pi]. Sai do eixo z, vertex (Cz), para baixo
% phi => [0 2*pi]. Sai do eixo x, Nz, sentido anti-horário
% 
% Logo,
% 
% 0 < phi < 180 corresponde ao hemisfério esquerdo
% 180 < phi < 360 corresponde ao hemisfério direito
% phi = 0, 180, 360 corresponde à linha z
% phi = 90, 270 corresponde à linha C
%
%
%% Método para definir os valores
% 
% As coordenadas foram definidas em uma geometria esférica.
% Primeiramente, as coordenadas teta do sistema 10-20 foram definidas
% utilizando as referências de 10% e 20% adaptadas para uma esfera. Para
% isso, foi considerado que, a partir da vista superior da esfera, as
% posições correspondentes a uma mesma linha (AF, F, FC, C,...) alinham-se
% horizontalmente. Depois, a partir da vista superior, foram traçadas retas
% partindo do centro (Cz) interceptando cada posição previamente definida.
% Por meio dessas retas foram definidos os valores de phi.
% Para as posições excedentes (aquelas com índice 'h'), foram feitas
% interpolações com as quatro posições no entorno. Por exemplo: para
% definir FCC1h, foi feita uma interpolação simples com FCz, FC1, Cz e C1.
% 
%%


for names = 1
    
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
    
end

radius = 1;

for polar_coordinates = 1
    % phi theta
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
end

for cartesian_coordinates = 1
    
    for i = 1:length(polar_coord)
        cart_coord(i,:) = [radius*sin(polar_coord(i,2)*2*pi/360)*cos(polar_coord(i,1)*2*pi/360) radius*sin(polar_coord(i,2)*2*pi/360)*sin(polar_coord(i,1)*2*pi/360) radius*cos(polar_coord(i,2)*2*pi/360)]; % polar coordinates to cartesian
    end
    
end

clearvars names polar_coordinates cartesian_coordinates i




