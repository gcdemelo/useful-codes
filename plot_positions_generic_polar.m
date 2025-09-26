clear
close all
clc

% Author: Gabriel Chaves de Melo           gabrielchaves@alumni.usp.br
% Group of Neurophysics - UNICAMP - Brazil
% Created in 07 August 2025
% Latest update: ---

% Padrão BESA (- NÃO utilizado neste algoritmo):
% consultar site:
% https://wiki.besa.de/index.php?title=Electrodes_and_Surface_Locations


%% Carvalhaes e de Barros (2015) - EM USO:
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

% Logo,

% 0 < phi < 180 corresponde ao hemisfério esquerdo
% 180 < phi < 360 corresponde ao hemisfério direito
% phi = 0, 180, 360 corresponde à linha z
% phi = 90, 270 corresponde à linha C

%%

which_plot = '10-10'; % 'generic' or '10-10'

r = 1;


if strcmpi(which_plot,'10-10')
    
    for coord_and_names = 1 % phi  theta
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
    170	78          %	O1h         130
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

    polar_coord = round(polar_coord,1);
    
    for i = 1:length(polar_coord)
        
        phi = polar_coord(i,1);
        theta = polar_coord(i,2);
        
        
        r = 1; %if theta >= 90; r = 1+(theta-90)*100; end
        
        % polar to cartesian
        x = r*sin(theta*2*pi/360).*cos(phi*2*pi/360);
        y = r*sin(theta*2*pi/360).*sin(phi*2*pi/360);
        z = r*cos(theta*2*pi/360);
        
        car = [x y z];
        
        
        % plot
        
        if i == 1; cor = 'r'; end
        if i == 4; cor = 'b'; end
        if i == 13; cor = [0 0 0]; end
        if i == 22; cor = 'b'; end
        if i == 31; cor = [0 0 0]; end
        if i == 40; cor = 'b'; end
        if i == 49; cor = [0 0 0]; end
        if i == 58; cor = 'b'; end
        if i == 67; cor = [0 0 0]; end
        
        if i == 70; cor = [0.5 0.5 0.5]; end % positions with h
        if i >= 132; cor = 'g'; end % new positions
        
        plot3(car(1), car(2), car(3),'o','color',cor,'MarkerFaceColor',cor) % plot3([0; car(1)], [0; car(2)], [0; car(3)],'-o','color',cor)
        
        grid on
        hold on
        xlim([-1.2 1.2])
        ylim([-1.2 1.2])
        zlim([-1.2 1.2])
        
        
        pause(0.0001)
        
        
        
    end
    
    
end



if strcmpi(which_plot,'generic')
    
    for phi = 0:10:360
        for theta = 0:18:18*5
            
            r = 1; if theta >= 90; r = 1+(theta-90)*100; end
            
            % polar to cartesian
            x = r*sin(theta*2*pi/360).*cos(phi*2*pi/360);
            y = r*sin(theta*2*pi/360).*sin(phi*2*pi/360);
            z = r*cos(theta*2*pi/360);
            
            car = [x y z];
            
            
            % plot
            
            if phi == 0 || phi == 180 || phi == 360
                cor = [0 0 0]; % linha z em preto
            elseif phi == 90 || phi == 270
                cor = 'b'; % linha C em azul
            elseif phi > 0 && phi < 180
                cor = 'r'; % hemisfério esquerdo
            elseif phi > 180 && phi < 360
                cor = 'g'; % hemisfério direito
            end
            
            %         plot3([0; car(1)], [0; car(2)], [0; car(3)],'-o','color',cor)
            plot3(car(1), car(2), car(3),'o','color',cor)
            
            grid on
            hold on
            xlim([-1.2 1.2])
            ylim([-1.2 1.2])
            zlim([-1.2 1.2])
            
            
            pause(0.0001)
            
            
        end
    end
    
    
end