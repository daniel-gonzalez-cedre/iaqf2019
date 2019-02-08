tres = readtable('data_cleaned.csv');
corp = readtable('data_cleaned_cor.csv');
%% remove some data
name_t = tres.Properties.VariableNames(2:end);
tres(:,name_t{1}) = [];
tres(:,name_t{2}) = [];
tres(:,name_t{3}) = [];
tres(:,name_t{10}) = [];
%% combine
data_all = outerjoin(data_all,tres,'Keys',1,'MergeKeys',true);
%% NaN
[data_all,rm]= rmmissing(data_all);
sum(rm) % num of rows been removed
%%
% 1-3, 3-5, 5-7, 7-10 cor
% 1 2 3 5 7 10 tres
n=size(data_all);
n= n(1);
cs_mat = zeros(n,4);
maturity = [1 2 3 5 7 10]';
bound = [1 3;3 5;5 7;7 10];
for i = 1: n %dates
    %get the tres intepolation
    tres_temp= table2array(data_all(i,7:12))';
    
    xi = (1:.1:10)'; 
    yi = interp1q(maturity,tres_temp,xi); % interpolated values
    for j = 1:4 % integration
        corp_value = data_all(i,1+j); % start with 2
        a = bound(j,1);
        b = bound(j,2);
        tres_value = yi(xi>=a & xi<=b);
        cs_mat(i,j) = corp_value.Variables - mean(tres_value);
    end
end
%% 2table
credit_spread =  array2table(cs_mat,'VariableNames',{'CS13','CS35','CS57','CS710'});
credit_spread = addvars(credit_spread,data_all.DATE,'Before','CS13','NewVariableNames','DATE');
%% write csv
writetable(credit_spread,'credit_spread.csv','Delimiter',',')
