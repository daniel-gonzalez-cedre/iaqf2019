% this script will generate the cleaned and merged data
%
%

seq = {'1MO','3MO','6MO','1','2','3','5','7','10','30'};
n = length(seq);

result = readtable('DGS1MO.csv');
disp('DGS1MO.csv')
for i = 2:n
    file_name = ['DGS' seq{i} '.csv'];
    disp(file_name);
    temp_table = readtable(file_name);
    result = outerjoin(result,temp_table,'Keys',1,'MergeKeys',true);
end

%% convert data type
names = result.Properties.VariableNames(2:end);
for i = 1:n
    temp_col = result(:,names{i});
    result(:,names{i}) = [];
    temp_col = temp_col.Variables;
    temp_col = str2double(temp_col);
    result = addvars(result,temp_col,'NewVariableNames',names{i});
end
%% delete rows with all NaN
[result,rm]= rmmissing(result,'MinNumMissing',10);

sum(rm) % num of rows been removed
%% output 
writetable(result,'data_cleaned.csv','Delimiter',',')

