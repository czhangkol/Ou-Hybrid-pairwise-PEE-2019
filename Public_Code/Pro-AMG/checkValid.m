function [flag,childout] = checkValid(childin,locCode)
flag = 1;
childout = cell(1,9);
for i = 1:9
    temp = childin{i}(1);
    [row,col] = find(locCode == i);
    switch temp
        case 0
        case 1
            col = col -1;
            
        case 2
            row = row - 1;
        case 3
            row = row - 1;
            col = col - 1;
    end
    
    if row < 1 || col < 1
        flag = 0;
        break
    end
    
    startBin = locCode(row,col);
    childout{1,startBin} = [childout{1,startBin} i];
end

%判断是否存在多对一的映射, 并且排除仅自旋的映射
status = zeros(1,9);
index = 1;
for i = 1:9
    
%     if length(childout{i}) == 1 && i == childout{i}
%         flag = 0;
%     end
    
    for j = 1:length(childout{i})
    index = childout{i}(j);
    status(index) = status(index)+1;
    end
    
    if status(index) < 1
        flag = 0;
    end
    if status(index) >= 2
        flag = 0;
    end
end

for i = 1:4
      
    if isempty(childout{i})
        flag = 0;
    end

end


end