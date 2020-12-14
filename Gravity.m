function g=Gravity(Lat,h)

    omegae= 7.292115e-5;
    a= 6378137.0;
    b=6356752.3141;
    f=1/298.257222101;
    GM=3.986005e14;
    gamaa=9.7803267715;
    gamab=9.8321863685;
    m=omegae^2*a^2*b/GM;
    g_phi=(a*gamaa*cos(Lat)^2+b*gamab*sin(Lat)^2)/sqrt(a^2*cos(Lat)^2+b^2*sin(Lat)^2);  %考虑纬度
    g=g_phi*(1-2/a*(1+f+m-2*f*sin(Lat)^2)*h+3/a^2*h^2); %考虑大地高
end