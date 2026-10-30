module VPO

using Reexport
@reexport using CSV, DataFrames, JSON, PlotlyJS, Statistics

export Sim, loadsim, loadset

"""
One run. Channels are columns of `result.csv`: `sim.vx` (or `sim.ch_vx`).
`sim.config` and `sim.summary` are the parsed json files, `sim.data` the DataFrame.
"""
struct Sim
    name::String
    path::String
    data::DataFrame
    config::Dict{String,Any}
    summary::Dict{String,Any}
end

function Base.getproperty(sim::Sim, s::Symbol)
    s in fieldnames(Sim) && return getfield(sim, s)
    data = getfield(sim, :data)
    hasproperty(data, s) && return data[!, s]
    return data[!, "ch_$s"]
end

Base.show(io::IO, sim::Sim) = print(io, "Sim(\"", sim.name, "\")")

readjson(path) = isfile(path) ? JSON.parsefile(path; dicttype=Dict{String,Any}) : Dict{String,Any}()

"""
    loadsim(path)

Load the run folder at `path` (the one holding `result.csv`).
"""
function loadsim(path)
    Sim(basename(normpath(path)), abspath(path),
        CSV.read(joinpath(path, "result.csv"), DataFrame),
        readjson(joinpath(path, "config.json")),
        readjson(joinpath(path, "summary.json")))
end

"""
    loadset(path)

Load every run in the set folder at `path` that has a `result.csv`.
"""
function loadset(path)
    dirs = filter(d -> isfile(joinpath(d, "result.csv")), readdir(path; join=true))
    # natural order, so run-2 comes before run-10
    sort!(dirs; by=d -> [all(isdigit, m) ? lpad(m, 12, '0') : m for m in getfield.(eachmatch(r"\d+|\D+", basename(d)), :match)])
    return loadsim.(dirs)
end

end
