function[X_s,Y_s,mini]=Sensor_Control(L,q,N,w,X,k)
global C_posn Sen ;
cost=zeros(1,17);
next_x=zeros(1,17);
next_y=zeros(1,17);
X_s=Sen(1);
Y_s=Sen(2);
next_x(1,1) = X_s;
next_y(1,1) = Y_s;
num_controls = 1;
% motion
stepsize = 50;
ang_steps = 8;
ang_incr = 2*pi/ang_steps;
rng_steps = 2;
for j=1:rng_steps
    for i=1:ang_steps
        num_controls = num_controls + 1;
        angle = (i-1)*ang_incr;
        Rnge = j*stepsize;
        next_x(1,num_controls) = X_s + Rnge*cos(angle);
        next_y(1,num_controls) = Y_s + Rnge*sin(angle);
    end
end
hat_N=sum((q>0.55));
no_of_targets = hat_N;
hat_X=zeros(4,hat_N);
[~,idx]= sort(-q);
for j=1:no_of_targets
    hat_X(:,j) = sum(X{idx(j)}.*repmat(transpose(w{idx(j)}) ,[4 1]),2);
end

for n=1:num_controls
    P= C_posn*hat_X;
    Rng = sqrt((P(1,:)-(next_x(1,n).*(ones(size(P(1,:)))))).^2+ (P(2,:)-(next_y(1,n).*(ones(size(P(2,:)))))).^2);%距离关系
    Brg = atan2 (P(2,:)-((next_y(1,n).*(ones(size(P(2,:)))))) , (P(1,:)-((next_x(1,n).*(ones(size(P(1,:))))))));%方位角关系
    Z_L_z = [Rng ; Brg];
    cost(1,n) = Cost_Calc(N,L,w,X,q,Z_L_z);
end
mini = min(cost);
if k==1
    mind = 12;
else
    [mind] = find(cost==mini);
end
X_s = next_x(mind);
Y_s = next_y(mind);
end
    