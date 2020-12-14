clear;

%[T,Gx,Gy,Gz,Ax,Ay,Az]=ReadSource('A15_imu.bin');
[T,Gx,Gy,Gz,Ax,Ay,Az]=ReadSource('Data1.bin');
REFResult=ReadResult('Data1_PureINS.bin');
Result=zeros(10,length(T)-1);%存放结果
% 常数赋值
dt=0.005;%时间
% GRS80椭球参数
omegae=7.292115*10^-5;
a=6378137;b=6356752.3141;e2=1-(b/a)^2;
%初值

Lat=23.1373950708*pi/180;
Log=113.3713651222*pi/180;
h=2.175;
V=[0;0;0];
roll=0.0107951084511778*pi/180;
pitch=-2.14251290749072*pi/180;
heading=-75.7498049314083*pi/180;

%{
Lat=30.4447873882*pi/180;
Log=114.4718632144 *pi/180;
h=20.891;
V=[0;0;0];
roll=1.02097830 *pi/180;
pitch=-2.00633867 *pi/180;
heading=185.67186419 *pi/180;
%}

for i=1:length(T)-1
    if i==1
        Vold=[0;0;0];
        Cold=A2C([roll,pitch,heading]);
        Cold=SchmidtOrthogonalization(Cold);
        qold=A2q([roll,pitch,heading]);
        %外推
        Latold=Lat;Hold=h;
        Lat_half=Lat;h_half=h;
        V_half=[0;0;0];
    else
        Lat_half=Lat+(Lat-Latold)*0.5;
        h_half=h+(h-Hold)*0.5;
        V_half=V+(V-Vold)*0.5;
        Vold=V;
        Cold=C;
        %qold=q;
        Latold=Lat;%纬度
        Hold=h;%高程
    end
    dv=[Ax(i+1);Ay(i+1);Az(i+1)];
    theta=[Gx(i+1);Gy(i+1);Gz(i+1)];
    dvold=[Ax(i);Ay(i);Az(i)];
    thetaold=[Gx(i);Gy(i);Gz(i)];  
    Result(1,i)=T(i+1);
    
% 姿态更新
    Phi=theta+cross(thetaold,theta)/12;  
    C1=eye(3)+sin(norm(Phi))/norm(Phi)*SkewSM(Phi)+(1-cos(norm(Phi)))/norm(Phi)^2*(SkewSM(Phi))^2;
    Rm=a*(1-e2)/(1-e2*sin(Lat_half)^2)^1.5;   %子午圈曲率半径
    Rn=a/sqrt(1-e2*sin(Lat_half)^2);   %卯酉圈曲率半径
    omegaie=[omegae*cos(Lat_half);0;-omegae*sin(Lat_half)];
    omegaen=[V_half(2)/(Rn+h_half);-V_half(1)/(Rm+h_half);-V_half(2)*tan(Lat_half)/(Rn+h_half)];
    Zeta=(omegaie+omegaen)*dt;%n系等效旋转矢量
    C2=eye(3)+sin(norm(Zeta))/norm(Zeta)*SkewSM(Zeta)+(1-cos(norm(Zeta)))/norm(Zeta)^2*(SkewSM(Zeta))^2;
    C2=C2';
    C=C2*Cold*C1;
    C=SchmidtOrthogonalization(C);    
    Result(8:10,i)=C2A(C)';
    
    %四元数法
    %q1=[cos(0.5*norm(Phi));sin(0.5*norm(Phi)/(0.5*norm(Phi))*0.5*Phi)];
    %q2=[cos(0.5*norm(Zeta));-sin(0.5*norm(Zeta)/(0.5*norm(Zeta))*0.5*Zeta)];
    %q=quatmultiply(quatmultiply(q2',qold'),q1')';
    %q=q/norm(q);
    %C=q2C(q);
    
% 速度更新
    % 比力积分项
    dVfk=dv+0.5*cross(theta,dv)+1/12*(cross(thetaold,dv)+cross(dvold,theta));
    Vfk = (eye(3)-0.5*SkewSM(Zeta))*Cold*dVfk;
    Vgcork=([0;0;Gravity(Lat_half,h_half)]-cross(2*omegaie+omegaen,V_half))*dt;
    V=Vold+Vfk+Vgcork;
    Result(5:7,i)=V;
    
% 位置更新
    h=Hold-0.5*(V(3)+Vold(3))*dt;
    Rm=a*(1-e2)/(1-e2*sin(Latold)^2)^1.5;
    Lat=Latold+0.5*(V(1)+Vold(1))/(Rm+(h+Hold)/2)*dt;
    Rn=a/sqrt(1-e2*sin(0.5*(Latold+Lat))^2);
    Log=Log+0.5*(V(2)+Vold(2))/((Rn+(h+Hold)/2)*cos((Latold+Lat)/2))*dt;
    Result(2:4,i)=[Lat*180/pi,Log*180/pi,h]';
end

%MyDraw(Result,REFResult);
%WriteResult('A15OutPut.txt',Result);
%WriteResult('OutPut.txt',Result);
WriteResult('OutPut1.txt',REFResult);

