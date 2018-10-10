# EndyIndexes.jl
Index arrays relative to their start and end in regular code, without the syntax errors


#### Before
```julia
arr = [1:10;]
for idx in (3:5, end-2:end)
    @show arr[idx]
end
```
Output
```julia
ERROR: syntax: unexpected "end"
```
😢

#### Now

```julia
using EndyIndexes

const start_ = StartBasedIdx()
const end_ = EndBasedIdx()

arr = [1:10;]
for idx in (end_-2:end_, start_+1:end_-2)
    @show arr[idx]
end
```
Output
```julia
arr[idx] = [8, 9, 10]
arr[idx] = [2, 3, 4, 5, 6, 7, 8]
```
😄

## Installation

```julia
julia > ]
(1.0) pkg> add https://github.com/JobJob/EndyIndexes.jl.git
```

## Warnings

Not tested on OffsetArrays, and other exotically indexed arrays. Could well work though since it uses `firstindex` and `lastindex`, lemme know.
