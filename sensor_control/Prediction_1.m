function [L_predict,q_predict,N_predict,w_predict,X_predict]=Prediction_1(L_b)
global Lmax Lmin bar_q;
clear q_predict N_predict w_predict X_predict;
L_predict= L_b;
N_predict = zeros(L_b,1);
w_predict = cell(L_b,1);
X_predict = cell(L_b,1);
q_predict= bar_q;
for j=1:L_b
    N_predict(j)= max(round(bar_q(j)*Lmax),Lmin);
    w_predict{j}= ones(N_predict(j),1)/N_predict(j);
    X_predict{j}= gen_birthstate_density(j,N_predict(j));
end
end