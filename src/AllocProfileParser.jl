module AllocProfileParser

using JSON3

const FrameLocation = String # TODO: parse these out?

struct Alloc
    stack::Vector{FrameLocation}
    type::String
    size::Int
end

struct AllocProfile
    allocs::Vector{Alloc}
end

function parse_alloc_profile(filename::String)
    open(filename, "r") do io
        parse_alloc_profile(io)
    end
end
function parse_alloc_profile(stream::IOStream)
    parsed = JSON3.read(stream)

    out = AllocProfile([])

    allocs = parsed.allocs
    locations = parsed.locations

    types = parsed.types
    types_by_id = Dict{String,String}()
    for type in types
        types_by_id[type.id] = type.name
    end

    for alloc in allocs
        stack = [locations[loc+1].loc for loc in alloc.stack]
        type = types_by_id[alloc.type]
        size = alloc.size

        alloc = Alloc(
            stack,
            type,
            size
        )
        push!(out.allocs, alloc)
    end

    return out
end

include("pprof_export.jl")

end # module
