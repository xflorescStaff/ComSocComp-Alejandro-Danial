function v = randomOnes(N, p)
% RANDOMONES Generate a random 0/1 vector.
%   v = RANDOMONES(N, p) returns an N×1 vector of zeros and ones.
%   Each element is set to 1 with probability p (default = 0.5).

    if nargin < 2
        p = 0.5;  % default probability
    end

    v = rand(N,1) < p;
end