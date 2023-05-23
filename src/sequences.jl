# Copied from TypedPolynomials
module Sequences

import MutableArithmetics
const MA = MutableArithmetics

function merge_sorted!(
    result,
    v1::AbstractArray,
    v2::AbstractArray,
    compare,
    combine,
    filter = x -> !iszero(x),
)
    i = firstindex(result)
    i1 = firstindex(v1)
    i2 = firstindex(v2)
    while i1 <= lastindex(v1) && i2 <= lastindex(v2)
        x1 = v1[i1]
        x2 = v2[i2]
        Δ = compare(x1, x2)
        if Δ < 0
            if filter(x1)
                result[i] = x1
                i += 1
            end
            i1 += 1
        elseif Δ > 0
            if filter(x2)
                result[i] = x2
                i += 1
            end
            i2 += 1
        else
            c = combine(x1, x2)
            if filter(c)
                result[i] = combine(x1, x2)
                i += 1
            end
            i1 += 1
            i2 += 1
        end
    end
    for j in i1:lastindex(v1)
        if filter(v1[j])
            result[i] = v1[j]
            i += 1
        end
    end
    for j in i2:lastindex(v2)
        if filter(v2[j])
            result[i] = v2[j]
            i += 1
        end
    end
    resize!(result, i - 1)
    return result
end

function merge_sorted(
    v1::AbstractArray,
    v2::AbstractArray,
    compare,
    combine = Base.:+,
    filter = x -> !iszero(x),
)
    T = MA.promote_operation(combine, eltype(v1), eltype(v2))
    result = Vector{T}(undef, length(v1) + length(v2))
    return merge_sorted!(result, v1, v2, compare, combine, filter)
end

end
