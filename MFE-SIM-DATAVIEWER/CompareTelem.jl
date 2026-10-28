using CSV, DataFrames
using Plots

currentPath = "/home/williamchayer/Documents/MFE/AB/ABTest"

# Load only CSV files containing velocity components.
files = filter(f -> endswith(f, ".csv"), readdir(currentPath))

dfs = Dict{String, DataFrame}()
for filename in files
    df = CSV.read(joinpath(currentPath, filename), DataFrame)
    missing_columns = setdiff(["vx", "vy"], names(df))
    if !isempty(missing_columns)
        @warn "Skipping CSV without required velocity columns" filename missing_columns
        continue
    end
    dfs[filename] = df
end

isempty(dfs) && error("No telemetry CSV files with vx and vy columns found in $currentPath")

# Create plot
p = plot(xlabel="Time step", ylabel="Velocity", title="vCar")

# Plot velocity for each object
for (filename, df) in sort(collect(dfs), by=first)
    vcar = hypot.(df.vx, df.vy)
    plot!(p, vcar, label=filename)
end

display(p)
sleep(50)
