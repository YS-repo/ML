function xnew=perturbRoute2(x)

    [~, Tour]=sort(x);

    pSwap = 0.3;
    pReversion = 0.4;
    pInsertion = 0.3;
    p = [pSwap pReversion pInsertion];
    
    Method=RouletteWheelSelection(p);
    
    switch Method
        case 1
            NewTour=ApplySwap(Tour);
            
        case 2
            NewTour=ApplyReversion(Tour);
            
        case 3
            NewTour=ApplyInsertion(Tour);           
    end  
    xnew=zeros(size(x));
    
    xnew(NewTour)=x(Tour);
end