
const REGEX = r"([+-]?\d*)\.?(\d*)[Ee]?([+-]?\d+)?"

bigint(s::AbstractString) = isempty(s) ? big"0" : parse(BigInt, s)
bigint(::Nothing) = 0

function parse(::Type{Decimal}, s::AbstractString)
    int, digit, exp = match(REGEX, s).captures
    ndigits = length(digit)
    exp = bigint(exp) - ndigits
    c = bigint(int * digit)
    Decimal(c, exp)
end

Decimal(s::AbstractString) = parse(Decimal, s)
Decimal(x::Real) = Decimal(string(x))

macro d_str(s::String)
    parse(Decimal, s)
end

function print(io::IO, x::Decimal)
    print(io, x.q == 0 ? x.c : string(x.c) * "E" * string(x.q))
end
