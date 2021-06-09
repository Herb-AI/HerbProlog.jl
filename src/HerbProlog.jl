module HerbProlog

using Base: UInt16, String
include("structs.jl")
include("swipl-bindings.jl")
include("swipl-interface.jl")

export Prolog, Swipl
export start, stop, cleanup, is_initialised, asserta, assertz, query, has_solution

module LowLevel

export swipl_start, swipl_is_initialised, swipl_start, swipl_cleanup, swipl_new_atom, swipl_atom_chars, swipl_new_functor, swipl_functor_name, swipl_functor_arity
export swipl_term_type, swipl_is_variable, swipl_is_ground, swipl_is_atom, swipl_is_string, swipl_is_integer, swipl_is_float, swipl_is_callable, swipl_is_compound, swipl_is_list, swipl_is_pair, swipl_is_atomic, swipl_is_number
export swipl_get_integer, swipl_get_bool, swipl_get_atom_chrs, swipl_get_float, swipl_get_name_arity, swipl_get_compound_name_arity, swipl_get_arg
export swipl_new_term_ref, swipl_new_term_refs, swipl_put_variable, swipl_put_atom, swipl_put_bool, swipl_put_atom_chars, swipl_put_string_chars, swipl_put_integer, swipl_put_float, swipl_put_functor, swipl_put_list, swipl_put_nil, swipl_put_term, swipl_cons_functor, swipl_copy_term_ref
export swipl_unify, swipl_unify_atom, swipl_unify_bool, swipl_unify_atom_chars, swipl_unify_string_chars, swipl_unify_integer, swipl_unify_float, swipl_unify_functor, swipl_unify_compound, swipl_unify_list, swipl_unify_nil, swipl_unify_arg
export swipl_predicate, swipl_open_query, swipl_next_solution, swipl_cut_query, swipl_close_query

end

end # module
