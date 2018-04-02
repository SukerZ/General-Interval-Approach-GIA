function [L,R]=yuchuli(L,R)
    index=find(isnan(L)+isnan(R)); % remove incomplete data
    L(index)=[];R(index)=[];
    %% Bad data processing, see Equation (1) in paper
    for i=length(L):-1:1
        if L(i)<0 | L(i)>10 | R(i)<0 | R(i)>10 |  R(i)<=L(i) | R(i)-L(i)>=10
            L(i) = [];R(i) = [];
        end
    end
    nums=length(L); % n'
    if nums<1
      return
    end
    %% Outlier processing
    intLeng = R-L;left = sort(L);right = sort(R);leng = sort(intLeng);
    NN1 = floor(nums * 0.25);NN2 = floor(nums * 0.75);
    % Compute Q(0.25), Q(0.75) and IQR for left-ends
    if NN1<1
        return
    end
    QL25 = left(NN1)*(1-rem(0.25*nums,1)) + left(NN1+1)*rem(0.25*nums,1);
    QL75 = left(NN2)*(1-rem(0.75*nums,1)) + left(NN2+1)*rem(0.75*nums,1);
    LIQR = QL75 - QL25;
    % Compute Q(0.25), Q(0.75) and IQR for right-ends.
    QR25 = right(NN1)*(1-rem(0.25*nums,1)) + right(NN1+1)*rem(0.25*nums,1);
    QR75 = right(NN2)*(1-rem(0.75*nums,1)) + right(NN2+1)*rem(0.75*nums,1);
    RIQR = QR75 - QR25;
    % outlier processing for L and R
    for i=nums:-1:1
        if L(i)<QL25-1.5*LIQR | L(i)>QL75+1.5*LIQR | R(i)<QR25-1.5*RIQR | R(i)>QR75+1.5*RIQR
            L(i) = [];R(i) = [];intLeng(i)=[];
        end
    end
    n1=length(L);%n''
    % Compute Q(0.25), Q(0.75) and IQR for interval length.
    NN1 = floor(n1 * 0.25);NN2 = floor(n1 * 0.75);
     if NN1<1
        return
    end
    QLeng25 = leng(NN1)*(1-rem(0.25*n1,1)) + leng(NN1+1)*rem(0.25*n1,1);
    QLeng75 = leng(NN2)*(1-rem(0.75*n1,1)) + leng(NN2+1)*rem(0.75*n1,1);
    lengIQR = QLeng75 - QLeng25;
    % outlier processing for interval length
    for i=n1:-1:1
        if intLeng(i)<QLeng25-1.5*lengIQR | intLeng(i)>QLeng75+1.5*lengIQR
            L(i) = [];R(i) = [];intLeng(i)=[];
        end
    end
    n1=length(L);%m'
    %% Tolerance limit processing, see Equation (3) in paper
    meanL = mean(L);stdL = std(L);meanR = mean(R);stdR = std(R);
    K=[32.019 32.019 8.380 5.369 4.275 3.712 3.369 3.136 2.967 2.839...
    2.737 2.655 2.587 2.529 2.48 2.437 2.4 2.366 2.337 2.31...
    2.31 2.31 2.31 2.31 2.208];
    if n1<1
       return
    end
    k=K(min(n1,25));
    if k<1
      return
    end
    %% Tolerance limit processing for L and R
    for i=n1:-1:1
        if L(i)<meanL-k*stdL | L(i)>meanL + k*stdL | R(i)<meanR-k*stdR | R(i)>meanR + k*stdR
            L(i) = [];R(i) = [];intLeng(i)=[];
        end
    end
    n1=length(L);%m+
    %% Tolerance limit processing for interval length
    meanLeng = mean(intLeng);stdLeng = std(intLeng);
    k=min([K(min(n1,25)),meanLeng/stdLeng,(10-meanLeng)/stdLeng]);
    for i=n1:-1:1
        if  intLeng(i)<meanLeng-k*stdLeng | intLeng(i)>meanLeng + k*stdLeng
            L(i)=[];R(i)=[];intLeng(i)=[];
        end
    end
    n1=length(L);%m''
    %% Reasonable interval processing, see Equation (4)-(6) in paper
    meanL = mean(L);stdL = std(L);meanR = mean(R);stdR = std(R);
    % Determine sigma*
    if stdL==stdR
        barrier = (meanL + meanR)/2;
    elseif stdL==0
        barrier = meanL+0.01;
    elseif stdR==0
        barrier = meanR-0.01;
    else
        barrier1 =(meanR*stdL^2-meanL*stdR^2 + stdL*stdR*sqrt((meanL-meanR)^2+2*(stdL^2-stdR^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
        barrier2 =(meanR*stdL^2-meanL*stdR^2 - stdL*stdR*sqrt((meanL-meanR)^2+2*(stdL^2-stdR^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
        if  barrier1>=meanL & barrier1<=meanR
            barrier = barrier1;
        else
            barrier = barrier2;
        end
    end
    % Reasonable interval processing
    for i=n1:-1:1
        if L(i)>=barrier | R(i)<= barrier | L(i)<2*meanL-barrier | R(i)>2*meanR-barrier
            L(i) = [];R(i) = [];intLeng(i)=[];
        end
    end
end