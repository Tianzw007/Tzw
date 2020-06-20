function X= gen_newstate_fn(X_old,V)
if isempty(X_old)
    X= []; return;
end
L= size(X_old,2);
X= zeros(4,L);
X(1,:)= X_old(1,:) + X_old(2,:);
X(2,:)= X_old(2,:) ;
X(3,:)= X_old(3,:) + X_old(4,:);
X(4,:)= X_old(4,:);
%?? noise process
X= X+ V;
end