
using TravelingSalesmanExact, GLPK
using TravelingSalesmanHeuristics
using TravelingSalesmanExact: ATT, euclidean_distance
using TravelingSalesmanBenchmarks
using Plots
using Printf, Random
gr(fmt=:svg)


function TravelingSalesmanExact.plot_cities(cities; kwargs...)
    n = length(cities)
    inc(a) = a == n ? one(a) : a + 1
    Plots.plot([cities[inc(j)][1] for j = 0:n], [cities[inc(j)][2] for j = 0:n]; kwargs...)
    Plots.plot!([cities[inc(j)][1] for j = 0:n], [cities[inc(j)][2] for j = 0:n]; st=:scatter, label="City locations")
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


plot_cities(cities[t_exact], title="Optimal tour", label=@sprintf("cost=%.2f", c_exact))


t_heuristic, c_heuristic = solve_tsp(cost; quality_factor = 100)
plot_cities(cities[t_heuristic], title="Heuristic tour, `quality_factor` = 100", label=@sprintf("cost=%.2f", c_heuristic))


t_heuristic, c_heuristic = solve_tsp(cost; quality_factor = 40)
plot_cities(cities[t_heuristic], title="Heuristic tour, `quality_factor` = 40", label=@sprintf("cost=%.2f", c_heuristic))


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

    opt_city_plt = plot_cities(cities[t_exact], title="Optimal tour", label=@sprintf("cost=%.2f", c_exact))

    t_heuristic, c_heuristic = solve_tsp(cost; quality_factor = 100)
    heuristic_city_plt_1 = plot_cities(cities[t_heuristic], title="Heuristic tour, `quality_factor` = 100", label=@sprintf("cost=%.2f", c_heuristic))

    t_heuristic_2, c_heuristic_2 = solve_tsp(cost; quality_factor = 40)
    heuristic_city_plt_2 = plot_cities(cities[t_heuristic_2], title="Heuristic tour, `quality_factor` = 40", label=@sprintf("cost=%.2f", c_heuristic_2))
    return line_plt, opt_city_plt, heuristic_city_plt_1, heuristic_city_plt_2
end

for j = 1:5
    plts = compare_cities(50)
    for plt in plts
        display(plt)
    end
end


TravelingSalesmanBenchmarks.bench_footer(WEAVE_ARGS[:file])

