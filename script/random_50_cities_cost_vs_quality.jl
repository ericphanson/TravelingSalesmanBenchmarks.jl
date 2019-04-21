
using TravelingSalesmanExact, GLPK
using TravelingSalesmanHeuristics
using TravelingSalesmanExact: ATT, euclidean_distance
using TravelingSalesmanBenchmarks
using Plots
using Printf, Random
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


Random.seed!(155);
N = 50
cities = [100*rand(2) for _ = 1:N]
cost = [ euclidean_distance(cities[i], cities[j]) for i=1:N, j=1:N ]


t_exact, c_exact = get_optimal_tour(cost, with_optimizer(GLPK.Optimizer))

c(q) = solve_tsp(cost; quality_factor = q)[2]

qs = range(10, stop = 100, step = 10)

plot(qs, c, xlabel="quality", ylabel="Cost", label="solve_tsp 1", title="random cities")
for j = 2:5
    plot!(qs, c, label="solve_tsp $j")
end
hline!([c_exact], label="Exact cost")


t_heuristic_100, c_heuristic_100 = solve_tsp(cost; quality_factor = 100)
t_heuristic_40, c_heuristic_40 = solve_tsp(cost; quality_factor = 40)

plts = plot_tours(cities, [
    (t_heuristic_40, @sprintf("Heuristic; quality 40, cost=%.2f",   c_heuristic_40)),
    (t_heuristic_100, @sprintf("Heuristic; quality 100, cost=%.2f", c_heuristic_100)),
    (t_exact, @sprintf("Optimal tour; cost=%.2f", c_exact))
    ])
for plt in plts
    display(plt)
end


function compare_cities(N)
    cities = [100*rand(2) for _ = 1:N]
    cost = [ euclidean_distance(cities[i], cities[j]) for i=1:N, j=1:N ]
    t_exact, c_exact = get_optimal_tour(cost, with_optimizer(GLPK.Optimizer))

    c(q) = solve_tsp(cost; quality_factor = q)[2]

    qs = range(10, stop = 100, step = 10)

    line_plt = plot(qs, c, xlabel="quality", ylabel="Cost", label="solve_tsp 1", title="random cities")
    for j = 2:5
        plot!(qs, c, label="solve_tsp $j")
    end
    hline!([c_exact], label="Exact cost")

    t_heuristic_100, c_heuristic_100 = solve_tsp(cost; quality_factor = 100)
    t_heuristic_40, c_heuristic_40 = solve_tsp(cost; quality_factor = 40)
    city_plts = plot_tours(cities, [
    (t_heuristic_40, @sprintf("Heuristic; quality 40, cost=%.2f",   c_heuristic_40)),
    (t_heuristic_100, @sprintf("Heuristic; quality 100, cost=%.2f", c_heuristic_100)),
    (t_exact, @sprintf("Optimal tour; cost=%.2f", c_exact))
    ])
    return line_plt, city_plts...
end

for j = 1:5
    plts = compare_cities(50)
    for plt in plts
        display(plt)
    end
end


file = @isdefined(WEAVE_ARGS) ? WEAVE_ARGS[:file] : nothing
TravelingSalesmanBenchmarks.bench_footer(file)

