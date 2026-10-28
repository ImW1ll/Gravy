function Simulate!(universe::Universe, dt::Float64)
    # Forces accumulate, so reset them every step
    for parts in universe.particles
        parts.force = SVector(0.0, 0.0)
    end

    # For loop
    for parts in universe.particles 
       # We know that each particle has gravity as a function of each other
       for secondParts in universe.particles
           # So at iso location there's no force
            if parts === secondParts
                continue;
            end
            # Calculate the force between this and the other one
            # What is the distance
            distanceVector = secondParts.position - parts.position;
            distance = norm(distanceVector);
            distanceVectorNormal = distanceVector / distance;
            forceVector = G * parts.mass * secondParts.mass / distance^2 * distanceVectorNormal;
            parts.force += forceVector;
       end
    end

    # When all the forces are computed
    # we just integrate by one dt step
    for parts in universe.particles
        integrateForce!(parts, dt)
    end
end


function integrateForce!(p::Particle, dt::Float64)
    # Take acceleartion
    acceleration = p.force ./ p.mass

    p.velocity += acceleration .* dt
    p.position += p.velocity .* dt


end
