% Procedimento descrito em:
% "A large scale screening study with a SMR-based BCI: Categorization of 
% BCI users and differences in their SMR activity" (2019)
% doi: 10.1371/journal.pone.0207351

% Eh um processo iterativo onde, a cada iteracao, os "trials" com desvio
% padrao maior que o dobro do desvio padrao medio sao eliminados.
% Na variavel 'eeg', cada linha deve corresponder a um "trial" diferente.

function [eeg,trials_eliminados] = rej_artefatos(eeg)

num_trials = 0;
trials_eliminados = 0;
while length(eeg(:,1)) ~= num_trials    
    dp = var(eeg,0,2).^0.5; % (A,w,dim) => w = 0 => n-1  ...  w = 1 => n
    dp_medio = mean(dp);
    num_trials = length(eeg(:,1)); % iguala num_trials ao tamanho instantaneo do eeg
    linhas_remanescentes = ones(1,num_trials);
    % se dentro do "for" o tamanho do eeg nao mudar, a funcao tem que encerrar
    for i = 1:length(eeg(:,1)) % esses limites sao definidos quando entra no for e nao muda - eh o 1o valor calculado que fica
        if dp(i) > 2*dp_medio            
            trials_eliminados = trials_eliminados + 1;
            linhas_remanescentes(i) = 0; % linha na posicao i vai ser eliminada                       
        end
    end
    eeg = eeg(logical(linhas_remanescentes),:);
end

end
