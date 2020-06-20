function g= compute_likelihood(z,X)
global C_posn Sen;
P= C_posn*X;
M= size(X,2);
Phi= zeros(2,M);

Phi(1,:)= sqrt((P(1,:)-(Sen(1,:).*(ones(size(P(1,:)))))).^2+ (P(2,:)-(Sen(2,:).*(ones(size(P(2,:)))))).^2);
Phi(2,:)= atan2 ((P(2,:)-(Sen(2,:).*(ones(size(P(2,:)))))),(P(1,:)-(Sen(1,:).*(ones(size(P(1,:)))))));
sigma= diag([1+0.00005*sum(sum(Phi(1,:).*Phi(1,:))) ; (pi/180)*2]);
Nomin= repmat(z,[1 M])-Phi;
InvDenom= diag(1./diag((sigma)));
e_sq= sum((InvDenom*Nomin).^2);
g= exp( -e_sq/2 )/(sqrt(2*pi)*(prod(diag((sigma)))));
end