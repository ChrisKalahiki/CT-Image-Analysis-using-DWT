%DWT using Wavelet and Scaling Filters
load noisdopp;
[LoD,HiD] = wfilters('bior3.5','d');
[cA,cD] = dwt(noisdopp,LoD,HiD);
len = length(noisdopp);
fb = dwtfilterbank('SignalLength', len, 'Wavelet', 'bior3.5');
[lo,hi] = filters(fb);
disp('Lowpass Analysis Filter');
[lo(:,1) LoD']
disp('Highpass Analysis Filters');
[hi(:,1) HiD']
[psidft,f,phidft] = freqz(fb);
level = 1;
plot(f(len/2+1:end),abs(phidft(level,len/2+1:end)))
hold on
plot(f(len/2+1:end),abs(psidft(level,len/2+1:end)))
grid on
legend('Scaling Filter','Wavelet Filter')
title('First-Level One-sided Frequency Responses')
xlabel('Normalized Frequency (cycles/sample)')
ylabel('Magnitude')