

Base.promote_rule(::Type{Decimal}, ::Type{<:Real}) = Decimal
Base.promote_rule(::Type{BigFloat}, ::Type{Decimal}) = Decimal
Base.promote_rule(::Type{BigInt}, ::Type{Decimal}) = Decimal

const RoundUnnecessary = RoundingMode{:RoundUnnecessary}()
const RoundFloor       = RoundingMode{:RoundFloor}()
const RoundCeiling     = RoundingMode{:Ceiling}()

function divide(x::BigInt, y::Union{Integer, BigInt}, round::RoundingMode)
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
        c = divide(x.c, big"10"^-p, round)
    end
    Decimal(c, q)
end

function strip_trailing_zeros(x::Decimal)

    iszero(x.c) && return Zero

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


function mul(x::Decimal, y::Decimal, precision::Integer=PRECISION, round::RoundingMode=ROUNDING)
    p = Decimal(x.c * y.c, x.q + y.q)
    p = p.q >= -precision ? p : strip_trailing_zeros(p)
    p.q >= -precision ? p : setexponent(p, -precision, round)
end

*(x::Decimal, y::Decimal) = mul(x, y)


function div(x::Decimal, y::Decimal, precision::Integer=PRECISION, round::RoundingMode=ROUNDING)
    if x.q > (p = y.q - precision)
        x = setexponent(x, p)
    else
        y = setexponent(y, x.q + precision)
    end
    c = divide(x.c, y.c, round)
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


for comp in (:(==), :<, :>, :<=, :>=)
    @eval function $comp(x::Decimal, y::Decimal)
        q = min(x.q, y.q)
        x = setexponent(x, q)
        y = setexponent(y, q)
        $comp(x.c, y.c)
    end
end

number(x::Decimal) = x.c * 10.0^x.q

signbit(x::Decimal) = signbit(x.c)
sign(x::Decimal) = sign(x.c)
