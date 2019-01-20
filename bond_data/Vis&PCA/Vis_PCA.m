% data visualization

load('data_matlab.mat')
names = result.Properties.VariableNames;

% delete 30 year bond
% because no data in 2002 - 2006
result.DGS30 = [];

% 
R = rmmissing(result);

%
data = R(:,2:end);
data = data.Variables;
[m] = size(data);
%%
T = [1/12 1/4 1/2 1 2 3 5 7 10];
[X,Y] = meshgrid(T,1:m);

mesh(X,Y,data)
ylabel('date')
xlabel('Maturity')
zlabel('yield')
ax = gca;

timeline = R(:,1);
timeline = timeline.Variables;
year = timeline.Year;
dd = diff(year);
index = find(dd==1)+1;
dates = timeline(index);


ax.YTick = index;
ax.YTickLabel = cellstr(dates);
%% PCA

[coeff,score,latent,tsquared,explained,mu] = pca(data);
%% exp
subplot(1,2,1)
bar(explained);
title('Variance explained')
xlabel('components')

subplot(1,2,2)
plot(cumsum(explained),'-o');
title('Variance explained(accumulate)')
xlabel('components')
%% first 3 PCA
subplot(1,3,1)
plot(score(:,1));
title('component 1')
ylim([-5 10])

subplot(1,3,2)
plot(score(:,2));
title('component 2')
ylim([-5 10])

subplot(1,3,3)
plot(score(:,3));
title('component 3')
ylim([-5 10])
%% reconstruct surf 3 
n=3;
pn = score(:,1:n);
coefn = coeff(:,1:n);
recons = pn*coefn' + mean(data);
mesh(X,Y,recons)
ylabel('date')
xlabel('Maturity')
zlabel('yield')
title('surface(reconstructed)')
ax = gca;
ax.YTick = index;
ax.YTickLabel = cellstr(dates);
%% error abs
n=3;
pn = score(:,1:n);
coefn = coeff(:,1:n);
recons = pn*coefn' + mean(data);
error = abs((recons - data));
mesh(X,Y,error)

ylabel('date')
xlabel('Maturity')
zlabel('error(abs)')
title('error(abs)')
ax = gca;
ax.YTick = index;
ax.YTickLabel = cellstr(dates);

%% error abs
n=3;
pn = score(:,1:n);
coefn = coeff(:,1:n);
recons = pn*coefn' + mean(data);
error = abs((recons - data)./data);
mesh(X,Y,error)

ylabel('date')
xlabel('Maturity')
zlabel('error(rltv)(log)')
title('error(rltv)')
ax = gca;
ax.YTick = index;
ax.YTickLabel = cellstr(dates);
ax.ZScale = 'log';