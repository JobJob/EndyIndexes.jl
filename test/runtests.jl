using Test
using Base.Iterators
using EndyIndexes

const ▶️ = StartBasedIdx()
const 🛑 = EndBasedIdx()

# TODO tests for offset arrays
@testset "Endy Indexes" begin
    bv, dv1, ev1, ev2  = 2, 7, 7, 4
    N = 12
    a, b   = 🛑, 🛑-bv
    ai, bi =    N,    N-bv

    c, d, e    = 🛑:🛑, 🛑-dv1:🛑, 🛑-ev1:🛑-ev2
    ci, di, ei =    N:N,       N-dv1:N,       N-ev1:   N-ev2

    f, g, h    = 1:🛑, 2:🛑-bv,     🛑-dv1:11
    fi, gi, hi = 1:N,  2:N-bv,      N-dv1:11

    n, o   = ▶️, ▶️+bv
    ni, oi = 1,  1+bv

    p, q, r    = ▶️:▶️,   ▶️:▶️+dv1, ▶️+ev2:▶️+ev1
    pi, qi, ri =  1:1,    1:1+dv1,  1+ev2:1+ev1

    s, t, u    = ▶️:N, 2:▶️+dv1,     ▶️+dv1:11
    si, ti, ui = 1:N,  2:1+dv1,      1+dv1:11

    endy_inds  = (a, b, c, d, e, f, g, h)
    iendy_inds = (ai, bi, ci, di, ei, fi, gi, hi)

    starty_inds  = (n, o, p, q, r, s, t, u)
    istarty_inds = (ni, oi, pi, qi, ri, si, ti, ui)

    @testset "display end" begin
        @test string(a) == "end"
        @test string(b) == "end-$bv"
        @test string(c) == "end:end"
        @test string(d) == "end-$dv1:end"
        @test string(e) == "end-$ev1:end-$ev2"
    end

    @testset "display start" begin
        @test string(n) == "start"
        @test string(o) == "start+$bv"
        @test string(p) == "start:start"
        @test string(q) == "start:start+$dv1"
        @test string(r) == "start+$ev2:start+$ev1"
    end

    @testset "endy types" begin
        @test a isa EndBasedIdx
        @test b isa EndBasedIdx
        @test c isa EndyRangeIdx
        @test d isa EndyRangeIdx
        @test e isa EndyRangeIdx
    end

    @testset "starty types" begin
        @test n isa StartBasedIdx
        @test o isa StartBasedIdx
        @test p isa EndyRangeIdx
        @test q isa EndyRangeIdx
        @test r isa EndyRangeIdx
    end

    @testset "single endy indexing" begin
        arr = [1:N;]
        @test arr[a] == arr[ai]
        @test arr[b] == arr[bi]
        @test arr[c] == arr[ci]
        @test arr[d] == arr[di]
        @test arr[e] == arr[ei]
    end

    @testset "single starty indexing" begin
        arr = [1:N;]
        @test arr[n] == arr[ni]
        @test arr[o] == arr[oi]
        @test arr[p] == arr[pi]
        @test arr[q] == arr[qi]
        @test arr[r] == arr[ri]
    end

    @testset "double endy indexing" begin
        arr = reshape([1:N^2;], N, N)

        all_endy_combos = product(endy_inds, endy_inds)
        all_inty_combos = product(iendy_inds, iendy_inds)
        for (inds, inds_ints) in zip(all_endy_combos, all_inty_combos)
            @show inds inds_ints
            @test arr[inds...] == arr[inds_ints...]
        end
    end

    @testset "double starty indexing" begin
        arr = reshape([1:N^2;], N, N)

        all_starty_combos = product(starty_inds, starty_inds)
        all_inty_combos = product(istarty_inds, istarty_inds)
        for (inds, inds_ints) in zip(all_starty_combos, all_inty_combos)
            @show inds inds_ints
            @test arr[inds...] == arr[inds_ints...]
        end
    end
end
