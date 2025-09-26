% This function increases the sampling frequency of a signal by any
% quantity.
%
% Author: Gabriel Chaves de Melo           gabrielchaves@alumni.usp.br
% Group of Neurophysics - UNICAMP - Brazil
% Created in 17 september 2025
% Latest update: ---
%
% It differs from matlab builtin function called upsample. In upsample
% matlab increases the number of samples by adding zeros in between
% original samples. Not only it compromises visualization, but it is also
% limited to increase in integer multiples of the original number.

% In this function the signals are transformed by means of FFT to the
% frequency domain. Then, zeros are added to the frequency spectrum above
% the current highest frequencies. Finally the signal is transformed back
% to time domain with the new samples. Because of numerical issues, the
% signal transformed back to the time domain looses some energy that is
% converted to undesired imaginary parts in time domain. Therefore, instead
% of using the real part alone, the magnitude of the complex value is used.
% Furthermore, because there are more samples in the resulting signal and
% the energy is the same, then the amplitude of the signals are lower. To
% correct this issue, the amplitudes of the signals are amplified the same
% amount as the sampling frequency. In the final output,the new upsampled
% signal preserves the original frequency content and amplitudes, but has a
% higher energy.

% Input x must be a column vector or a matrix in which different columns
% are different signals. It is expected that the signals have greater
% length than 1-second.


function [y] = change_fs(x,fs_original,fs_new)

dfs = fs_new - fs_original;

lines = length(x(:,1));
columns = length(x(1,:));

if dfs < 0 % downsampling
    error('This function does not perform downsampling. Please see decimate function instead.')
end


l_seconds = length(x(:,1))/fs_original;

x_fd = fft(x);

if floor(columns/2) == columns/2 % total number of samples is even
    x_fd_new = [x_fd(1:floor(0.5*lines),:) ; zeros(floor(dfs*l_seconds),columns) ; x_fd(1+floor(0.5*lines):end,:)];
else % total number of samples is odd
    x_fd_new = [x_fd(1:floor(0.5*lines),:) ; zeros(floor(dfs*l_seconds)+1,columns) ; x_fd(1+floor(0.5*lines):end,:)];
end

y_with_numerical_issues = ifft(x_fd_new);

y_sign = sign(real(y_with_numerical_issues));
y_mag = abs(y_with_numerical_issues);

y = y_sign.*y_mag;

y = (fs_new/fs_original).*y(1:end-1,:); % amplitude correction --- IT WAS ALWAYS GENERATING ONE SAMPLE MORE THAN I NEEDED (this has nothing to do with the amplitude correction)


end