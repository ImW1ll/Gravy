module Gravy

using StaticArrays
using LinearAlgebra

include("particle.jl")
include("universe.jl")
include("simulate.jl")

export Particle, Universe, Simulate!

end # module Gravy
