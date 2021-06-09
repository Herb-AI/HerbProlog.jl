
using HerbLanguage: c_const, c_var, c_functor, c_pred, c_type, Variable, Term, List, LPair, Literal, Negation, Constant, Predicate, Structure, Functor, Clause, Conj, get_arity

"""
    Julia -> SWIPL
"""



function to_swipl_ref(c::Constant, previous_variables::Dict{Variable,Cint}, ref::Cint)
    swipl_put_atom_chars(ref, c.name)
end

function to_swipl(c::Constant, previous_variables::Dict{Variable,Cint})
    ref = swipl_new_term_ref()
    to_swipl_ref(c, previous_variables, ref)
    ref
end

function to_swipl_ref(v::Variable, previous_variables::Dict{Variable,Cint}, ref::Cint)
    if haskey(previous_variables, v)
        swipl_put_term(ref, previous_variables[v])
    else
        swipl_put_variable(ref)
        previous_variables[v] = ref
    end
end

function to_swipl(v::Variable, previous_variables::Dict{Variable,Cint})
    if haskey(previous_variables, v)
        previous_variables[v]
    else
        tmpv = swipl_new_term_ref()
        swipl_put_variable(tmpv)
        previous_variables[v] = tmpv
        tmpv
    end
end



function to_swipl_ref(i::Int64, previous_variables::Dict{Variable,Cint}, ref::Cint)
    swipl_put_integer(ref, i)
end

function to_swipl(i::Int64, previous_variables::Dict{Variable,Cint})
    ref = swipl_new_term_ref()
    to_swipl_ref(i, previous_variables, ref)
    ref
end




function to_swipl_ref(i::Float64, previous_variables::Dict{Variable,Cint}, ref::Cint)
    swipl_put_float(ref, i)
end

function to_swipl(i::Float64, previous_variables::Dict{Variable,Cint})
    ref = swipl_new_term_ref()
    to_swipl_ref(i, previous_variables, ref)
    ref
end





function to_swipl(f::Union{Functor,Predicate}, previous_variables::Dict{Variable,Cint})
    func_atm = swipl_new_atom(f.name)
    func = swipl_new_functor(func_atm, f.arity)
    func
end




function to_swipl_ref(s::Union{Structure,Literal}, previous_variables::Dict{Variable, Cint}, ref::Cint)
    if isa(s, Structure)
        func = to_swipl(s.functor, previous_variables)
    else
        func = to_swipl(s.predicate, previous_variables)
    end

    
    compound_arg = swipl_new_term_refs(get_arity(s))#(s.functor.arity)
    struct_args = s.arguments
    to_swipl_ref(struct_args[begin], previous_variables, compound_arg)
    for ind in 1:(length(struct_args) - 1)
        to_swipl_ref(struct_args[begin+ind], previous_variables, convert(Int32, compound_arg+ind))
    end

    swipl_cons_functor(ref, func, compound_arg)
end

function to_swipl(s::Union{Structure,Literal}, previous_variables::Dict{Variable, Cint})
    structure = swipl_new_term_ref()
    to_swipl_ref(s, previous_variables, structure)
    structure
end




function to_swipl_ref(l::List, previous_variables::Dict{Variable, Cint}, ref::Cint)
    clist_term = swipl_new_term_ref()

    swipl_put_nil(ref)
    for ind in 0:length(l.elements) - 1
        to_swipl_ref(l.elements[end-ind], previous_variables, clist_term)
        swipl_cons_list(ref, clist_term, ref)
    end
end


function to_swipl(l::List, previous_variables::Dict{Variable, Cint})
    list_ref = swipl_new_term_ref()
    to_swipl_ref(l, previous_variables, list_ref)
    list_ref
end





function to_swipl_ref(p::LPair, previous_variables::Dict{Variable,Cint}, ref::Cint)
    head = swipl_new_term_ref()
    tail = swipl_new_term_ref()

    to_swipl_ref(p.head, previous_variables, head)
    to_swipl_ref(p.tail, previous_variables, tail)

    swipl_cons_list(ref, head, tail)
end

function to_swipl(p::LPair, previous_variables::Dict{Variable, Cint})
    ref = swipl_new_term_ref()
    to_swipl_ref(p, previous_variables, ref)
    ref
end







function to_swipl(n::Negation, previous_variables::Dict{Variable, Cint})
    lit_ref = to_swipl(n.literal, previous_variables)

    n_atom = swipl_new_term_ref()
    swipl_put_atom_chars(n_atom, "\\+")
    
    neg_functor = swipl_new_functor(n_atom, 1)

    neg_ref = swipl_new_term_atom()
    swipl_cons_functor(neg_ref, neg_functor, lit_ref)

    neg_ref
end






function conjoin_swipl(ls::Vector{Cint})
    if length(ls) == 1
        ls[begin]
    else
        c_atom = swipl_new_atom(",")
        conj_functor = swipl_new_functor(c_atom, 2)

        compound_arg = swipl_new_term_refs(2)
        conj = swipl_new_term_ref()
        swipl_put_term(compound_arg, ls[begin])
        swipl_put_term(convert(Int32, compound_arg + 1), conjoin_swipl(ls[begin+1:end]))
        swipl_cons_functor(conj, conj_functor, compound_arg)

        conj
    end
end



function to_swipl(cl::Clause, previous_variables::Dict{Variable,Cint})

    head_lit = to_swipl(cl.head, previous_variables)
    body_lits = [to_swipl(x, previous_variables) for x in cl.body.elements]
    body_terms = conjoin_swipl(body_lits)

    clause_atom = swipl_new_atom(":-") 
    clause_functor = swipl_new_functor(clause_atom, 2)

    entire_clause = swipl_new_term_ref()
    compound_args = swipl_new_term_refs(2)
    swipl_put_term(compound_args, head_lit)
    swipl_put_term(convert(Int32, compound_args + 1), body_terms)
    swipl_cons_functor(entire_clause, clause_functor, compound_args)

    entire_clause
