module PlotComplex
using PyPlot

function plot()
  x = 0.0:0.01:2pi
  plot(cos(x),sin(x))
end

function plot(z::Complex{Float64})
  plot()
  scatter(real(z),im(z))
end

function plot(zs::Vector{Complex{Float64}})
  plot()
  scatter(map(real, zs),map(imag, zs))
end


