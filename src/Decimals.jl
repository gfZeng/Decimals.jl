#module Decimals
import Base: ==, +, -, *, /, div, inv, one, zero, eps
struct Decimal <: AbstractFloat
    c::BigInt  # coefficient
    q::Integer # exponent
end

include("arithmetic.jl")

#end
