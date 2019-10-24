const RoundUnnecessary = RoundingMode{:RoundUnnecessary}()
const RoundFloor       = RoundingMode{:RoundFloor}()
const RoundCeiling     = RoundingMode{:Ceiling}()



function div(x::BigInt, y::Union{Integer, BigInt}, round::RoundingMode)
    c, m = divrem(x, y)
    if round === RoundUnnecessary
        m == 0 || throw(DivideError())
        return c
    elseif round === RoundFloor
        c > 0 && return c
        return m == 0 ? c : c - 1
    elseif round === RoundCeiling
        c < 0 && return c
        return m == 0 ? c : c + 1
    elseif round === RoundDown
        return c
    elseif round === RoundUp
        m == 0 && return c
        return c >= 0 ? c + 1 : c - 1
    end
end


function setexponent(x::Decimal, q::Integer, round::RoundingMode=RoundUnnecessary)
    # c*10^q = c*(10^p*10^(q-p)) = (c*10^(q-p))*10^p
    p = x.q - q

    p == 0 && return x

    if p > 0
        c = x.c * big"10"^p
    else
        c = div(x.c, big"10"^-p, round)
    end
    Decimal(c, q)
end

function +(x::Decimal, y::Decimal)
    q = min(x.q, y.q)
    x = setexponent(x, q)
    y = setexponent(y, q)
    Decimal(x.c + y.c, q)
end

-(x::Decimal) = Decimal(-x.c, x.q)
-(x::Decimal, y::Decimal) = x + (-y)

*(x::Decimal, y::Decimal) = Decimal(x.c * y.c, x.q + y.q)


function div(x::Decimal, y::Decimal, precision::Integer=16, round::RoundingMode=RoundDown)
    x = setexponent(x, y.q - precision)
    c = div(x.c, y.c, round)
    Decimal(c, precision)
end

const Zero = Decimal(0, 0)
const One  = Decimal(1, 0)
zero(::Type{Decimal}) = Zero
one(::Type{Decimal}) = One

function inv(x::Decimal, precision::Integer=16, round::RoundingMode=RoundDown)
    div(One, x, precision, round)
end
