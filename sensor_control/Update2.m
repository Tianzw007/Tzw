function[q_update]=Update2(N_predict,L_predict,w_predict,X_predict,q_predict,Z)
global clutterpdf T_threshold lambda_c x_dim;
m= size(Z,2);
q_update = zeros(L_predict+m,1) ;
N_pseudo= sum(N_predict); %number of particles in pseudo PHD
X_pseudo= zeros(x_dim,N_pseudo);
w_pseudo1= zeros(N_pseudo,1);
w_pseudo2= zeros(N_pseudo,1);
start_pt= 1;
%construct pseudo-PHD
for j=1:L_predict
    end_pt= start_pt+N_predict(j)-1;
    w_temp= w_predict{j}.*compute_pD(X_predict{j});
    X_pseudo(:,start_pt:end_pt)= X_predict{j};
    w_pseudo1(start_pt:end_pt)= q_predict(j)/(1-q_predict(j)*sum(w_temp))*w_predict{j};
    w_pseudo2(start_pt:end_pt)= q_predict(j)*(1-q_predict(j))/((1-q_predict(j)*sum(w_temp))^2)*w_predict{j};
    start_pt= end_pt+1;
end
%--update
clear q_update N_update w_update X_update;
%legacy
for j=1:L_predict
    w_temp= w_predict{j}.*compute_pD(X_predict{j});
    q_update(j)= q_predict(j)*((1-sum(w_temp))/(1-q_predict(j)*sum(w_temp)));
end
count=L_predict;
%measurement updated
for ell=1:m
    pD_temp= compute_pD(X_pseudo);
    gz_temp= transpose(compute_likelihood(Z(:,ell),X_pseudo));
    qtrack= sum(pD_temp.*gz_temp.*w_pseudo2)/(lambda_c*clutterpdf+sum(pD_temp.*gz_temp.*w_pseudo1));
    %only compute tracks that are strong enough
    if qtrack > T_threshold
        count=count+1;
        q_update(count)= qtrack;
    end
end
end
