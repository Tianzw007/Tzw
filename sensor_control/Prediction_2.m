function [L_predict,q_predict,N_predict,w_predict,X_predict]=Prediction_2(L_b,L_update,w_update,q_update,N_update,X_update)
global Lmax Lmin bar_q;
clear q_predict N_predict w_predict X_predict;
L_predict = L_b+ L_update;
q_predict = zeros(L_b+L_update,1);
q_predict(1:L_b) = bar_q;
N_predict = zeros(L_b+L_update,1);
w_predict = cell(L_b+L_update,1);
X_predict = cell(L_b+L_update,1);
for j=1:L_b
    N_predict(j)= max(round(bar_q(j)*Lmax),Lmin);
    w_predict{j}= ones(N_predict(j),1)/N_predict(j);
    X_predict{j}= gen_birthstate_density(j,N_predict(j));
end
count= L_b;
for j=1:L_update
    count= count+ 1;
    w_temp= w_update{j}.*compute_pS(X_update{j});
    q_predict(count)= q_update(j)* sum(w_temp);
    N_predict(count)= N_update(j);
    w_predict{count}= w_temp/sum(w_temp);
    X_predict{count}= gen_newstate(X_update{j});
end
end