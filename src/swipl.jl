
"""
 Functions for starting and shutting down the SWIPL instance
"""
function swipl_start(exec_path::String)
    argv = [exec_path, "-q"]
    ccall((:PL_initialise, "libswipl"), Cint, (Cint, Ptr{Ptr{UInt8}}), length(argv), argv)
end

swipl_start() = swipl_start("/usr/local/bin/swipl")

function swipl_is_initialised(exec_path::String)
    argv = [exec_path, "-q"]
    ccall((:PL_is_initialised, "libswipl"), Cint, (Cint, Ptr{Ptr{UInt8}}), length(argv), argv)
end

swipl_is_initialised() = swipl_is_initialised()

function swipl_stop(status::Int64)
    ccall((:PL_halt, "libswipl"), Cint, (Cint,), convert(Cint, status))
end

swipl_stop() = swipl_stop(0)

function swipl_cleanup(status::Int64)
    ccall((:PL_cleanup, "libswipl"), Cint, (Cint,), status)
end

swipl_cleanup() = swipl_cleanup(0)



"""
    Atoms and functors
"""

function swipl_new_atom(name::String)
    ccall((:PL_new_atom, "libswipl"), Cint, (Cstring,), name)
end

function swipl_atom_chars(term::Cint)
    ccall((:PL_atom_chars, "libswipl"), Cstring, (Cint,), term)
end

function swipl_new_functor(atom::Cint, arity::Int64)
    ccall((:PL_new_functor, "libswipl"), Cint, (Cint, Cint), atom, convert(Cint, arity))
end


function swipl_functor_name(functor::Cint)
    ccall((:PL_functor_name, "libswipl"), Cint, (Cint,), functor)
end

function swipl_functor_arity(functor::Cint)
    ccall((:PL_functor_arity, "libswipl"), Cint, (Cint,), functor)
end

function swipl_unify_nil(term::Cint)
    ccall((:PL_unify_nil, "libswipl"), Cint, (Cint,), term)
end


"""
    Testing types of terms
"""

function swipl_term_type(term::Cint)
    ccall((:PL_term_type, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_variable(term::Cint)
    ccall((:PL_is_variable, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_ground(term::Cint)
    ccall((:PL_is_ground, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_atom(term::Cint)
    ccall((:PL_is_atom, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_string(term::Cint)
    ccall((:PL_is_string, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_integer(term::Cint)
    ccall((:PL_is_integer, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_float(term::Cint)
    ccall((:PL_is_float, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_callable(term::Cint)
    ccall((:PL_is_callable, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_compound(term::Cint)
    ccall((:PL_is_compound, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_list(term::Cint)
    ccall((:PL_is_list, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_pair(term::Cint)
    ccall((:PL_is_pair, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_atomic(term::Cint)
    ccall((:PL_is_atomic, "libswipl"), Cint, (Cint,), term)
end

function swipl_is_number(term::Cint)
    ccall((:PL_is_number, "libswipl"), Cint, (Cint,), term)
end


"""
    Getting data from terms
"""

function swipl_get_integer(term::Cint)
    rint = Ref{Cint}()
    ccall((:PL_get_integer, "libswipl"), Cint, (Cint, Ref{Cint}), term, rint)
    rint[]
end

function swipl_get_bool(term::Cint)
    bval = Ref{Cint}()
    ccall((:PL_get_bool, "libswipl"), Cint, (Cint, Ref{Cint}), term, bval)
    bval[]
end

function swipl_get_atom_chrs(term::Cint)
    tmp = Cstring(C_NULL)
    ref = Ref(tmp)
    rc = ccall((:PL_get_atom_chars, "libswipl"), Cint, (Cint, Ref{Cstring}), term, ref)
    println("return code: $rc")
    tmp
end

function swipl_get_float(term::Cint)
    val = Ref{Cfloat}()
    ccall((:PL_get_float, "libswipl"), Cint, (Cint, Ref{Cfloat}), term, val)
    val[]
end

function swipl_get_name_arity(term::Cint)
    name = Ptr{Cstring}()
    ar = Ptr{Cint}()
    ccall((:PL_get_name_arity, "libswipl"), Cint, (Cint, Ref{Cint}, Ref{Cint}), term, name, ref)
    (name, ar)
end




"""
    Constructing terms
"""

function swipl_new_term_ref()
    ccall((:PL_new_term_ref, "libswipl"), Cint, ())
end

function swipl_new_term_refs(arity::Int64)
    ccall((:PL_new_term_refs, "libswipl"), Cint, (Cint,), arity)
end

function swipl_put_variable(term::Cint)
    ccall((:PL_put_variable, "libswipl"), Cvoid, (Cint,), term)
end

function swipl_put_atom(term::Cint, atom::Cint)
    ccall((:PL_put_atom, "libswipl"), Cvoid, (Cint, Cint), term, atom)
end

function swipl_put_bool(term::Cint, val::Cint)
    ccall((:PL_put_bool, "libswipl"), Cvoid, (Cint, Cint), term, val)
end

function swipl_put_atom_chars(term::Cint, name::String)
    ccall((:PL_put_atom_chars, "libswipl"), Cint, (Cint, Cstring), term, name)
end

function swipl_put_string_chars(term::Cint, name::String)
    ccall((:PL_put_string_chars, "libswipl"), Cint, (Cint, Cstring), term, name)
end

function swipl_put_integer(term::Cint, val::Int64)
    ccall((:PL_put_integer, "libswipl"), Cint, (Cint, Clong), term, val)
end

function swipl_put_float(term::Cint, val::Float64)
    ccall((:PL_put_float, "libswipl"), Cint, (Cint, Cdouble), term, val)
end

function swipl_put_functor(term::Cint, functor::Cint)
    ccall((:PL_put_functor, "libswipl"), Cint, (Cint, Cint), term, functor )
end

function swipl_put_list(term::Cint)
    ccall((:PL_put_list, "libswipl"), Cint, (Cint,), term)
end

function swipl_put_nil(term::Cint)
    ccall((:PL_put_nil, "libswipl"), Cint, (Cint,), term)
end

function swipl_put_term(term1::Cint, term2::Cint)
    ccall((:PL_put_term, "libswipl"), Cint, (Cint, Cint), term1, term2)
end

function swipl_cons_functor(term::Cint, functor::Cint, compound_term::Cint)
    ccall((:PL_cons_functor_v, "libswipl"), Cint, (Cint, Cint, Cint), term, functor, compound_term)
end