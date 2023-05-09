function [mapList] = GenList
mapList = cell(4096,9);

locCode = [10 12 14 16;
    5  7  9  15;
    2  4  8  13;
    1  3  6  11];  %第一象限标号，左下角为（0,0）
locCode = rot90(locCode,3);  %顺时针旋转90度
%0:该点的入边为x,y;
%1:入边为x,y-1;
%2:x-1,y;
%3:x-1,y-1

childin = cell(1,9);
childin(1,1:9) = {0, 1, 2, 3, 1, 2, 3, 3, 3}; % 二维映射的入射点表达形式 Sachnev
childin(1,1:9) = {0, 1, 2, 0, 1, 2, 3, 3, 3}; %pairwise PEE 映射
index = 1;
mapList(index,:) = childin;
mapList = mapList(1:index,:);
 

end