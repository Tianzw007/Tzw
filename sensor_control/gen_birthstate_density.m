function X= gen_birthstate_density(birthid,num_par)
global lambda_b bar_x bar_B;
nx= length(bar_x{1}(:,1));
X= [];
j= birthid;
mixtureids = randsample(1:length(lambda_b{j}),num_par,true,lambda_b{j});
for c=1:length(lambda_b{j})
    num_par_c= sum(mixtureids==c);
    X=[ X repmat(bar_x{j}(:,c),[1 num_par_c])+bar_B{j}(:,:,c)*randn(nx,num_par_c)];
end
end