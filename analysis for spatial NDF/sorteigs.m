function [V1,D1] = sorteigs(M)
    nx=size(M,1);nn=nx;
    [V,D] = eig(M);
    FV = fft(V);
    [~,pp] = max(FV,[],1);
    [~,idx]=sort(abs(pp - (nx/2+0.6)),'descend');
%     DD=real(diag(D));
%     [~,idx]=sort(DD(1:nn));
    V1(:,1:nn) = V(:,idx);D1=D;
    for i = 1:nn
        D1(i,i) = D(idx(i),idx(i));
    end