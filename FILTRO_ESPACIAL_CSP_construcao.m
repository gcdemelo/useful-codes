%% COMMON SPATIAL PATTERNS
% 
% Essa funcao cria a matriz de transformacao linear CSP
% 
%% Criado em 05/2017                Atualizado em 11/04/2024
% 
%% REFERENCIAS:
% 
% Muller-Gerking et al. (1999) "Designing optimal spatial flters for single-trial EEG classification in a movement task".
% https://doi.org/10.1016/S1388-2457(98)00038-8
% 
% Ramoser et al. (2000) "Optimal spatial filtering of single trial EEG during imagined hand movement"
% https://doi.org/10.1109/86.895946
% 
% Wang et al. (2005) "Common Spatial Pattern Method for Channel Selelction in Motor Imagery Based Brain-computer Interface"
% https://doi.org/10.1109/IEMBS.2005.1615701
% 
% Yong et al. (2008) "Robust Common Spatial Patterns for EEG Signal Preprocessing"
% https://doi.org/10.1109/IEMBS.2008.4649604
% 
%% O ALGORITMO:
% 
% 1 - define a janela para a qual sera calculada a covariancia
% 2 - calcula a covariancia de cada classe em sucessivas janelas sem sobreposicao
% 3 - calcula a media de todas as matrizes de covariancia separadamente para cada classe
% 4 - soma as matrizes medias para obter a covariancia espacial composta
% 5 - acha a matriz de autovetores e autovalores da covariancia composta
% 6 - ordena os autovalores e os autovetores
% 7 - calcula a matriz de branqueamento
% 8 - faz o branqueamento nas matrizes de covariancia medias de cada classe
% 9 - acha a matriz de autovetores e autovalores da matriz branqueada de cada classe
% 10 - ordena os autovetores
% 11 - usa a matriz de autovetor calculada no passo 9 e a matriz de branqueamento para obter a matriz final de transformacao do sinal
% 
%% ENTRADAS DA FUNCAO:
% 
% vL => matriz da classe 1 (EEG filtrado em alguma banda - cada linha eh um canal)
% vR => matriz da classe 2 (EEG filtrado em alguma banda - cada linha eh um canal)
% fs => frequencia de amostragem (nao seria necessario, mas eu gosto de dividir as janelas em funcao disso)
% 
%%

function [filtro_csp] = FILTRO_ESPACIAL_CSP_construcao(vL,vR,fs)

Nc = min(size(vL)); % quantidade de canais de EEG

HR = zeros(Nc,Nc);
HL = zeros(Nc,Nc);

count = 0;

janela = fs; % janela de tempo para a qual sera calculada a covariancia de cada classe para depois obtermos a covariancia media entre todas as janelas

% dentro do loop eu calculo a covariancia de cada classe para a janela de tempo especificada
for i = 1:janela:length(vL)-janela+1
    
    % janela de 1s para cada classe
    indice_i = i;
    indice_f = i+fs-1;
    X_R = vR(:,indice_i:indice_f);
    X_L = vL(:,indice_i:indice_f);
    
    % a matriz de covariancia eh calculada nesse momento para um intervalo de 1s
    hR = X_R*X_R'/trace(X_R*X_R');
    hL = X_L*X_L'/trace(X_L*X_L');
    
    % as matrizes de covariancia de intervalos de 1s sao somadas, para depois obtermos a media
    HR = hR + HR;
    HL = hL + HL;
    
    count = count + 1;
end

% com varias matrizes de covariancia para janelas de 1s calculadas, obtemos a matriz de covariancia media de cada classe
HR_media = HR/count;
HL_media = HL/count;

% ao somar as matrizes das duas classes, temos a covariancia espacial composta
H = HR_media + HL_media; % covariância espacial composta

% decompomos H na matriz de autovetores
[V,D] = eig(H); % H = V*D*V'  ==>  V são os autovetores (em colunas) e D os autovalores

% parece que aqui os autovalores/vetores ja vieram ordenados, mas por via das duvidas eu ordeno de novo
numerando = [1:length(D); sum(D)]';
ordenando = sortrows(numerando,2); % ordem crescente
ordem = ordenando(:,1);
V_ordenado = V(:,ordem); % autovetores em ordem
D_ordenado = diag(D); % pega os elementos da diagonal e forma um vetor
D_ordenado = D_ordenado(ordem); % ordena o vetor
D_ordenado = D_ordenado.*eye(Nc); % cria a matriz diagonal com autovalores em ordem

% calculamos a matriz de branqueamento
P = ( D_ordenado^(-0.5) ) * V_ordenado'; % matriz de transformação “whitening” para H

% aplicamos o branqueamento de H nas matrizes de covariancia medias de cada classe
S_L = P*HL_media*P';
S_R = P*HR_media*P';

% decompomos cada matriz nas respectivas matrizes de autovetores e autovalores
% os autovetores devem ser os mesmos e a soma dos autovalores correspondentes deve ser iguai a 1
[Vl,Dl] = eig(S_L); % S_L = Vl*Dl*Vl'
[Vr,Dr] = eig(S_R); % S_R = Vr*Dr*Vr'

% Vr = Vl e Dl + Dr = I  ===> em um teste com matriz 'rand', os sinais das duas primeiras colunas de Vr e Vl ficaram trocados

% ordenamos os autovetores em funcao dos autovalores
numerando = [1:length(Dr); sum(Dr)]';
ordenando = sortrows(numerando,2); % ordem crescente
ordem = ordenando(:,1);
Vr_ordenado = Vr(:,ordem);

% a matriz de autovetores multiplcada pela matriz de branqueamento nos da a matriz de transformacao linear que desejamos
filtro_csp = Vr_ordenado'*P; % isso é o filtro com todas as componentes

       
end