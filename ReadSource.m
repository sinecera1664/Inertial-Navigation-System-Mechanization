function [T,Gx,Gy,Gz,Ax,Ay,Az]=ReadSource(filepath)
    fip=fopen(filepath,'rb');   
    [dat,~]=fread(fip,'double');
    fclose(fip); %¹Ø±ÕÎÄ¼þ
    
    %{
    Result=reshape(dat,7,length(dat)/7);
    T=Result(1,:);
    Gx=Result(2,:);
    Gy=Result(3,:);
    Gz=Result(4,:);
    Ax=Result(5,:);
    Ay=Result(6,:);
    Az=Result(7,:);
    %}
     
    b=find(dat==91620.0);
    T=dat(b:7:end);
    Gx=dat(b+1:7:end);
    Gy=dat(b+2:7:end);
    Gz=dat(b+3:7:end);
    Ax=dat(b+4:7:end);
    Ay=dat(b+5:7:end);
    Az=dat(b+6:7:end);
    
end