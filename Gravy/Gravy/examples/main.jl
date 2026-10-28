using Gravy;

function main()
    # Create the universe
    uni = Universe(Particle[]);

    # Create two particles to test
    particle1 = Particle(1, [0.0, 0.0], [0.0, 0.0], [0.0, 0.0])
    particle2 = Particle(1, [0.0, 1.0], [0.0, 0.0], [0.0, 0.0]) # So a bit higher

    uni.particles = [particle1, particle2]

    # Launch main game loop
    for ii in 1:(100*2)
        Simulate!(uni, 0.01) # 1/100 s 
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()

end
