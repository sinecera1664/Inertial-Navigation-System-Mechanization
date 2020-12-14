function C=A2C(A)

    x=A(1);y=A(2);z=A(3);
    C=zeros(3,3);
    C(1,1)=cos(y)*cos(z);
    C(1,2)=-cos(x)*sin(z)+sin(x)*sin(y)*cos(z);
    C(1,3)=sin(x)*sin(z)+cos(x)*sin(y)*cos(z);
    C(2,1)=cos(y)*sin(z);
    C(2,2)=cos(x)*cos(z)+sin(x)*sin(y)*sin(z);
    C(2,3)=-sin(x)*cos(z)+cos(x)*sin(y)*sin(z);
    C(3,1)=-sin(y);
    C(3,2)=sin(x)*cos(y);
    C(3,3)=cos(x)*cos(y);
end