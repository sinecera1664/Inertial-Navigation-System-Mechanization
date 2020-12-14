clear;
Result=load('A15OutPut.txt');

A=load('POS.txt');
REFResult=A(:,2:11);

%plot(Result(:,1),Result(:,2)-REFResult(:,2));
figure(1);
subplot(4,1,1);plot(Result(:,1),Result(:,2)-REFResult(:,2));
title( 'latitude');xlabel('t(s)');ylabel('deg');
subplot(4,1,2);plot(Result(:,1),Result(:,3)-REFResult(:,3));
title('longitude');xlabel('t(s)');ylabel('deg');
%figure(2);
subplot(4,1,4);plot(Result(:,1),Result(:,4)-REFResult(:,4));
title('altitude');xlabel('t(s)');ylabel('m');
subplot(4,1,3);plot(Result(:,1),((1.1*(Result(:,2)-REFResult(:,2))*10.^5).^2+(1*(Result(:,3)-REFResult(:,3))*10.^5).^2).^0.5);
title('水平距离误差');xlabel('t(s)');ylabel('m');
