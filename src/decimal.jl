
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
    x = strip_trailing_zeros(x)
    s = string(x.c)
    len = length(s)
    exp = x.q + len - 1

    if abs(exp) >= 18
        s = len == 1 ? s : s[1] * '.' * s[2:end]
        s *=  'E' * string(exp)
    elseif exp >= 0
        s = x.q >= 0 ? s * '0'^x.q : s[1:exp+1] * '.' * s[exp+2:end]
    else
        n = abs(exp)
        s = '0'^n * s
        s = s[1] * '.' * s[2:end]
    end
    print(io, s)
end
