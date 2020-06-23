module Decimals
import Base: +, -, *, /, div, inv,
             ==, <, <=, >, >=,
             signbit, sign, decompose,
             one, zero,
             eps, parse, print


export Decimal, @d_str, strip_trailing_zeros,
       RoundUnnecessary, RoundFloor, RoundCeiling


struct Decimal <: AbstractFloat
    c::BigInt  # coefficient
    q::Integer # exponent
end

PRECISION, ROUNDING = 9, RoundDown

function setprecision!(; precision::Integer=16, rounding::RoundingMode=RoundDown)
    global PRECISION = precision
    global ROUNDING = rounding
    precision, rounding
end

include("decimal.jl")
include("arithmetic.jl")


function decompose(x::Decimal)
    x = strip_trailing_zeros(x)
    x.q >= 0 ? decompose(x.c * 10^x.q) : decompose(x.c // 10^-x.q)
end

end
