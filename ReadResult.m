function Result=ReadResult(filepath)

    fip=fopen(filepath,'rb');  
    [dat,~]=fread(fip,'double');
    fclose(fip); %�ر��ļ�
    Result=reshape(dat,10,length(dat)/10);
end