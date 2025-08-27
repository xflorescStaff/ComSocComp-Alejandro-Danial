function fhi = initfh(all_params)

    di = all_params.Ti_c(:,1);
    ci = all_params.Ti_c(:,2);

    fhi = ( sqrt(di.*ci)/sum(sqrt(di.*ci)) ) * all_params.Fhu;
    
end