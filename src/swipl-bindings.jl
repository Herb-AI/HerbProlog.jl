
const SWIPL_LIB = "libswipl"


"""
    Flags

#ifdef PL_KERNEL
#define PL_Q_DEBUG              0x0001  /* = TRUE for backward compatibility */
#endif
#define PL_Q_NORMAL             0x0002  /* normal usage */
#define PL_Q_NODEBUG            0x0004  /* use this one */
#define PL_Q_CATCH_EXCEPTION    0x0008  /* handle exceptions in C */
#define PL_Q_PASS_EXCEPTION     0x0010  /* pass to parent environment */
#define PL_Q_ALLOW_YIELD        0x0020  /* Support I_YIELD */
#define PL_Q_EXT_STATUS         0x0040  /* Return extended status */
#ifdef PL_KERNEL
#define PL_Q_DETERMINISTIC      0x0100  /* call was deterministic */
#endif

"""

const PL_Q_DEBUG = 0x0001
const PL_Q_NORMAL = 0x0002
const PL_Q_NODEBUG = 0x0004
const PL_Q_CATCH_EXCEPTION = 0x0008
const PL_Q_PASS_EXCEPTION = 0x0010
const PL_Q_ALLOW_YIELD = 0x0020
const PL_Q_EXT_STATUS = 0x0040


"""
    Term types 

#define PL_VARIABLE      (1)            /* nothing */
#define PL_ATOM          (2)            /* const char * */
#define PL_INTEGER       (3)            /* int */
#define PL_RATIONAL      (4)            /* rational number */
#define PL_FLOAT         (5)            /* double */
#define PL_STRING        (6)            /* const char * */
#define PL_TERM          (7)

#define PL_NIL           (8)            /* The constant [] */
#define PL_BLOB          (9)            /* non-atom blob */
#define PL_LIST_PAIR     (10)           /* [_|_] term */

                                        /* PL_unify_term() */
#define PL_FUNCTOR       (11)           /* functor_t, arg ... */
#define PL_LIST          (12)           /* length, arg ... */
#define PL_CHARS         (13)           /* const char * */
#define PL_POINTER       (14)           /* void * */

"""

const PL_VARIABLE = 1
const PL_ATOM = 2
const PL_INTEGER = 3
const PL_FLOAT = 5
const PL_STRING = 6
const PL_TERM = 7
const PL_NIL = 8
const PL_LIST_PAIR = 10
const PL_FUNCTOR = 11



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
    name_to_use = collect([convert(UInt8, c) for c in name])
    ccall((:PL_new_atom, "libswipl"), Cint, (Cstring,), name) #Cstring(pointer(name)))
end

function swipl_atom_chars(term::Cint)
    r = ccall((:PL_atom_chars, "libswipl"), Cstring, (Cint,), term)
    unsafe_string(r)
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



"""
    Testing types of terms
"""

