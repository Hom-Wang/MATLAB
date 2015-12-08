function [distance, dimension] = getDistance( distanceA, distanceB )

    dimension = size(distanceA, 2);

    sumPow = 0;
    for i = 1 : dimension
        sumPow = sumPow + ( distanceA(:, i) - distanceB(:, i) ).^2;
    end
    distance = sqrt(sumPow);

end
