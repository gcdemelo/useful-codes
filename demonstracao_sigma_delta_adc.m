clear all
close all
clc

x3 = 0;
x4 = 0;
x5 = 0;
f1 = 0.5;
f2 = 10;
p = 1;
fator = 10E-4;
interval = fator:fator:10;
fs = (max(interval)/length(interval))^(-1);
window = 16;

for t = interval
    x1 = 0.5*sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);
    x2 = x1 - x5;
    x3 = x2 + x3;
    if x3 < 0
        x4 = 0;
        x5 = -1;
    else
        x4 = 1;
        x5 = 1;
    end
    modulated(p) = x4;
    p = p+1;
end

for i = 1:length(modulated)-window
    average(i) = mean(modulated(i:i+window-1));
end

% subplot(3,1,1)
% plot(sin(2*pi*f*interval))
% ylim([-1.3 1.3])
% grid on
% 
subplot(2,1,1)
plot(interval,modulated)
ylim([-0.3 1.3])
xlabel('seconds')
grid on

subplot(2,1,2)
plot(interval(1:length(average)),average)
ylim([-0.3 1.3])
xlabel('seconds')
grid on

y4 = abs(fft(modulated-mean(modulated))); y4 = y4(1:floor(0.5*length(y4)));
freq = 0:(fs/2)/length(y4):(fs/2)-((fs/2)/length(y4));
figure
plot(freq,y4)
xlim([-0.1*max(freq) max(freq)])
xlabel('Hz')
grid on