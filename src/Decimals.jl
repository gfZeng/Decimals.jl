module Decimals
import Base: ==, +, -, *, /, div, inv,
             <, <=, >,
             signbit, sign,
             one, zero,
             eps, parse, print


export Decimal, @d_str, strip_trailing_zeros,
       RoundUnnecessary, RoundFloor, RoundCeiling

struct Decimal <: AbstractFloat
    c::BigInt  # coefficient
    q::Integer # exponent
end

include("decimal.jl")
include("arithmetic.jl")

end
