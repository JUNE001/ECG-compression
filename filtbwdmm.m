function [x2] = filtbwdmm(x,L1,L2,approach)

N = size(x,2);
x1 = zeros(size(x));
x2 = zeros(size(x));

flen1 = floor(L1/2);
flen2 = floor(L2/2);

if (strcmp(approach,'ma'))
    for j = 1:N,
        index = max(j-flen1,1):min(j+flen1,N);
        x1(:,j) = mean(x(:,index),2);
    end

    for j = 1:N,
        index = max(j-flen2,1):min(j+flen2,N);
        x2(:,j) = mean(x1(:,index),2);
    end
elseif (strcmp(approach,'md'))
    for j = 1:N,
        index = max(j-flen1,1):min(j+flen1,N);
        x1(:,j) = median(x(:,index),2);
        if j == 151
            j = 151;
        end
    end

    for j = 1:N,
        index = max(j-flen2,1):min(j+flen2,N);
        x2(:,j) = median(x1(:,index),2);
    end
end