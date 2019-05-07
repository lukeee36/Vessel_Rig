function result = Low_Pass_RC_2nd_Order(R1, R2, C1, C2)
    result = 1/(2*pi*sqrt(R1*R2*C1*C2));
end

% function res = 3db(fc, n)
%     res = fc*sqrt(2^(1/n)-1);
% end


