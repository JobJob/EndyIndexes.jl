module EndyIndexes

export EndBasedIdx, StartBasedIdx, EndyRangeIdx

######## Single Indices #######
struct EndBasedIdx
    v::Int
end
EndBasedIdx() = EndBasedIdx(0)

struct StartBasedIdx
    v::Int
end
StartBasedIdx() = StartBasedIdx(0)

const EndySingleIndex = Union{StartBasedIdx, EndBasedIdx}

####### Range Indices #######
const EndyRangeElType = Union{EndySingleIndex, Int}
struct EndyRangeIdx{FT, TT} <: AbstractVector{Int} where {FT<:EndyRangeElType, TT<:EndyRangeElType}
    from::FT # from
    to::TT   # to
end

####### Union Catchall #######
const EndyIndex = Union{EndySingleIndex, EndyRangeIdx}

####### Indexing Operations #######
idx_from_axis(ax, idx::EndBasedIdx)   = lastindex(ax)  - idx.v
idx_from_axis(ax, idx::StartBasedIdx) = firstindex(ax) + idx.v
idx_from_axis(ax, idx::Int)           = idx
idx_from_axis(ax, idxs::EndyRangeIdx) =
    idx_from_axis(ax, idxs.from):idx_from_axis(ax, idxs.to)

Base.to_indices(a, _axes, idxss::Tuple{Vararg{EndyIndex}}) =
    ((idx_from_axis(ax, idx) for (ax, idx) in zip(_axes, idxss))...,)

####### Input Conveniences #######
# enables writing e.g. `end_-4`, `end_-9`, `start_+2`, `start_+6`
Base.:-(idx::EndBasedIdx, i::Int)   =   EndBasedIdx(idx.v + i)
Base.:+(idx::StartBasedIdx, i::Int) = StartBasedIdx(idx.v + i)

# enables writing e.g. `end_-9:end_-3` `end_-5:end_` `2:end_-1`, `start_+2:10`
(::Base.Colon)(from::EndySingleIndex, to::EndySingleIndex) = EndyRangeIdx(from, to)
(::Base.Colon)(from::EndySingleIndex, to::Int) = EndyRangeIdx(from, to)
(::Base.Colon)(from::Int, to::EndySingleIndex) = EndyRangeIdx(from, to)

####### Display #######
idx_value_str(idx::EndBasedIdx)  = idx.v==0 ? "" : "-$(idx.v)"
idx_value_str(idx::StartBasedIdx) = idx.v==0 ? "" : "+$(idx.v)"
Base.show(io::IO, idx::EndBasedIdx)   = print(io,   "end$(idx_value_str(idx))")
Base.show(io::IO, idx::StartBasedIdx) = print(io, "start$(idx_value_str(idx))")
Base.show(io::IO, idxs::EndyRangeIdx) = (show(io, idxs.from); print(io, ":"); show(io, idxs.to))



# Not needed?
# Base.to_index(a::AbstractArray, idx::EndBasedIdx)   = idx_from_axis(a, idx)
# Base.to_index(a::AbstractArray, idxs::EndyRangeIdx) = idx_from_axis(a, idx)
# Base.:+(idx::EndBasedIdx, i::Int) = EndBasedIdx(idx.v - i)
# Base.isless(i1::EndBasedIdx, i2::EndBasedIdx) = i1.v > i2.v
# Base.size(r::EndyRangeIdx) = (r.from.v - r.to.v + 1,)
# Base.length(r::EndyRangeIdx) = r.from.v - r.to.v + 1
# Base.first(r::EndyRangeIdx) = r.from
# Base.last(r::EndyRangeIdx) = r.to

end # module
