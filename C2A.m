function A=C2A(C)

    A=[atan2(C(3,2),C(3,3)),atan2(-C(3,1),sqrt(C(3,2)^2+C(3,3)^2)),atan2(C(2,1),C(1,1))];
    A=A*180/pi;
end