function swipl_term_type(term::Cint)
    ccall((:PL_term_type, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_variable(term::Cint)
    ccall((:PL_is_variable, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_ground(term::Cint)
    ccall((:PL_is_ground, "libswipl"), Cint, (Cint,), term) > 0 
end

function swipl_is_atom(term::Cint)
    ccall((:PL_is_atom, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_string(term::Cint)
    ccall((:PL_is_string, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_integer(term::Cint)
    ccall((:PL_is_integer, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_float(term::Cint)
    ccall((:PL_is_float, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_callable(term::Cint)
    ccall((:PL_is_callable, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_compound(term::Cint)
    ccall((:PL_is_compound, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_list(term::Cint)
    ccall((:PL_is_list, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_pair(term::Cint)
    ccall((:PL_is_pair, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_atomic(term::Cint)
    ccall((:PL_is_atomic, "libswipl"), Cint, (Cint,), term) > 0
end

function swipl_is_number(term::Cint)
    ccall((:PL_is_number, "libswipl"), Cint, (Cint,), term) > 0 
end


"""
    Getting data from terms
"""

function swipl_get_atom(term::Cint)
    atm = Ref{Cint}(0)
    rc = ccall((:PL_get_atom, "libswipl"), Cint, (Cint, Ref{Cint}), term, atm)
    atm[]
end

function swipl_get_integer(term::Cint)
    rint = Ref{Cint}(0)
    ccall((:PL_get_integer, "libswipl"), Cint, (Cint, Ref{Cint}), term, rint)
    rint[]
end

function swipl_get_bool(term::Cint)
    bval = Ref{Cint}()
    ccall((:PL_get_bool, "libswipl"), Cint, (Cint, Ref{Cint}), term, bval)
    bval[]
end

function swipl_get_atom_chrs(term::Cint)
    tmp = Ref{Cstring}(C_NULL)
    rc = ccall((:PL_get_atom_chars, "libswipl"), Cint, (Cint, Ref{Cstring}), term, tmp)
    unsafe_string(tmp[])
end


function swipl_get_float(term::Cint)
    val = Ref{Cfloat}(0)
    ccall((:PL_get_float, "libswipl"), Cint, (Cint, Ref{Cfloat}), term, val)
    val[]
end

function swipl_get_name_arity(term::Cint)
    name = Ref{Cint}(0)
    ar = Ref{Csize_t}(0)
    ccall((:PL_get_name_arity, "libswipl"), Cint, (Cint, Ref{Cint}, Ref{Csize_t}), term, name, ar)
    (name[], ar[])
end

function swipl_get_compound_name_arity(term::Cint)
    name = Ref{Cint}(0)
    ar = Ref{Csize_t}(0)
    ccall((:PL_get_compound_name_arity, SWIPL_LIB), Cint, (Cint, Ref{Cint}, Ref{Csize_t}), term, name, ar)
    (name[], ar[])
end

function swipl_get_arg(index::Csize_t, term::Cint, term_result::Cint)
    ccall((:PL_get_arg, SWIPL_LIB), Cint, (Csize_t, Cint, Cint), index, term, term_result)
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

function swipl_cons_list(term::Cint, head::Cint, tail::Cint)
    ccall((:PL_cons_list, "libswipl"), Cint, (Cint, Cint, Cint), term, head, tail)
end

function swipl_copy_term_ref(term_from::Cint)
    ccall((:PL_copy_term_ref, SWIPL_LIB), Cint, (Cint,), term_from)
end



"""
    Unification
"""

function swipl_unify(term1::Cint, term2::Cint)
    ccall((:PL_unify, SWIPL_LIB), Cint, (Cint, Cint), term1, term2)
end

function swipl_unify_atom(term1::Cint, term2::Cint)
    ccall((:PL_unify, SWIPL_LIB), Cint, (Cint, Cint), term1, term2)
end

function swipl_unify_bool(term::Cint, val::Bool)
    ccall((:PL_unify_book, SWIPL_LIB), Cint, (Cint, Cint), term, val)
end

function swipl_unify_atom_chars(term::Cint, val::String)
    ccall((:PL_unify_atom_chars, SWIPL_LIB), Cint, (Cint, Cstring), term, val)
end

function swipl_unify_string_chars(term::Cint, val::String)
    ccall((:PL_unify_string_chars, SWIPL_LIB), Cvoid, (Cint, Cstring), term, val)
end

function swipl_unify_integer(term::Cint, val::Int64)
    ccall((:PL_unify_integer, SWIPL_LIB), Cint, (Cint, Cint), term, val)
end

function swipl_unify_float(term::Cint, val::Float64)
    ccall((:PL_unify_float, SWIPL_LIB), Cint, (Cint, Cdouble), term, val)
end

function swipl_unify_functor(term::Cint, functor::Cint)
    ccall((:PL_unify_functor, SWIPL_LIB), Cint, (Cint, Cint), term, functor)
end

function swipl_unify_compound(term::Cint, functor::Cint)
    ccall((:PL_unify_compound, SWIPL_LIB), Cint, (Cint, Cint), term, functor)
end

function swipl_unify_list(term::Cint, head::Cint, tail::Cint)
    ccall((:PL_unify_list, SWIPL_LIB), Cint, (Cint, Cint, Cint), term, head, tail)
end

function swipl_unify_nil(term::Cint)
    ccall((:PL_unify_nil, SWIPL_LIB), Cint, (Cint, ), term)
end

function swipl_unify_arg(index::Int64, term::Cint, arg_term::Cint)
    ccall((:PL_unify_arg, SWIPL_LIB), Cint, (Cint, Cint, Cint), index, term, arg_term)
end


"""
    Calling Prolog
"""

function swipl_predicate(predicate_name::String, arity::Int64)
    ccall((:PL_predicate, SWIPL_LIB), Ptr{Cvoid}, (Cstring, Cint, Cstring), predicate_name, arity, C_NULL)
end

function swipl_open_query(predicate_t::Ptr{Cvoid}, term::Cint, flag::UInt16)
    ccall((:PL_open_query, SWIPL_LIB), Cint, (Ptr{Cvoid}, Cint, Ptr{Cvoid}, Cint), C_NULL, flag, predicate_t, term)
end

swipl_open_query(predicate_t::Ptr{Cvoid}, term::Cint) = swipl_open_query(predicate_t, term, PL_Q_NORMAL)

function swipl_next_solution(qid_t::Cint)
    ccall((:PL_next_solution, SWIPL_LIB), Cint, (Cint, ), qid_t)
end


function swipl_cut_query(qid_t::Cint)
    ccall((:PL_cut_query, SWIPL_LIB), Cint, (Cint, ), qid_t)
end

function swipl_close_query(qid_t::Cint)
    ccall((:PL_close_query, SWIPL_LIB), Cint, (Cint,), qid_t)
end


