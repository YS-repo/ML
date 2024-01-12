function [theCityRoute, PSO_route] = genRoute(particle)
    numCities = length(particle.Position);
    theCityRoute = particle.Sol.Tour;
    PSO_route = particle.Position;

    for i = 1:2
    
    randIndex1 = randi(numCities);
    alreadyChosen = true;
    while alreadyChosen == true
        randIndex2 = randi(numCities);
        if randIndex2 ~= randIndex1
            alreadyChosen = false;
        end
    end
    dummy = theCityRoute(randIndex1);
    theCityRoute(randIndex1) = theCityRoute(randIndex2);
    theCityRoute(randIndex2) = dummy;
    
    dummy_pso = PSO_route(theCityRoute(randIndex1));
    PSO_route(randIndex1) = PSO_route(theCityRoute(randIndex2));
    PSO_route(theCityRoute(randIndex2)) = dummy_pso;
    end

end
