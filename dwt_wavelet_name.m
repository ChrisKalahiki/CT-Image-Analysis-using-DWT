%DWT using Wavelet Name
load noisdopp;
[cA,cD]=dwt(noisdopp,'sym4');
xrec=idwt(cA,zeros(size(cA)),'sym4');
plot(noisdopp);
hold on
grid on
plot(xrec)
legend('Original', 'Reconstruction');