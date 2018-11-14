if strcmp(database,'CAVE')
[X,row,col,~]=InputData_CAVE(i);
else
if strcmp(database,'RS')
[X,row,col,~]=InputData_RS(i);
else
if strcmp(database,'realdata')
[X,row,col,~]=InputData_RealData(i);
else
if strcmp(database,'2D')
[X,row,col,~]=InputData_2D(i);
end
end
end
end