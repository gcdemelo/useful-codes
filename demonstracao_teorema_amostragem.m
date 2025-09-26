clear all
close all
clc

%% Demonstração de uma consequência do teorema da amostragem

dt = 1/10E5;
t = 0:dt:1-dt;
f = 25;
analog = sin(2*pi*t*f); % fingimos que é um sinal contínuo

display(sprintf('\n\nFazer gráfico dinâmico? Responda 1 para sim e 0 para não.'))
resp = input('');

if resp == 1 % plot dinâmico

    for fs = [f:0.04:1.2*f 1.1*f:5:5.1*f] % frequencia de amostragem indo de 1x a maior frequencia do sinal analogico ate 10x
        plot(t,analog)
        hold on
        ts = 0:(1/fs):max(t);
        sampled = sin(2*pi*ts*f);
        plot(ts,sampled)
        xlabel('[s]')

        hold off
        clc
        display(sprintf('\nFrequência do sinal: %f Hz', f))
        display(sprintf('\nFrequência de amostragem: %f Hz', fs))
        

        pause(0.00001)
        
    end

    close all
    plot(t,analog)
    hold on
    grid on
    hold on
%     plot(ts,sampled,'*')
    hold on
    plot(ts,sampled,'linewidth',1.5)
    xlabel('[s]')
    
    figure
    subplot(2,1,1)
    
    freq_sampled = abs(fft(sampled));
    freq_sampled = freq_sampled(1:floor(0.5*length(freq_sampled)));
    
    passo_freq = 0.5*fs/length(freq_sampled);
    vetor_freq_sampled = 0:passo_freq:0.5*fs-passo_freq;
    
    plot(vetor_freq_sampled,freq_sampled)
    title('Frequency domain - sampled')
    grid on
    xlim([0 50])
    xlabel('[Hz]')
    
    subplot(2,1,2)
    
    freq_analog = abs(fft(analog));
    freq_analog = freq_analog(1:floor(0.5*length(freq_analog)));
    
    passo_freq = 0.5*(1/dt)/length(freq_analog);
    vetor_freq_analog = 0:passo_freq:0.5*(1/dt)-passo_freq;
    
    plot(vetor_freq_analog,freq_analog)
    title('Frequency domain - analog')
    grid on
    xlim([0 50])
    xlabel('[Hz]')
    
    if fs <= 2*f
        display(sprintf('\n\nTeorema de Nyquist NÃO foi respeitado.'))
    else
        display(sprintf('\n\nTeorema de Nyquist FOI respeitado.'))
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

else % plot único
%     fs = 1.1*f;
    display(sprintf('A frequencia do sinal analógico é 25 Hz. Qual a frequencia de amostragem desejada?'))
    fs = input('');
    ts = 0:(1/fs):max(t);
    sampled = sin(2*pi*ts*f);

    subplot(2,1,1)
    
    freq_sampled = abs(fft(sampled));
    freq_sampled = freq_sampled(1:floor(0.5*length(freq_sampled)));
    
    passo_freq = 0.5*fs/length(freq_sampled);
    vetor_freq_sampled = 0:passo_freq:0.5*fs-passo_freq;
    
    plot(vetor_freq_sampled,freq_sampled)
    title('Frequency domain - sampled')
    grid on
    xlim([0 50])
    xlabel('[Hz]')
    
    subplot(2,1,2)
    
    freq_analog = abs(fft(analog));
    freq_analog = freq_analog(1:floor(0.5*length(freq_analog)));
    
    passo_freq = 0.5*(1/dt)/length(freq_analog);
    vetor_freq_analog = 0:passo_freq:0.5*(1/dt)-passo_freq;
    
    plot(vetor_freq_analog,freq_analog)
    title('Frequency domain - analog')
    grid on
    xlim([0 50])
    xlabel('[Hz]')
           
    display(sprintf('\nFrequência do sinal: %f Hz', f))
    display(sprintf('\nFrequência de amostragem: %f Hz', fs))
    
    figure
    plot(t,analog)
    hold on
    plot(ts,sampled,'*')
    grid on
    hold on
    plot(ts,sampled,'linewidth',1.5)
    xlabel('[s]')
    
    if fs <= 2*f
        display(sprintf('\n\nTeorema de Nyquist NÃO foi respeitado.'))
    else
        display(sprintf('\n\nTeorema de Nyquist FOI respeitado.'))
    end
    
end

display(sprintf('\n\nFim'))




