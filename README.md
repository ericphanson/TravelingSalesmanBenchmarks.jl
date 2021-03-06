# TravelingSalesmanBenchmarks

A set of benchmarks for the Julia package [TravelingSalesmanHeuristics](https://github.com/evanfields/TravelingSalesmanHeuristics.jl) using [TravelingSalesmanExact](https://github.com/ericphanson/TravelingSalesmanExact.jl) to generate comparison data. Modified from the `weave` branch of [DiffEqBenchmarks](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl/tree/weave).

View the generated benchmarks at <https://ericphanson.github.io/TravelingSalesmanBenchmarks.jl/>.

## Interactive Notebooks

To run the tutorials interactively via Jupyter notebooks and benchmark on your
own machine, install the package and open the tutorials like:

```julia
]add "https://github.com/ericphanson/TravelingSalesmanBenchmarks.jl"
using TravelingSalesmanBenchmarks
TravelingSalesmanBenchmarks.open_notebooks()
```

## Contributing

All of the files are generated from the Weave.jl files in the `benchmarks` folder. To run the generation process, do for example:

```julia
using TravelingSalesmanBenchmarks
TravelingSalesmanBenchmarks.weave_file("att48_cost_vs_quality.jmd")
```

To generate all of the benchmarks, do:

```julia
TravelingSalesmanBenchmarks.generate()
```

This will also update `index.html`.

Each of the benchmarks displays the computer characteristics at the bottom of
the benchmark.