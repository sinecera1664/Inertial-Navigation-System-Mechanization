function q=A2q(A)

    q0=cos(A(1)/2)*cos(A(2)/2)*cos(A(3)/2)+sin(A(1)/2)*sin(A(2)/2)*sin(A(3)/2); 
    q1=sin(A(1)/2)*cos(A(2)/2)*cos(A(3)/2)-cos(A(1)/2)*sin(A(2)/2)*sin(A(3)/2); 
    q2=cos(A(1)/2)*sin(A(2)/2)*cos(A(3)/2)+sin(A(1)/2)*cos(A(2)/2)*sin(A(3)/2); 
    q3=cos(A(1)/2)*cos(A(2)/2)*sin(A(3)/2)-sin(A(1)/2)*sin(A(2)/2)*cos(A(3)/2); 
    q=quatnormalize([q0,q1,q2,q3])';
end