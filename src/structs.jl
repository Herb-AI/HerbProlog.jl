
abstract type Prolog end

mutable struct Swipl <: Prolog
    initiated::Bool
end

Swipl() = Swipl(false)