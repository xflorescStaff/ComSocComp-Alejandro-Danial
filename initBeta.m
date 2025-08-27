function [beth, bets] = initBeta(all_params)
    p   = all_params.p;
    It  = all_params.It;


    if ( p >=0 || p>=1 )
        bets = randomOnes(It, p);
        beth = max(randomOnes(It,p/2), bets);
        return;
    end
    

    switch p
        case -1
            bets = randomOnes(It, 1);
            beth = max(randomOnes(It,1), bets);
        otherwise
            bets = randomOnes(It, 1);
            beth = max(randomOnes(It,1), bets);
    end
    
    
end