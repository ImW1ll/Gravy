using Gravy
using GLMakie

function main()
    uni = Universe(Particle[])

    for r in (1.0, 1.6, 2.3, 3.0)
        angle = 2pi * rand()
        position = r .* [cos(angle), sin(angle)]
        velocity = (1 / sqrt(r)) .* [-sin(angle), cos(angle)]
        push!(uni.particles, Particle(sunMass * 1e-4, position, velocity, [0.0, 0.0]))
    end

    points = Observable([Point2f(p.position) for p in uni.particles])
    sizes = [p === uni.particles[1] ? 25 : 10 for p in uni.particles]

    fig = Figure(size = (800, 800))
    ax = Axis(fig[1, 1], aspect = DataAspect(), limits = (-3.5, 3.5, -3.5, 3.5))
    scatter!(ax, points, markersize = sizes, color = 1:length(uni.particles), colormap = :plasma)
    display(fig)

    dt = 0.001
    stepsPerFrame = 10
    while isopen(fig.scene)
        for ii in 1:stepsPerFrame
            Simulate!(uni, dt)
        end
        points[] = [Point2f(p.position) for p in uni.particles]
        sleep(1 / 60)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
