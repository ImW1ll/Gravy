
mutable struct Particle
    mass::Float64
    position::SVector{2, Float64}
    velocity::SVector{2, Float64}
    force::SVector{2, Float64}
end
