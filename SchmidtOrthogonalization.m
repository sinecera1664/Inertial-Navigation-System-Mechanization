function T = SchmidtOrthogonalization(A)

    T = zeros(3,3);
    T(:,1)=A(:,1);

    for i = 2 : 3
        for j = 1: i-1
            A(:,i)= A(:,i) - ((T(:,j)' * A(:,i))/(T(:,j)' * T(:,j))) * T(:,j);
        end
        T(:,i)=A(:,i);
    end

    % 向量单位化
    for i = 1: 3
        length=norm(T(:,i));
        for j = 1: 3
            T(j,i)= T(j,i)/ length;
        end
    end
    
end