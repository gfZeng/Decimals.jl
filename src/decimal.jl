
const REGEX = r"([+-]?\d*)\.?(\d*)[Ee]?([+-]?\d+)?"

bigint(s::AbstractString) = isempty(s) ? big"0" : parse(BigInt, s)
bigint(::Nothing) = 0

function parse(::Type{Decimal}, s::String)
    int, digit, exp = match(REGEX, s).captures
    ndigits = length(digit)
    exp = bigint(exp) - ndigits
    c = bigint(int * digit)
    Decimal(c, exp)
end

macro d_str(s)
    parse(Decimal, s)
end


function print(io::IO, x::Decimal)
    print(io, x.q == 0 ? x.c : string(x.c) * "E" * string(x.q))
end
