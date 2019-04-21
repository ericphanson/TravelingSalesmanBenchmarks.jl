
using TravelingSalesmanExact, GLPK
using TravelingSalesmanHeuristics
using TravelingSalesmanExact: ATT, euclidean_distance
using TravelingSalesmanBenchmarks
using Plots
using Random
gr(fmt=:svg)


Random.seed!(147);
N = 50
cost = 100*rand(N, N)


t_exact, c_exact = get_optimal_tour(cost, with_optimizer(GLPK.Optimizer))

c(q) = solve_tsp(cost; quality_factor = q)[2]

qs = range(10, stop = 100, step = 10)

plot(qs, c, xlabel="quality", ylabel="Cost", label="solve_tsp 1", title="random cost matrix")
for j = 2:5
    plot!(qs, c, label="solve_tsp $j")
end
hline!([c_exact], label="Exact cost")


file = @isdefined(WEAVE_ARGS) ? WEAVE_ARGS[:file] : nothing
TravelingSalesmanBenchmarks.bench_footer(file)

