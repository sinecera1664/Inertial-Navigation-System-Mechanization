function  WriteResult(filename,result)

    fid = fopen(filename,'w');
    fprintf(fid,'%.3f %10.8f %10.8f %10.8f %10.8f %10.8f %10.8f %10.8f %10.8f %10.8f\n',result);
    fclose(fid);
end

