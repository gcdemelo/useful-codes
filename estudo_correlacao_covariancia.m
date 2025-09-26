%% Codigo para investigar covariancia, correlacao e seus calculos
clear all
clc

% A funcao corrcoef(x,y), sendo x e y vetores, calcula o coeficiente de Pearson
% entre os pares (x,x), (x,y), (y,x) e (y,y). Note que essa funcao eh
% diferente de xcorr, que calcula a correlacao cruzada transladando um
% sinal em relacao ao outro. Nao encontrei diferenca entre corrcoef e corr.



% matrizes de sinais ficticios centrados no 0
qtde_canais = 5;
x = rand(qtde_canais,1000); x = x.*[2*ones(5,400) 4*ones(5,400) 1*ones(5,200)]+5*rand(5,1); x = x - mean(x,2);
% y = rand(qtde_canais,1000); y = y - mean(y,2); y = y.*[3*ones(5,400) 1.5*ones(5,400) 2.2*ones(5,200)];

CORR = corr(x'); % mesma coisa que corrcoef(x')

% calculo da matriz de correlacao elemento a elemento
for i = 1:qtde_canais
    for j = 1:qtde_canais
        xi = x(i,:);
        xj = x(j,:);
        xii = xi-mean(xi);
        xjj = xj-mean(xj);
        num = xii*xjj';
        den = sqrt(xii*xii')*sqrt(xjj*xjj');
        
        CORR_MANUAL(i,j) = num/den;
    end
end

%% Relacao entre a covariancia do matlab e a covariancia dos artigos:

% assim que os artigos mandam calcular a matriz de COVARIANCIA (creio que a media dos sinais deve ser nula para funcionar)
COV_ARTIGO = (x*x')/trace(x*x'); % a divisao por trace(.) eh para normalizar possiveis flutuacoes entre os sinais. os elementos da diagonal representam uma fracao da energia total de cada canal (Kous, et al. 1990)

% substituindo a soma dos elementos da diagonal pela media deles foi o 
% jeito que encontrei resultados mais proximos da funcao cov, mas nao sao
% identicos.
COV_ARTIGO_MODIFICADO = (x*x')/mean(diag(x*x'));
% na verdade, os elementos da diagonal sao parecidos, entao poderia usar um
% elemento qualquer dela, mas preferi usar a media. a correcao, entao, eh
% multiplicar pela soma dos elementos e dividir pela media dos elementos.
% isso resulta na simples multiplicacao da matriz obtida pelo metodo do
% artigo pela quantidade de linhas (canais) de x. ou seja:
% COV_ARTIGO_MODIFICADO = COV_ARTIGO*size(x,1) = COV;
%%

COV = cov(x');

% estimativa fornecida na wikipedia (https://en.wikipedia.org/wiki/Covariance_matrix) ==> os sinais tem que estar centrados no zero
COV_WIKI = x*x'/(length(x)-1);

% calculo da matriz de covariancia elemento a elemento
for i = 1:qtde_canais
    for j = 1:qtde_canais
        xi = x(i,:);
        xj = x(j,:);
        xii = xi-mean(xi);
        xjj = xj-mean(xj);
        num = xii*xjj';
        den = length(xi)-1;
        
        COV_MANUAL(i,j) = num/den;
    end
end


