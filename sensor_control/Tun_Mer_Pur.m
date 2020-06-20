function [L_update,N_update,q_update,w_update,X_update]=Tun_Mer_Pur(N_update,q_update,w_update,X_update)
global Tmax T_threshold;
%Prune
idx= find( q_update > T_threshold );
N_update2= N_update; q_update2= q_update; w_update2= w_update;
X_update2= X_update;
N_update= zeros(length(idx),1); q_update= zeros(length(idx),1);
X_update= cell(length(idx),1); w_update= cell(length(idx),1);
for i=1:length(idx)
    N_update(i)= N_update2(idx(i));
    q_update(i)= q_update2(idx(i));
    w_update{i}= w_update2{idx(i)};
    X_update{i}= X_update2{idx(i)};
end
L_update= length(idx);
%Truncation
if L_update > Tmax
    [~,idx]= sort(-q_update);
    N_update2= N_update; q_update2= q_update; w_update2= w_update;
    X_update2= X_update;
    N_update= zeros(Tmax,1); q_update= zeros(Tmax,1); w_update= cell(Tmax,1); X_update= cell(Tmax,1);
    for i=1:Tmax
        N_update(i)= N_update2(idx(i));
        q_update(i)= q_update2(idx(i));
        w_update{i}= w_update2{idx(i)};
        X_update{i}= X_update2{idx(i)};
    end
    L_update= Tmax;
end
end