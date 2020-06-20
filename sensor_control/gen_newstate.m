function X= gen_newstate(X_old)
    global B2;
    if isempty(X_old)
        X= [];
    else
        X= gen_newstate_fn(X_old,B2*randn(size(X_old)));
    end
end