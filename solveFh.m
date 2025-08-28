function fhi = solveFh(all_params, beth, bets)

    di = all_params.Ti_c(:,1);
    ci = all_params.Ti_c(:,2);

    dl = di((beth==1)&(bets==0));
    cl = ci((beth==1)&(bets==0));

    fhl = ( sqrt(dl.*cl)/sum(sqrt(dl.*cl)) ) * all_params.Fhu;
    
    fhi = zeros(size(di));
    fhi((beth==1)&(bets==0)) = fhl;
end