function MyDraw(Result,REFResult)
%MY_PLOT ���ƽ��ͼ
    figure(1)
    subplot(2,1,1);plot(Result(3,:),Result(2,:));
    title('�켣');xlabel('����');ylabel('γ��');
    subplot(2,1,2);plot(Result(1,:),Result(4,:));
    title('�߳�');xlabel('t(s)');ylabel('m');

    figure(2)
    subplot(2,2,1);plot(Result(1,:),Result(2,:)-REFResult(2,:));
    title( 'latitude');xlabel('t(s)');ylabel('deg');
    subplot(2,2,2);plot(Result(1,:),Result(3,:)-REFResult(3,:));
    title('longitude');xlabel('t(s)');ylabel('deg');
    subplot(2,2,3);plot(Result(1,:),Result(4,:)-REFResult(4,:));
    title('altitude');xlabel('t(s)');ylabel('m');
    subplot(2,2,4);plot(Result(1,:),((1.1*(Result(2,:)-REFResult(2,:))*10.^5).^2+(1*(Result(3,:)-REFResult(3,:))*10.^5).^2).^0.5);
    title('ˮƽ�������');xlabel('t(s)');ylabel('m');

    figure(3)
    subplot(3,1,1);plot(Result(1,:),Result(5,:)-REFResult(5,:));
    title('N');xlabel('t(s)');ylabel('m/s');
    subplot(3,1,2);plot(Result(1,:),Result(6,:)-REFResult(6,:));
    title('E');xlabel('t(s)');ylabel('m/s');
    subplot(3,1,3);plot(Result(1,:),Result(7,:)-REFResult(7,:));
    title('D');xlabel('t(s)');ylabel('m/s');

    figure(4)
    subplot(3,1,1);plot(Result(1,:),Result(8,:)-REFResult(8,:));
    title('roll');xlabel('t(s)');ylabel('deg');
    subplot(3,1,2);plot(Result(1,:),Result(9,:)-REFResult(9,:));
    title('pitch');xlabel('t(s)');ylabel('deg');
    subplot(3,1,3);plot(Result(1,:),Result(10,:)-REFResult(10,:));
    title('heading');xlabel('t(s)');ylabel('deg');
end

