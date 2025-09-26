
%% Correlacao entre sinais

% Estima a correlacao cruzada entre dois sinais. Pode ser a estimativa 
% viciada (biased) ou nao viciada (unbiased). Essas alternativas so valem 
% para sinais de mesmo tamanho, assim como na funcao xcorr do matlab.
% Diferente da funcao xcorr do matlab, quando os sinais tem tamanhos
% diferentes, os valores da funcao que seriam forcosamente nulos na funcao
% xcorr sao retirados do resultado nesta funcao. Assim, tem-se o resultado
% mais comumente esperado quando se lida com sequencias discretas finitas.

% Gabriel Chaves de Melo           ---           maio/2020

function [rm] = correlacao(sinal1, sinal2, estimador)

% 0 => estimador viciado; 1 => não viciado

    if (size(sinal1)*[1 0]' > 1 && size(sinal1)*[0 1]' > 1) || (size(sinal2)*[1 0]' > 1 && size(sinal2)*[0 1]' > 1)
        error('This function does not accept matrix as an input')
    end
    if size(sinal1)*[0 1]' == 1 % vetor coluna tem que virar linha
        sinal1 = sinal1';
    end
    if size(sinal2)*[0 1]' == 1 % vetor coluna tem que virar linha
        sinal2 = sinal2';
    end
    
    
    
    
    ls1 = length(sinal1); ls2 = length(sinal2);  
    if ls1 < ls2
        x = [sinal1 zeros(1,ls2-ls1)];
        y = sinal2;
        
        caso = 1;
    end
    if ls2 < ls1
        x = sinal1;
        y = [sinal2 zeros(1,ls1-ls2)];
        
        caso = 2;
    end
    if ls1 == ls2
        x = sinal1;
        y = sinal2;
        
        caso = 3;
    end
   
    n = length(x); % x e y tem mesmo tamanho
    for k = 1:n
        soma = x(1:k)*y(end-(k-1):end)';
                
        if caso == 1 || caso == 2 % tamanhos diferentes
            rm(k) = soma;
        end
        if caso == 3 && estimador == 0 % viciado
            rm(k) = soma/n;
        end
        if caso == 3 && estimador == 1 % não viciado
            rm(k) = soma/k;
        end
        
    end
    for i = 2:n
        k = k+1;
        soma = x(i:end)*y(1:end-(i-1))';
                
        if caso == 1 || caso == 2 % tamanhos diferentes
            rm(k) = soma;
        end
        if caso == 3 && estimador == 0 % viciado => biased
            rm(k) = soma/n;
        end
        if caso == 3 && estimador == 1 % não viciado => unbiased
            rm(k) = soma/(n-i+1);
        end
        
    end
    
    if caso == 1
        rm = rm(1:end-(ls2-ls1));
    end
    if caso == 2
        rm = rm(ls1-ls2+1:end);
    end
    
end