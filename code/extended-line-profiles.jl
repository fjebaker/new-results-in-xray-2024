include("common.jl")

m = KerrMetric(1.0, 0.9)
x_steep = SVector(0.0, 10000.0, deg2rad(70), 0.0)
x_shallow = SVector(0.0, 10000.0, deg2rad(20), 0.0)

# currently needs an infinite disc for the root finder (patch coming soon)
d = ThinDisc(0.0, Inf)
gbins = collect(range(0.0, 1.4, 300))
radii = Gradus.Grids._geometric_grid(Gradus.isco(m), 1000.0, 100)
itb_shallow = @time Gradus.interpolated_transfer_branches(m, x_shallow, d, radii; verbose = true)
itb_steep = @time Gradus.interpolated_transfer_branches(m, x_steep, d, radii; verbose = true)


function lineprof_flux(prof, itb, gbins, radii)
    flux = Gradus.integrate_lineprofile(
        r -> Gradus.emissivity_at(prof, r),
        itb,
        gbins;
        h = 2e-8,
        n_radii = 3000,
        rmin = minimum(radii),
        rmax = maximum(radii),
    )
end

c_height = 10.0

model2 = DiscCorona(10.0, c_height)
prof2 = @time emissivity_profile(m, d, model2; n_samples = 600, n_rings = 20)
flux2_steep = lineprof_flux(prof2, itb_steep, gbins, radii)
flux2_shallow = lineprof_flux(prof2, itb_shallow, gbins, radii)

model3 = DiscCorona(20.0, c_height)
prof3 = @time emissivity_profile(m, d, model3; n_samples = 600, n_rings = 20)
flux3_steep = lineprof_flux(prof3, itb_steep, gbins, radii)
flux3_shallow = lineprof_flux(prof3, itb_shallow, gbins, radii)

lp_prof = emissivity_profile(m, d, LampPostModel(h = c_height); n_samples = 10_000)
fluxlp_steep = lineprof_flux(lp_prof, itb_steep, gbins, radii)
fluxlp_shallow = lineprof_flux(lp_prof, itb_shallow, gbins, radii)

begin
    fig = Figure(size = (700, 330))  
    ax = Axis(fig[2,1], title = "θ=70°", xlabel = "E/E₀", ylabel = "Flux (arb.)")    

    l1 = lines!(ax, gbins, fluxlp_steep, linewidth = 2.0)
    l3 = lines!(ax, gbins, flux2_steep, linewidth = 2.0)
    l4 = lines!(ax, gbins, flux3_steep, linewidth = 2.0)
    xlims!(ax, 0.5, 1.4)
    ylims!(ax, -1e-5, nothing)

    ax2 = Axis(fig[2,2], title = "θ=20°", xlabel = "E/E₀", yaxisposition = :right, ylabel = "Flux (arb.)")

    ll1 = lines!(ax2, gbins, fluxlp_shallow, linewidth = 2.0)
    ll3 = lines!(ax2, gbins, flux2_shallow, linewidth = 2.0)
    ll4 = lines!(ax2, gbins, flux3_shallow, linewidth = 2.0)

    xlims!(ax2, 0.5, 1.1)
    ylims!(ax2, -1e-5, nothing)
    
    Legend(fig[1, 1:2], [l1, l3, l4], ["LP", "x=10", "x=20"], orientation=:horizontal, framevisible = false)
    Makie.save("presentation/figs/raw/extended-line-profiles.svg", fig, dpi=400)
    fig
end




fluxes = map([20, 40, 50, 60, 70]) do angle
    x = SVector(0.0, 10000.0, deg2rad(angle), 0.0)
    itb = @time Gradus.interpolated_transfer_branches(m, x, d, radii; verbose = true)
    fluxlp = lineprof_flux(lp_prof, itb, gbins, radii)
end

fluxes_extended = map([20, 40, 50, 60, 70]) do angle
    x = SVector(0.0, 10000.0, deg2rad(angle), 0.0)
    itb = @time Gradus.interpolated_transfer_branches(m, x, d, radii; verbose = true)
    fluxlp = lineprof_flux(prof3, itb, gbins, radii)
end

dh_fluxes = map([5.0, 10.0, 20.0]) do h
    prof = @time emissivity_profile(m, d, DiscCorona(20.0, h); n_samples = 600, n_rings = 20)
    fluxlp = lineprof_flux(prof, itb_steep, gbins, radii)
end

dh_fluxes_lp = map([5.0, 10.0, 20.0]) do h
    prof = emissivity_profile(m, d, LampPostModel(h = h); n_samples = 10_000)
    fluxlp = lineprof_flux(prof, itb_steep, gbins, radii)
end


begin
    fig = Figure(size = (700, 330))  
    ax = Axis(fig[1,1], title = "Changing Inclination", xlabel = "E/E₀", ylabel = "Flux (arb.)")    

    _palette = _default_palette()
    els = map(fluxes_extended) do f
        c = popfirst!(_palette)
        lines!(ax, gbins, f, linewidth = 0.8, color = c)
    end
    
    _palette = _default_palette()
    ls = map(fluxes) do f
        lines!(ax, gbins, f, linewidth = 2.5, color = popfirst!(_palette))
    end
    
    Legend(fig[1,1], ls, ["θ=20°", "θ=40°", "θ=50°", "θ=60°", "θ=70°"], tellheight = false, tellwidth = false, halign = 0.1, valign = 0.9, backgroundcolor = RGBAf(0.0,0.0,0.0,0.0))
    Legend(fig[1,1], [ls[2], els[2]], ["LP", "x=20"], tellheight = false, tellwidth = false, halign = 0.95, valign = 0.9, backgroundcolor = RGBAf(0.0,0.0,0.0,0.0))

    
    xlims!(ax, 0.5, 1.4)
    ylims!(ax, -1e-5, nothing)

    ax_1 = Axis(fig[1,2], title = "Changing Height", xlabel = "E/E₀", ylabel = "Flux (arb.)", yaxisposition = :right)    

    _palette = _default_palette()
    els = map(dh_fluxes) do f
        c = popfirst!(_palette)
        lines!(ax_1, gbins, f, linewidth = 0.8, color = c)
    end

    _palette = _default_palette()
    ls = map(dh_fluxes_lp) do f
        c = popfirst!(_palette)
        lines!(ax_1, gbins, f, linewidth = 2.5, color = c)
    end
    
    Legend(fig[1,2], ls, ["h=5", "h=10", "h=20"], tellheight = false, tellwidth = false, halign = 0.1, valign = 0.9, backgroundcolor = RGBAf(0.0,0.0,0.0,0.0))
    # Legend(fig[1,1], [ls[2], els[2]], ["LP", "x=20"], tellheight = false, tellwidth = false, halign = 0.95, valign = 0.9, backgroundcolor = RGBAf(0.0,0.0,0.0,0.0))

    
    xlims!(ax_1, 0.5, 1.4)
    ylims!(ax_1, -1e-5, nothing)

    Makie.save("presentation/figs/raw/extended-line-profiles-changing.svg", fig, dpi=400)
    fig
end