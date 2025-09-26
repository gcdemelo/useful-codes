clear all
close all
clc

%% Objetivo: Simular o ERD para fins didáticos e para testes

% O algoritmo simula cinco fontes corticais na mesma frequencia que se
% sincronizam e dessincronizam em termos de suas fases, gerando um sinal de
% EEG com ERD. O sinal seria correspondente a medicao de um unico canal.
% Sao gerados diversos sinais, simulando diferentes repeticoes de uma mesma
% tarefa medidos no mesmo canal. Eh inserida em cada tentativa uma
% variabilidade temporal "inter-trial" no inicio do sinal, no inicio do ERD
% e no final do ERD. Um hipotetico ERP na mesma frequencia pode ser
% inserido no mesmo intervalo em que ocorre o ERD, simulando uma fonte 
% cortical independente que se soma as fontes que geram o ERD. Alem disso, 
% eh possivel tambem inserir um ruido branco nos sinais de cada repeticao.

% 1a versao: 22/10/2021             Autor: Gabriel Chaves de Melo
% Ultima versao: 22/10/2021         email: chaves1135@gmail.com

add_ERP = 0;
add_NOISE = 1;
total_trials = 20; % quantidade de repeticoes que serao criadas

dt = 1/100; % periodo de amostragem em segundos
ti = dt; % instante inicial da amostragem em segundos
tf = 5; % instante final da amostragem em segundos
t0 = ti:dt:tf;

f1 = 8; 
f2 = f1; f3 = f1; f4 = f1; f5 = f1;

for trials = total_trials

    eeg = zeros(trials,length(t0));
    for i = 1:trials

        t = t0+1*rand(1);
        ti_erd = (40+rand(1)*10)/100; % porcentagem do intervalo total em que comeca o ERD
        tf_erd = (80+rand(1)*10)/100;
        delta_erd = tf_erd-ti_erd;

        ph1 = [zeros(1,floor(ti_erd*length(t))) 2*pi*rand(1)*ones(1,floor(delta_erd*length(t))) zeros(1,floor((1-tf_erd)*length(t)))];
        ph2 = [zeros(1,floor(ti_erd*length(t))) 2*pi*rand(1)*ones(1,floor(delta_erd*length(t))) zeros(1,floor((1-tf_erd)*length(t)))];
        ph3 = [zeros(1,floor(ti_erd*length(t))) 2*pi*rand(1)*ones(1,floor(delta_erd*length(t))) zeros(1,floor((1-tf_erd)*length(t)))];
        ph4 = [zeros(1,floor(ti_erd*length(t))) 2*pi*rand(1)*ones(1,floor(delta_erd*length(t))) zeros(1,floor((1-tf_erd)*length(t)))];
        ph5 = [zeros(1,floor(ti_erd*length(t))) 2*pi*rand(1)*ones(1,floor(delta_erd*length(t))) zeros(1,floor((1-tf_erd)*length(t)))];
        
        SS = [zeros(1,floor(ti_erd*length(t))) ones(1,floor(delta_erd*length(t))) zeros(1,floor((1-tf_erd)*length(t)))];

        if length(ph1) < length(t)
            d = length(t) - length(ph1);
            ph1 = [zeros(1,d) ph1]; 
            ph2 = [zeros(1,d) ph2]; 
            ph3 = [zeros(1,d) ph3]; 
            ph4 = [zeros(1,d) ph4];
            ph5 = [zeros(1,d) ph5];
            
            SS = [zeros(1,d) SS];
        end

        S1 = sin(2*pi*f1*t+ph1);
        S2 = sin(2*pi*f2*t+ph2);
        S3 = sin(2*pi*f3*t+ph3);
        S4 = sin(2*pi*f4*t+ph4);
        S5 = sin(2*pi*f5*t+ph5);               

        eeg(i,:) = S1+S2+S3+S4+S5;
        
        if add_ERP ~= 0
            ERP = 4*sin(2*pi*f5*t0); ERP = ERP.*SS;
            eeg(i,:) = eeg(i,:) + ERP;
        end        

    end
    
    if add_NOISE ~= 0
        eeg = eeg+wgn(size(eeg)*[1 0]',size(eeg)*[0 1]',10E-3);
    end    

    %%
    b = ones(1,floor(0.05*length(t0)));
    a = 1;

    energy = eeg.^2;
    bp = mean(energy);
    bp2 = filter(b,a,bp);

    iv = var(eeg);
    iv2 = filter(b,a,iv);

    average = mean(eeg);
    ap = average.^2;
    ap2 = filter(b,a,ap);

    % figure('name','ERD calculation')

    subplot(3,1,1)
    plot(t0,bp2)
    grid on
    title('Bandpower method')
    % hold on
    % plot(t0,ap2+iv2)

    subplot(3,1,2)
    plot(t0,iv2)
    grid on
    title('Intertrial variance method')

    subplot(3,1,3)
    plot(t0,ap2)
    grid on
    title('Average power method')
    % hold on
    % plot(t0,bp2-iv2)

    pause(0.1)

end

%%

figure('name','Five different sources')
ti = round(t(floor(ti_erd*length(t))),2);
tf = round(t(floor(tf_erd*length(t))),2);

subplot(6,1,1)
plot(t,S1)
title('Neuronal source 1')
grid on
xticks([ti tf])
% yticks([])
xlim([min(t) max(t)])
ax = gca;
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 1;
ax.Layer = 'top';

subplot(6,1,2)
plot(t,S2)
title('Neuronal source 2')
grid on
xticks([ti tf])
% yticks([])
xlim([min(t) max(t)])
ax = gca;
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 1;
ax.Layer = 'top';

subplot(6,1,3)
plot(t,S3)
title('Neuronal source 3')
grid on
xticks([ti tf])
% yticks([])
xlim([min(t) max(t)])
ax = gca;
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 1;
ax.Layer = 'top';

subplot(6,1,4)
plot(t,S4)
title('Neuronal source 4')
grid on
xticks([ti tf])
% yticks([])
xlim([min(t) max(t)])
ax = gca;
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 1;
ax.Layer = 'top';

subplot(6,1,5)
plot(t,S5)
title('Neuronal source 5')
grid on
xticks([ti tf])
% yticks([])
xlim([min(t) max(t)])
ax = gca;
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 1;
ax.Layer = 'top';

subplot(6,1,6)
plot(t,eeg(end,:))
if add_ERP ~= 0 && add_NOISE ~= 0
    title('Scalp potentials: summation of sources + ERP + noise')
end
if add_ERP ~= 0 && add_NOISE == 0
    title('Scalp potentials: summation of sources + ERP')
end
if add_ERP == 0 && add_NOISE ~= 0
    title('Scalp potentials: summation of sources + noise')
end
if add_ERP == 0 && add_NOISE == 0
    title('Scalp potentials: summation of sources')
end
grid on
xticks([ti tf])
% yticks([])
xlim([min(t) max(t)])
ax = gca;
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 1;
ax.Layer = 'top';
%%

figure('name','Different trials')
for i = 1:4
    subplot(4,1,i)
    plot(t0,eeg(i,:))
    title(['Trial number',' ',num2str(i)])
end

fprintf('\n\nFator de correção (FC) do método IV: %.4f\n\n',(total_trials-1)/total_trials)
fprintf('BP = AP + FC*IV\n\n',(total_trials-1)/total_trials)
