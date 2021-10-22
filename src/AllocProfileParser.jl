module AllocProfileParser

using JSON3

const Location = String # TODO: parse these out?

struct Alloc
    stack::Vector{Location}
    type::String
    size::Int
end

struct AllocProfile
    allocs::Vector{Alloc}
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
        stack = [locations[loc+1].key for loc in alloc.stack]
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

end # module
