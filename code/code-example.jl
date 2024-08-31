using Gradus, Plots

m = KerrMetric(a = 0.5)
x_obs = SVector(0.0, 10_000.0, deg2rad(75), 0.0)
d = ThinDisc(Gradus.isco(m), 20.0)

pf = ConstPointFunctions.redshift(m, x_obs) ∘
    # filter only those geodesics that intersected with
    # geometry
    ConstPointFunctions.filter_intersected()

α, β, img = rendergeodesics(
  m, x_obs, d, 2x_obs[2]; 
  pf = pf, verbose = true,
  αlims = (-25, 25),
  βlims = (-20, 20),
  image_width = 800,
  image_height = 800,
)

begin
    fig = Figure(size = (350, 200),backgroundcolor = RGBAf(0.0,0.0,0.0,0.0))
    ga = fig[1,1] = GridLayout()
    ax = Axis(ga[1,1], aspect = DataAspect(), backgroundcolor = RGBAf(0.0,0.0,0.0,0.0), xlabel = "α", ylabel = "β", title = "Redshift projection")
    hm = heatmap!(ax, α, β, img', colormap = :batlow) 
    ylims!(ax, -10, 14)
    Colorbar(ga[1,2], hm, height = 100)
    Makie.save("presentation/figs/disc-projection.png", fig, dpi = 400)
    fig
end
# # and visualise
# Plots.heatmap(α, β, img, aspect_ratio=1, xlabel = "α", ylabel = "β")
# Plots.savefig("presentation/figs/raw/code-example.svg")