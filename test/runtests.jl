using PyPlotExt, Test
using DimensionalData, Unitful, Measurements, PythonPlot

const K = u"K"
const yr = u"yr"

@testset "PyPlotExt" begin
    @testset "Plotting a DimArray" begin
        data = randn(3, 10)K
        dataunc = abs.(randn(3,10))K
        ax1 = Symbol.(["A", "B", "C"])
        ax2 = 6yr:1yr:15yr
        da = DimArray(data .± dataunc, (X(ax1), Ti(ax2)))
        figure()
        N = 3 
        subplot(N, 1, 1)
        plot(ustrip.(value.(da[At(:A), :])))
        title("DimArray, with no units, no uncertainty")
        
        subplot(N,1,2)
        plot(value.(da[At(:A), :]), lwcentral = 5, alpha = 1, color = "purple")
        title("DimArray, with units, no uncertainty")

        subplot(N, 1, 3)
        plot(da[At(:A), :])
        title("DimArray, with units, with uncertainty")
        xlabel("Time [years CE]", fontsize = 15) 
        tight_layout()
        savefig("../plots/dimarray.png")
    end

    @testset "Scatter vectors of measurements" begin
        x = (randn(5) .± abs.(randn(5)))K
        y = (randn(5) .± abs.(randn(5)))K
        figure()
        N = 3
        subplot(N, 1, 1)
        scatter(x,y, color = "red")
    end

    
end

