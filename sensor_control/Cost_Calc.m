function[Cost_Func]=Cost_Calc(N,L,w,X,q,Z)
Cost_Func = 0;
q_update = Update2(N,L,w,X,q,Z);
Cost_Func = Cost_Func + sum(q_update.*(1-q_update));
end