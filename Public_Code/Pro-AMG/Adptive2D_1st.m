function [BestOut,BestIn,BestECm,BestEDm,BestT] = Adptive2D_1st(I,mapList,Capacity)
% clear all
% clc
% I = double(imread('Lena.bmp'));
locCode = [10 12 14 16;
    5  7  9  15;
    2  4  8  13;
    1  3  6  11];  %第一象限标号，左下角为（0,0）
locCode = rot90(locCode,3);  %顺时针旋转90度
% 旋转后的locCode
%0:该点的入边为x,y;
%1:入边为x,y-1;
%2:x-1,y;
%3:x-1,y-1

%第一象限,仅考虑0到1的二维区间，共4个点
childin = cell(1,9);
childin(1,1:9) = {0, 1, 2, 3, 1, 2, 3, 3, 3}; % 二维映射的入射点表达形式 Sachnev
% Sa_in = childin;
% childin(1,1:9) = {0, 1, 2, 0, 1, 2, 3, 3, 3}; % 二维映射的入射点表达形式 Ou_tip

%-------------转化为二维映射的出射点表达形式

childout = cell(1,9);
for i = 1:9
    temp = childin{i}(1);
    [row,col] = find(locCode == i);
    switch temp
        case 0
        case 1
            col = col - 1;
        case 2
            row = row -1;
        case 3
            row = row - 1;
            col = col - 1;
    end
    startBin = locCode(row,col);
    childout{1,startBin} = [childout{1,startBin} i];
end

%----------Ehis
metricEC = zeros(1,4);
metricED = zeros(1,4);
for i = 1:4
    metricEC(i) = log2(length(childout{i}));
end

for i = 1:9
    temp = childin{i}(1);
    [row,col] = find(locCode == i);
    switch temp
        case 0
            tempED = 0;
        case 1
            col = col -1;
            tempED = 1;
        case 2
            row = row - 1;
            tempED = 1;
        case 3
            row = row - 1;
            col = col - 1;
            tempED = 2;
    end
    startBin = locCode(row,col);
    metricED(startBin) = metricED(startBin)+tempED;
end

for i = 1:4
    metricED(i) = metricED(i)/length(childout{i});
end

%%---------初始化直方图生成----------------------------------
%%----------------------------------------------------------
[A,B] = size(I);
Ex = zeros(1,A*B);
Ey = zeros(1,A*B);
NL = zeros(1,A*B);
xpos = zeros(1,A*B);
ypos = zeros(1,A*B);

index = 0;

for i = 2:2:A-2
    for j = 2:2:B-2
        
                         p1 = I(i-1,j);                   p7 = I(i-1,j+2);
        p2 = I(i,j-1);    x  = I(i,j);   p4 = I(i,j+1);
                         p3 = I(i+1,j);  y  = I(i+1,j+1);  p5 = I(i+1,j+2);
        p8 = I(i+2,j-1);                 p6 = I(i+2,j+1);
        px = ceil((p1+p2+p3+p4)/4);
        py = ceil((p3+p4+p5+p6)/4);
        index = index+1;
        Ex(index) = x - px;
        Ey(index) = y - py;
        NL(index) = abs(p1-p2)+abs(p2-p3)+abs(p3-p4)+abs(p4-p1)+abs(p3-p6)+abs(p6-p5)+abs(p5-p4)+abs(p4-p7)+abs(p3-p8);
        xpos(index) = i;
        ypos(index) = j;
    end
end

Ex = Ex(1:index);
Ey = Ey(1:index);
eX = Ex;
eY = Ey;
NL = NL(1:index); %都加1以便于后续数组表示, 1 <= nl <= maxNL + 1
xpos = xpos(1:index);
ypos = ypos(1:index);

%%%%%%%%%% {a,-a-1} --> a
Ex = abs(2*Ex+1);
Ex = (Ex-1)/2;
Ey = abs(2*Ey+1);
Ey = (Ey-1)/2;

%%%%%%%%%% E
E = zeros(1,2*index);
E2 = zeros(1,2*index);
xpos2 = zeros(1,2*index);
ypos2 = zeros(1,2*index);
NL2 = zeros(1,2*index);

for i = 1:index
    E(2*i-1) = Ex(i);
    E(2*i-0) = Ey(i);
    E2(2*i-1) = eX(i);
    E2(2*i-0) = eY(i);
    NL2(2*i-1) = NL(i);
    NL2(2*i) = NL(i);
    xpos2(2*i-1) = xpos(i);
    xpos2(2*i) = xpos(i)+1;
    ypos2(2*i-1) = ypos(i);
    ypos2(2*i) = ypos(i)+1;    
end

%%-----------------------------------------------------------
%%-----------------------------------------------------------

%初始化

BestEff = 999999;
BestEC = 0;
BestECm = metricEC;
BestEDm = metricED;
BestT= -1;
BestIn = childin;
BestOut = cell(1,9);
desT = -9999;

%----------计算熵
[Ehis,his2,his_1D,his3,~] = Gen2D_1st(E,E2,NL,max(NL)+1);
 

for T= 1:max(NL)+1
    T
    %--------生成直方图
    [Ehis,his2,his_1D,~,ED_shift] = Gen2D_1st(E,E2,NL,T);
    
    %---------------穷举所有可能映射

    for ii = 1:length(mapList(:,1))
            childin2 = mapList(ii,:);   
            
            [TempOut,TempEff,TempEC,flag,metricEC,metricED] = inToOut(childin2,Ehis,Capacity,ED_shift);            
            if TempEff < BestEff && flag == 1
                desT = 0;
                BestEff = TempEff;
                BestOut = TempOut;
                BestIn = childin2;
                BestECm = metricEC;
                BestEDm = metricED;
                BestEC = ii;
                BestT = T;
            end        
 
    end
    
    desT = desT + 1;
    if desT == 10
        break
    end
    
end

end