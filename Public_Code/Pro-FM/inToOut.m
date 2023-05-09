function [childout,eff,EC,flag,metricEC,metricED] = inToOut(childin,Ehis,Capacity,ED_shift)
flag = 0;
EC = 0;
eff = 99999999999999;

locCode = [10 12 14 16;
           5  7  9  15;
           2  4  8  13;
           1  3  6  11];  %第一象限标号，左下角为（0,0）
locCode = rot90(locCode,3);  %顺时针旋转90度

%---------还未算shift的失真


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
    
    if row < 1 || col < 1
        childout = cell(1,9);
        return
    end
    
    startBin = locCode(row,col);
    childout{1,startBin} = [childout{1,startBin} i];
end

%----------Ehis
metricEC = zeros(1,9);
metricED = zeros(1,9);
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
    
    if row < 1 || col < 1
        childout = cell(1,9);
        return
    end
    
    startBin = locCode(row,col);
    metricED(startBin) = metricED(startBin)+tempED;
end

for i = 1:4
    metricED(i) = metricED(i)/length(childout{i});
end

metricEC = metricEC(1:4);
metricED = metricED(1:4);

%--------计算总EC/ED

eff = (sum(Ehis.*metricED)+ED_shift)/sum(Ehis.*metricEC);
if sum(Ehis.*metricEC) >= Capacity
    EC = sum(Ehis.*metricEC);
    flag = 1;
end

end