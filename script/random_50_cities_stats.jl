
using TravelingSalesmanExact, MosekTools, GLPK, Gurobi
const MosekF = with_optimizer(Mosek.Optimizer, QUIET = true)
const GLPKF = with_optimizer(GLPK.Optimizer)
const env = Gurobi.Env()
const GurobiF = with_optimizer(Gurobi.Optimizer, env, OutputFlag = 0)
using TravelingSalesmanHeuristics
using TravelingSalesmanExact: euclidean_distance
using TravelingSalesmanBenchmarks
using Plots
using DataFrames
using Printf, Random, Statistics
Statistics.quantile(p::Number) = Base.Fix2(quantile, p)
gr(fmt=:svg)

function get_plt_coords(cities)
    n = length(cities)
    inc(a) = a == n ? one(a) : a + 1
    return [cities[inc(j)][1] for j = 0:n], [cities[inc(j)][2] for j = 0:n]
end
TravelingSalesmanExact.plot_cities(cities; kwargs...) = plot(get_plt_coords(cities)...; kwargs...)
plot_cities!(cities; kwargs...) = plot!(get_plt_coords(cities)...; kwargs...)

function plot_tours(cities, pairs; kwargs...)
    plts = []
    colors = sequential_palette(0, length(pairs)+1)[2:end]
    for (index, (tour, label)) in enumerate(pairs)
        plt = plot_cities(cities[tour], label = label, linewidth = 2,
                            color = colors[index])
        plot_cities!(cities; title="Comparison of tours", st=:scatter, label="City locations", markersize = 5, kwargs...)
        push!(plts, plt)
    end
    return plts
end


Random.seed!(639);
N = 50
cities = [100*rand(2) for _ = 1:N]


function cost_quality_plots(cities; n = 15, qs = range(0, stop = 100, step = 5))
    cost = [ euclidean_distance(cities[i], cities[j]) for i=1:N, j=1:N ]

    (tour_glpk, cost_glpk), time_glpk, _ = @timed get_optimal_tour(cost, GLPKF)
    (tour_mosek, cost_mosek), time_mosek, _ = @timed get_optimal_tour(cost, MosekF)
    (tour_gurobi, cost_gurobi), time_gurobi, _ = @timed get_optimal_tour(cost, GurobiF)
    @assert cost_glpk ≈ cost_mosek ≈ cost_gurobi
    t_exact, c_exact = tour_glpk, cost_glpk
    tour_plt = plot_tours(cities, [(t_exact, "Optimal tour ($(length(cities)) cities)")], title = "Optimal tour")[]
    
    df = DataFrame(
            begin
                (tour, c), time, _ = @timed solve_tsp(cost; quality_factor = q)
                if c < c_exact && !(c ≈ c_exact)
                    @warn "c < c_exact" c c_exact
                end
                (quality = q, cost = c, time = time )
            end
            for _ = 1:n for q in qs) 
    cost_df = by(df, :quality, :cost => median, :cost => quantile(.25), :cost => quantile(.75) )

    cost_plt = hline([c_exact], label="Exact cost")
    plot!(cost_df[1], cost_df[2], ribbon = (cost_df[2] .- cost_df[3], cost_df[4] .- cost_df[2]),
    label = "Median cost over $n heuristic runs per `quality_factor`", xlabel="`quality_factor`", ylabel="Cost", title="Cost vs quality" )

    time_df = by(df, :quality, :time => median, :time => quantile(.25), :time => quantile(.75) )
    time_plt = hline([time_glpk], label="Time for exact computation with GLPK")
    hline!([time_mosek], label="Time for exact computation with Mosek")
    hline!([time_gurobi], label="Time for exact computation with Gurobi")
    plot!(time_df[1], time_df[2],  ribbon = (time_df[2] .- time_df[3], time_df[4] .- time_df[2]),
    label = "Median time over $n heuristic runs per `quality_factor`", xlabel="`quality_factor`", ylabel="Time", title="Time vs quality" )

    return tour_plt, cost_plt, time_plt
end

foreach(display, cost_quality_plots(cities))


N = 50
cities = [100*rand(2) for _ = 1:N]
foreach(display, cost_quality_plots(cities))


cities = [100*rand(2) for _ = 1:N]
foreach(display, cost_quality_plots(cities))


cities = [100*rand(2) for _ = 1:N]
foreach(display, cost_quality_plots(cities))


cities = [100*rand(2) for _ = 1:N]
foreach(display, cost_quality_plots(cities))


N = 80
cities = [100*rand(2) for _ = 1:N]
foreach(display, cost_quality_plots(cities))


file = @isdefined(WEAVE_ARGS) ? WEAVE_ARGS[:file] : nothing
TravelingSalesmanBenchmarks.bench_footer(file)

