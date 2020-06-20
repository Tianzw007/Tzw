function[hat_X,hat_N]=Card_Stat_Est(q,X,w,hat_N,hat_X,k)
global x_dim;
hat_N(k)=sum((q>0.55));
no_of_targets = hat_N(k);
[~,idx]= sort(-q);
for j=1:no_of_targets
    targest= sum(X{idx(j)}.*repmat(transpose(w{idx(j)}),[x_dim 1]),2);
    hat_X{k}= [ hat_X{k} targest ];
end
end