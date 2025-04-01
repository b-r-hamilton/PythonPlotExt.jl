module PythonPlotExt 
using PythonPlot, Unitful, Measurements, Revise, DimensionalData, PythonCall
import PythonPlot.plot, PythonPlot.scatter, Measurements.uncertainty, Measurements.value
export plot, scatter, uncertainty, value

const pyplot = pyimport("matplotlib.pyplot")
const mpl = pyimport("matplotlib")


function __init__()
     PythonCall.pycopy!(mpl,pyimport("matplotlib"))
     PythonCall.pycopy!(pyplot,pyimport("matplotlib.pyplot"))
     println("Python libraries installed")
end

function plot(y::DimArray; lwcentral=3, lwedges=0,lzorder=0,fbzorder=0, kwargs...)
    unc = ustrip.(uncertainty.(vec(y)))    
    x = ustrip.(collect(first(dims(y))))
    xunit = unit(first(first(dims(y))))
    yunit = unit(first(y))
    y = ustrip.(value.(vec(y)))
    plot(x, y, linewidth = lwcentral, zorder = lzorder; kwargs...)
    if sum(unc) != 0 
        f = fill_between(x = x, y1 = y .- unc, y2 = y .+ unc, alpha = 0.3, linewidth = lwedges, zorder = fbzorder; kwargs...)
    end

    xlabel(string(xunit))
    ylabel(string(yunit))
    return x, y 
end
#=
function scatter(x::Vector{Quantity{Measurement{T}}}, y::Vector{Quantity{Measurement{T}}}; kwargs...) where T <: AbstractFloat
    xerr = uncertainty.(ustrip.(x))
    yerr = uncertainty.(ustrip.(y))
    xunit = unit(first(x))
    yunit = unit(first(y))
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    errorbar(x, y, xerr = xerr, yerr = yerr; kwargs...)
    xlabel(string(xunit))
    ylabel(string(yunit))
end
=#

function scatter(x::Vector{Quantity}, y::Vector{Quantity}; kwargs...)
    xerr = uncertainty.(ustrip.(x))
    yerr = uncertainty.(ustrip.(y))
    xunit = unit(first(x))
    yunit = unit(first(y))
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    if sum(xerr) + sum(yerr) != 0 
        errorbar(x, y, xerr = xerr, yerr = yerr, fmt = "none"; kwargs...)
    else
        scatter(x, y; kwargs...)
    end
    
    xlabel(string(xunit))
    ylabel(string(yunit))
end

function plot(x::Vector{Quantity}, y::Vector{Quantity}; kwargs...) 
    xerr = uncertainty.(ustrip.(x))
    yerr = uncertainty.(ustrip.(y))
    if T1 isa Quantity 
        xunit = unit(first(x))
        xlabel(string(xunit))
    elseif T2 isa Quantity
        yunit = unit(first(y))
        ylabel(string(yunit))
    end
    
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    if sum(xerr) + sum(yerr) != 0 
        errorbar(x, y, xerr = xerr, yerr = yerr, fmt = "none"; kwargs...)
    else
        plot(x,y;kwargs...)
    end

end


function scatter(x::Vector{Measurement{T1}}, y::Vector{Measurement{T2}}; kwargs...) where {T1 <: AbstractFloat, T2 <: AbstractFloat}
    xerr = uncertainty.(ustrip.(x))
    yerr = uncertainty.(ustrip.(y))
    xunit = unit(first(x))
    yunit = unit(first(y))
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    errorbar(x, y, xerr = xerr, yerr = yerr, fmt = "."; kwargs...)
    xlabel(string(xunit))
    ylabel(string(yunit))
end


function scatter(x::Vector{Measurement{T}}, y::Vector; kwargs...) where T <: AbstractFloat
    xerr = uncertainty.(ustrip.(x))
    #yerr = uncertainty.(ustrip.(y))
    xunit = unit(first(x))
    yunit = unit(first(y))
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    errorbar(x, y, xerr = xerr; kwargs...)
    xlabel(string(xunit))
    ylabel(string(yunit))
