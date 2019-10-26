# Decimals

## Description
Decimal for Julia, like Java BigDecimal

## Usage
```julia
d1 = d"3.0"
d2 = d"-3E-10"
Decimal(-3, -10)
Decimal("3.0")
d1 + d2
d1 > d2
div(d1, d2, 16, RoundUp)
inv(d1)
```

## Compares
The package provides the same features with another [Decimals.jl](https://github.com/JuliaMath/Decimals.jl/blob/master/src/Decimals.jl) package. But the implements is more simple, and the use more friendly, like Java BigDecimal.
