
using TravelingSalesmanExact, GLPK
using TravelingSalesmanHeuristics
using TravelingSalesmanExact: ATT, euclidean_distance
using TravelingSalesmanBenchmarks
using Plots
gr(fmt=:svg)
repo_directory = TravelingSalesmanBenchmarks.repo_directory;
data_directory = joinpath(repo_directory, "data");


N = 50
cities = [100*rand(2) for _ = 1:N]
cost = [ euclidean_distance(cities[i], cities[j]) for i=1:N, j=1:N ]


t_exact, c_exact = get_optimal_tour(cost, with_optimizer(GLPK.Optimizer))

c(q) = solve_tsp(cost; quality_factor = q)[2]

qs = range(10, stop = 100, step = 10)

plot(qs, c, xlabel="quality", ylabel="Cost", label="solve_tsp 1", title="att48.tsp")
for j = 2:5
    plot!(qs, c, label="solve_tsp $j")
end
hline!([c_exact], label="Exact cost")


function TravelingSalesmanExact.plot_cities(cities)
    n = length(cities)
    inc(a) = a == n ? one(a) : a + 1
    Plots.plot([cities[inc(j)][1] for j = 0:n], [cities[inc(j)][2] for j = 0:n])
end


plot_cities(cities[t_exact])


t = solve_tsp(cost; quality_factor = 100)[1]
plot_cities(cities[t])


TravelingSalesmanBenchmarks.bench_footer(WEAVE_ARGS[:file])