end

function scatter(x::Vector, y::Vector{Measurement{T}}; kwargs...) where T <: AbstractFloat
    #xerr = uncertainty.(ustrip.(x))
    yerr = uncertainty.(ustrip.(y))
    xunit = unit(first(x))
    yunit = unit(first(y))
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    errorbar(x, y, yerr = yerr; kwargs...)
    xlabel(string(xunit))
    ylabel(string(yunit))
end


function scatter(x::Array{Quantity{Measurement{T}, D1, A1}}, y::Array{Quantity{Measurement{T}, D2, A2}}; kwargs...) where {T <: AbstractFloat, D1, A1, D2, A2}
    xerr = uncertainty.(ustrip.(x))
    yerr = uncertainty.(ustrip.(y))
    xunit = unit(first(x))
    yunit = unit(first(y))
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    errorbar(x, y, xerr = xerr, yerr = yerr; kwargs...)
    xlabel(string(xunit))
    ylabel(string(yunit))
end

function scatter(x::Array{Quantity{T, D1, A1}}, y::Array{Quantity{T, D2, A2}}; kwargs...) where {T <: AbstractFloat, D1, A1, D2, A2}
    xerr = uncertainty.(ustrip.(x))
    yerr = uncertainty.(ustrip.(y))
    xunit = unit(first(x))
    yunit = unit(first(y))
    x = value.(ustrip.(x))
    y = value.(ustrip.(y))
    if sum(yerr) != 0 && sum(xerr) == 0
        errorbar(x, y, yerr = yerr; kwargs...)
    elseif sum(yerr) == 0 && sum(xerr) != 0
        errorbar(x,y,xerr = xerr;kwargs...)
    elseif sum(yerr) != 0 && sum(xerr) != 0
        errorbar(x,y,xerr = xerr,yerr=yerr;kwargs...)
    elseif sum(yerr) == 0 && sum(xerr) == 0
        scatter(x,y;kwargs...)
    end
    
        
    xlabel(string(xunit))
    ylabel(string(yunit))
end

function plot(x::Vector{Union{Missing, T1}}, y::Vector{Union{Missing, T2}}; kwargs...) where {T1, T2}
    x[ismissing.(x)] .= NaN
    y[ismissing.(y)] .= NaN
    x = convert(Vector{T}, x)
    y = convert(Vector{T}, y)
    plot(x, y; kwargs...) 
end

function plot(x::Vector{T1}, y::Vector{Union{Missing, T2}}; kwargs...) where {T1, T2}
    x[ismissing.(x)] .= NaN
    y[ismissing.(y)] .= NaN
    x = convert(Vector{T1}, x)
    y = convert(Vector{T2}, y)
    plot(x, y; kwargs...) 
end

function plot(x::Vector{Union{Missing, T1}}, y::Vector{T2}; kwargs...) where {T1, T2}
    x[ismissing.(x)] .= NaN
    y[ismissing.(y)] .= NaN
    x = convert(Vector{T1}, x)
    y = convert(Vector{T2}, y)
    plot(x, y; kwargs...) 
end

function plot(x::Vector{Quantity{T}}, y::Vector{Quantity{T}}; kwargs...) where T
    xu = unique(unit.(x))
    yu = unique(unit.(y))
    plot(ustrip.(x), ustrip.(y); kwargs...)
    xlabel(xu)
    ylabel(yu)
end

#this doesn't work, not sure why? 
#=
function contourf(x::Vector{Number}, y::Vector{Number}, z::Matrix{Union{Missing, T}}, levels; kwargs...) where T
    z[ismissing.(z)] .= NaN
    z = convert(Matrix{T}, z)
    contourf(x,y,z,levels;kwargs...) 
end

function contour(x, y, z::Matrix{Union{Missing, T}}, levels; kwargs...) where T
    z[ismissing.(z)] .= NaN
    z = convert(Matrix{T}, z)
    contour(x,y,z,levels;kwargs...) 
end
=#

end #module