end



"""
    SWIPL -> Julia
"""

function swipl_to_const(term::Cint)
    name = swipl_get_atom_chrs(term)
    if islowercase(name[begin])
        c_const(name)
    else
        c_const("\"$(name)\"")
    end
end

function swipl_to_int(term::Cint)
    convert(Int64, swipl_get_integer(term))
end

function swipl_to_float(term::Cint)
    convert(Float64, swipl_get_float(term))
end

function swipl_to_var(term::Cint, swipl_term_to_var::Dict{Cint,Variable})
    if haskey(swipl_term_to_var, term)
        swipl_term_to_var[term]
    else
        existing_names = Set(x.name for x in values(swipl_term_to_var))
        available_names = [x for x in 'A':'Z' if !in(x, existing_names)]
        if length(available_names) == 0
            available_names = ["$x$y" for x in 'A':'Z' for y in 'A':'Z' if !in("$x$y", existing_names)]
        end

        new_name = available_names[begin]
        new_var = c_var(new_name)
        swipl_term_to_var[term] = new_var
        new_var
    end
end

function swipl_to_list(term::Cint)
    elements = Vector{Term}()
    list = swipl_copy_term_ref(term)

    head = swipl_new_term_ref()

    while swipl_get_list(list, head, list)
        push!(from_swipl(head), elements)
    end

    List(elements)
end

function swipl_to_pair(term::Cint)
    head = swipl_new_term_ref()
    tail = swipl_new_term_ref()

    swipl_get_head(term, head)
    swipl_get_tail(term, tail)

    LPair(from_swipl(head), from_swipl(tail))
end
       
function swipl_to_structure(term::Cint, term_to_var::Dict{Cint,Variable})
    name, arity = swipl_get_name_arity(term)
    functor_name = swipl_atom_chars(name)
    functor = c_functor(functor_name, convert(Int64, arity))

    structure_elements = Vector{Term}()
    for arg_index in 1:arity
        elem = swipl_new_term_ref()
        swipl_get_arg(arg_index, term, elem)
        push!(structure_elements, from_swipl(elem,term_to_var))
    end

    Structure(functor, structure_elements)
end

function from_swipl(term::Cint, term_to_var::Dict{Cint,Variable})
    if swipl_is_atom(term)
        swipl_to_const(term)
    elseif swipl_is_integer(term)
        swipl_to_int(term)
    elseif swipl_is_float(term)
        swipl_to_float(term)
    elseif swipl_is_list(term)
        swipl_to_list(term)
    elseif swipl_is_compound(term)
        swipl_to_structure(term, term_to_var)
    elseif swipl_is_variable(term)
        swipl_to_var(term, term_to_var)
    else
        error("unknown term type $(swipl_term_type(term))")
    end
end

from_swipl(term::Cint) = from_swipl(term, Dict{Cint,Variable}()) 


"""
    High-level interface
"""


function start(prolog::Swipl) 
    swipl_start()
    prolog.initiated = true
end

function stop(prolog::Swipl) 
    swipl_stop()
    prolog.initiated = false
end

function cleanup(prolog::Swipl)
     swipl_cleanup()
     prolog.initiated = false
end

is_initialised(prolog::Swipl) = swipl_is_initialised()

function abstract_assert(predicate::String, prolog::Swipl, clause::Union{Clause,Literal})
    vars = Dict{Variable, Cint}()
    swipl_repr = to_swipl(clause, vars)

    asserta_pred = swipl_predicate(predicate, 1)
    query = swipl_open_query(asserta_pred, swipl_repr)
    r = swipl_next_solution(query)
    swipl_close_query(query)

    r
end

asserta(prolog::Swipl, clause::Union{Clause,Literal}) = abstract_assert("asserta", prolog, clause)
assertz(prolog::Swipl, clause::Union{Clause,Literal}) = abstract_assert("assertz", prolog, clause)

function retract(prolog::Swipl, clause::Union{Clause,Literal})
    vars = Dict{Variable, Cint}()
    swipl_repr = to_swipl(clause, vars)

    retract_pred = swipl_predicate("retract", 1)
    query = swipl_opn_query(retract_pred, swipl_repr)
    r = swipl_next_solution(query)
    swipl_close_query(query)

    r
end

function query(prolog::Swipl, literal::Literal; max_solutions::Int=-1)
    query_vars = Dict{Variable,Cint}()
    query_args = swipl_new_term_refs(literal.predicate.arity)

    for ind in 0:literal.predicate.arity-1
        to_swipl_ref(literal.arguments[begin+ind], query_vars, convert(Int32, query_args+ind))
    end

    term_to_var_map = Dict((value, key) for (key, value) in query_vars)

    pred = swipl_predicate(literal.predicate.name, literal.predicate.arity)
    query = swipl_open_query(pred, query_args)

    r = swipl_next_solution(query)

    all_solutions = Vector{Dict{Variable,Union{Term,Int64,Float64}}}()

    while r == 1 & (max_solutions != 0)
        max_solutions -= 1

        current_solution = Dict{Variable,Union{Term,Int64,Float64}}()
        for (var, value) in query_vars
            current_solution[var] = from_swipl(value, term_to_var_map)
        end

        push!(all_solutions, current_solution)

        r = swipl_next_solution(query)
    end

    swipl_close_query(query)
    all_solutions
end

has_solution(prolog::Swipl, literal::Literal) = !isempty(query(prolog, literal; max_solutions=1))








