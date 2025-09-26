clear all
close all
clc



fa = 2000;
fmax = fa/2;
N = 2000;
t = (1/fa):(1/fa):(N/fa);
n = 0:N-1;
w = 2*pi/fa; % w/f
m = 0.5*[6.0 5.5 5.0 4.5 4.0 3.5 3.0 2.5 2.0 1.5 1.0 0.5 1.5 1.5 1.5 1.5 1.5 1.5]; % coeficientes dos senos => 12 senoides
f = [1 2 3 5 10 20 40 80 160 320 440 880 550 650 750 280 110 950]; % frequencias dos senos => 12 senoides

x = m(1)*sin(w*f(1)*n) + m(2)*sin(w*f(2)*n) + m(3)*sin(w*f(3)*n) + m(4)*sin(w*f(4)*n) + m(5)*sin(w*f(5)*n) + m(6)*sin(w*f(6)*n) + ...
    + m(7)*sin(w*f(7)*n) + m(8)*sin(w*f(8)*n) + m(9)*sin(w*f(9)*n) + m(10)*sin(w*f(10)*n) + m(11)*sin(w*f(11)*n) + m(12)*sin(w*f(12)*n) + ...
    + m(13)*sin(w*f(13)*n) + m(14)*sin(w*f(14)*n) + m(15)*sin(w*f(15)*n) + m(16)*sin(w*f(16)*n) + m(17)*sin(w*f(17)*n) + m(18)*sin(w*f(18)*n);


% 1 => como a ordem do filtro afeta a resposta em frequencia
% 2 => como as frequencias de corte afetam a resposta em frequencia
% 3 => ilustrando filtragem do sinal e como o filtro afeta a TDF
% 4 => comparando meu butterworth com do matlab
p = 4; 
switch p

%% como a ordem do filtro afeta a resposta em frequencia
    case 1
        
fc1 = 0.2*fmax; 
fc2 = 0.6*fmax;

for i = 1:22%60 
%     [b,a] = butter(i,[fc1 fc2]/fmax); % [0.2 0.5]
%     [h,w] = freqz(b,a,fa);
    
    [z,p,k] = butter(i,[fc1 fc2]/fmax); sos = zp2sos(z,p,k);
    [h,w] = freqz(sos);
    
    plot(w*(1/pi)*fmax,20*log10(abs(h)));
    ylabel('dB (Magnitude)')
    ylim([-700 100])
    xlabel('Hz (Frequência)')
    xlim([0 fmax])
    grid on
    title('Ordem do filtro cada vez maior')
    pause(0.2)
end

%% como as frequencias afetam a resposta em frequencia
    case 2
        
for i = 1:30 % como as frequencias afetam
    [b,a] = butter(6, [10*i fmax-10*i]/fmax);
    freqz(b,a)
    subplot(2,1,1)
    ylim([-200 100])
    title('Estreitando a banda de frequência')
    pause(0.2)
end

%% ilustrando filtragem do sinal e como o filtro afeta a TDF
    case 3
        
fc1 = 0.1; 
fc2 = fmax;

for i = 1:1:fc2-2 % [1 50:50:500 501:0.5:fc2-20]
    [b,a] = butter(1, [fc1 fc2-i]/fmax,'bandpass');
    x_filt = filter(b,a,x);
    plot(t,x,'linewidth',1.0)
    title('Eliminando gradativamente frequências mais altas')
        ylim([-5 25])
%     ylim([-30 30])
    xlim([0 0.2])
    hold on
    grid on
    plot(t,x_filt,'linewidth',1.3)%,'color','r')
    ylim([-5 25])
%     ylim([-30 30])
    xlim([0 0.2])
    xlabel('tempo [s]')
    hold off
    grid on
    pause(0.00001)
end
legend('Sinal original','Sinal filtrado')

figure
y = abs(fft(x)); 
y_filt = abs(fft(x_filt));
subplot(2,1,1)
plot(0:fmax-1,y(1:0.5*length(y)),'linewidth',1.5)
xlabel('Frequência [Hz]')
title('Espectro do sinal original')
grid on
subplot(2,1,2)
plot(0:fmax-1,y_filt(1:0.5*length(y_filt)),'linewidth',1.5,'color',[0.8500 0.3250 0.0980])
title('Espectro do sinal filtrado')
grid on
xlabel('Frequência [Hz]')

%% comparando meu butterworth com do matlab
    case 4
        
fc1 = 0.1; % limite de freq inferior  =>   lembrando que menor freq do sinal é 1Hz
fc2 = 15; % limite de freq superior  =>   lembrando que fmax = 1000 Hz e fa = 2000 Hz
f1_norm = fc1/fmax; 
f2_norm = fc2/fmax;

ord = 1; % metade da ordem do filtro
[b,a] = butter(ord,[f1_norm f2_norm],'bandpass'); % a ordem é 2*ord
[z,p,k] = butter(ord,[f1_norm f2_norm],'bandpass'); sos = zp2sos(z,p,k);
ordem = 2*ord;

% yma = filter(b,a,x);
yma = sosfilt(sos,x);

yme = zeros(1,length(x));
for i = 1:length(x) % ordem+1:length(x)
    if i-ordem < 1 % condições iniciais => ainda não tem amostras suficientes pra atender à ordem do filtro
        xb = fliplr(x(1:i));
        ya = fliplr(yme(1:i));
        
        yme(i) = b(1:i)*xb' - a(1:i)*ya';
        
    else
        xb = fliplr(x(i-ordem:i)); % posicionando os elementos de x de forma adequada pro calculo
        ya = fliplr(yme(i-ordem:i)); % posicionando os elementos de y (realimentação) de forma adequada pro calculo

        yme(i) = b*xb' - a*ya'; % aqui é o cálculo de fato => eq. de diferenças
    
    end
    
end

% verificando

%
plot(t,x,'linewidth',0.5,'color',[0.9290    0.6940    0.1250])
hold on
%

plot(t,yma,'linewidth',1.6,'color',[0    0.4470    0.7410])
hold on
plot(t,yme,'linewidth',1.1,'color',[0.8500    0.3250    0.0980])
grid on
legend('Sinal original','filter.m','Cálculo na mão')%legend('filter.m','Cálculo na mão')
title('Verificando método de filtrar')
xlabel('tempo [s]')

end

%%
disp(sprintf('\n\n\n\nFim'))