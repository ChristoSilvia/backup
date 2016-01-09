using PyPlot

function plotter()
  x = 0.0:0.1:2pi+0.1
  plot(cos(x),sin(x))
end

function plotter(z::Complex{Float64})
  plotter()
  scatter(real(z),im(z))
end

function plotter(zs::Vector{Complex{Float64}})
  plotter()
  scatter(map(real, zs),map(imag, zs))
end

function circle()
  [exp(i * 1im) for i in [0.0:0.1:(2.0*pi)]]
end

function circle(r::Real)
  map(z -> z*r,circle())
end

function circle(z::Complex{Float64})
  map(w -> w + z,circle())
end

function circle(r::Real,z::Complex{Float64})
  map(w -> w + z*r,circle())
end


function diskAuto(a::Complex{Float64},z::Complex{Float64})
  (z - a)/(1 - a'* z)
end
