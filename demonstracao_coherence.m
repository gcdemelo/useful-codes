close all
clear
clc

%% LEIA O TEXTO ABAIXO!!!!!!!!!!!!!!!!!

% ESTÁ SEMPRE DANDO iCOH COM SINAL NEGATIVO ONDE É ESPERADO QUE DÊ ALGUMA
% COISA MESMO. PORÉM APARECEM OUTROS PICOS POSITIVOS AS VEZES. NO GERAL, OS
% RESULTADOS SÃO BONS QUANDO SE TEM MUITAS ÉPOCAS.


fs = 2^7; % 2^7=128;; 2^8=256; 2^9=512; 2^10=1024;

duration = 120*8; % [s]

t = 1/fs:1/fs:duration;
f = 0:fs/(length(t)/duration):fs-fs/(length(t)/duration);

noise_factor = 0.3;


%% criando sinal estacionário 1

% frequencias do sinal 1
f1 = [2 60 floor(rand(1)*fs/2.3) floor(rand(1)*fs/2.3)];

% amplitudes de cada frequencia
a1 = [1 1 1 1];

% nivel DC
dc1 = 0;

% fases das frequencias (em graus)
phase1 = [0 0 0 0];

% componentes do sinal 1
s1 = dc1 + a1(1).* sin(2*pi*f1(1).*t + 2*pi*phase1(1)/360);
s2 = dc1 + a1(2).* sin(2*pi*f1(2).*t + 2*pi*phase1(2)/360);
s3 = dc1 + a1(3).* sin(2*pi*f1(3).*t + 2*pi*phase1(3)/360);
s4 = dc1 + a1(4).* sin(2*pi*f1(4).*t + 2*pi*phase1(4)/360);

% sinal final 1
noise = wgn(1,length(t),1);
x1 = s1+s2+s3+s4 + noise_factor*noise./max(noise);


%% criando sinal estacionário 2

% frequencias do sinal 2
f2 = [2 60 floor(rand(1)*fs/2.3) floor(rand(1)*fs/2.3)];

% amplitudes de cada frequencia
a2 = [1 1 1 1];

% nivel DC
dc2 = 0;

% fases das frequencias (em graus)
phase2 = [0 90 45 0];

% componentes do sinal 2
s1 = dc2 + a2(1).* sin(2*pi*f2(1).*t + 2*pi*phase2(1)/360);
s2 = dc2 + a2(2).* sin(2*pi*f2(2).*t + 2*pi*phase2(2)/360);
s3 = dc2 + a2(3).* sin(2*pi*f2(3).*t + 2*pi*phase2(3)/360);
s4 = dc2 + a2(4).* sin(2*pi*f2(4).*t + 2*pi*phase2(4)/360);

% sinal final 2
noise = wgn(1,length(t),1);
x2 = s1+s2+s3+s4 + noise_factor*noise./max(noise);


%% frequency spectrum

overlap = 0.5;

for i = 1:duration*(1/overlap)-1
    window_size = length(t)/duration;
    H = hamming(window_size);
    
    ss1 = x1(1+(i-1)*0.5*window_size:i*window_size-(i-1)*0.5*window_size).*H';
    y1(i,:) = fft(ss1);
    Y_1(i,:) = abs(y1(i,:));
    

    
    PHASE_1(i,:) = 180*(1/pi)*angle(y1(i,:));

    
    ss2 = x2(1+(i-1)*0.5*window_size:i*window_size-(i-1)*0.5*window_size).*H';
    y2(i,:) = fft(ss2);
    Y_2(i,:) = abs(y2(i,:));
    

    
    PHASE_2(i,:) = 180*(1/pi)*angle(y2(i,:));


end

Y_1_av = mean(Y_1);
Y_2_av = mean(Y_2);

%% coherence, coherency and iCoh

S12 = y1.*conj(y2); S12_av = mean(S12);
S11 = y1.*conj(y1); S11_av = mean(S11);
S22 = y2.*conj(y2); S22_av = mean(S22);

PHASE_1_av = mean(PHASE_1);
PHASE_2_av = mean(PHASE_2);

den0 = S11_av.*S22_av;
den = den0.^0.5;
C12 = S12_av./den; % coherency;

Coh12 = abs(C12); % coherence

iCoh12 = imag(C12); % imaginary part of coherence
% iCoh12 = iCoh12.*((check1+check2)>0);

%%

fticks = unique(sortrows([f1 f2 fs/2]'));
fticks = fticks';

phaseticks = unique(sortrows((phase2-phase1)'));
phaseticks = phaseticks';

figure(1)

subplot(2,1,1)
plot(f,Coh12)
grid on
xlim([f(1) f(end)])
xticks(fticks)
title('Coh values')

subplot(2,1,2)
plot(f,iCoh12)
grid on
xlim([f(1) f(end)])
xticks(fticks)
title('iCoh values')

%%

figure(2)

subplot(5,1,1)
plot(t(1:fs),x1(1:fs))
hold on
plot(t(1:fs),x2(1:fs))
grid on
xlim([t(1) t(fs)])
title('x1 and x2 in time domain (just the 1st second)')

subplot(5,1,2)
plot(f,Y_1_av)
grid on
xlim([f(1) f(end)])
title('Magnitude of y1 (x1 spectrum)')
xticks(fticks)

subplot(5,1,4)
plot(f,PHASE_1_av)
grid on
xlim([f(1) f(end)])
title('Phase of y1 (x1 spectrum)')
xticks(fticks)
yticks([-180 -90 0 90 180])

subplot(5,1,3)
plot(f,Y_2_av)
grid on
xlim([f(1) f(end)])
title('Magnitude of y2 (x2 spectrum)')
xticks(fticks)

subplot(5,1,5)
plot(f,PHASE_2_av)
grid on
xlim([f(1) f(end)])
title('Phase of y2 (x2 spectrum)')
xticks(fticks)
yticks([-180 -90 0 90 180])

%%

figure(3)

plot(f,PHASE_2_av-PHASE_1_av)
grid on
xlim([f(1) f(end)])
title('Phase difference (y2-y1)')
xticks(fticks)
yticks(phaseticks)
ylim([-180 180])

%%

% matlab function for comparison purposes

a = mscohere(x1,x2,window_size);
b = downsample([0; a],2); b = b';
b = [b(1:end-1) fliplr(b(1:end-1))];
figure(1); subplot(2,1,1); hold on; plot(f,b,'--')








%% criando sinal transiente
% ff = [1 3 6 12 24];
% aa = [1 4 6 0.5 1];
% 
% ft = ...
% [
%     ff(1)*ones(1,floor(0.2*length(t))) ... 
%     ff(2)*ones(1,floor(0.2*length(t))) ...
%     ff(3)*ones(1,floor(0.2*length(t))) ...
%     ff(4)*ones(1,floor(0.2*length(t))) ...
%     ff(5)*ones(1,floor(0.2*length(t)))
% ];
% 
% At = ...
% [
%     aa(1)*ones(1,floor(0.2*length(t))) ... 
%     aa(2)*ones(1,floor(0.2*length(t))) ...
%     aa(3)*ones(1,floor(0.2*length(t))) ...
%     aa(4)*ones(1,floor(0.2*length(t))) ...
%     aa(5)*ones(1,floor(0.2*length(t)))
% ];
% 
% B = 0;
% 
% x = B + At.* sin(2*pi*ft.*t);