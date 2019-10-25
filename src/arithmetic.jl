
const RoundUnnecessary = RoundingMode{:RoundUnnecessary}()
const RoundFloor       = RoundingMode{:RoundFloor}()
const RoundCeiling     = RoundingMode{:Ceiling}()

const PRECISION, ROUNDING = 16, RoundDown

function setprecision!(; precision::Integer=16, rounding::RoundingMode=RoundDown)
    global PRECISION = precision
    global ROUNDING = rounding
    precision, rounding
end

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

function strip_trailing_zeros(x::Decimal)
    c, q = x.c, x.q
    while true
        d, m = divrem(c, big"10")
        if !iszero(m)
            break
        end
        c = d
        q += 1
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


function div(x::Decimal, y::Decimal, precision::Integer=PRECISION, round::RoundingMode=ROUNDING)
    if x.q > (p = y.q - precision)
        x = setexponent(x, p)
    else
        y = setexponent(y, x.q + precision)
    end
    c = div(x.c, y.c, round)
    Decimal(c, -precision)
end

/(x::Decimal, y::Decimal) = div(x, y)

const Zero = Decimal(0, 0)
const One  = Decimal(1, 0)
zero(::Type{Decimal}) = Zero
one(::Type{Decimal}) = One
eps(x::Decimal) = Decimal(1, x.q)

function inv(x::Decimal, precision::Integer=PRECISION, round::RoundingMode=ROUNDING)
    div(One, x, precision, round)
end

function ==(x::Decimal, y::Decimal)
    q = min(x.q, y.q)
    x = setexponent(x, q)
    y = setexponent(y, q)
    x.c == y.c
end

function <(x::Decimal, y::Decimal)
    q = min(x.q, y.q)
    x = setexponent(x, q)
    y = setexponent(y, q)
    return x.c < y.c
end

<=(x::Decimal, y::Decimal) = x < y || x == y

number(x::Decimal) = x.c * 10.0^x.q

signbit(x::Decimal) = signbit(x.c)
sign(x::Decimal) = sign(x.c)
