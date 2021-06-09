
@testset "SWIPL basics" begin
    prolog = Swipl()

    c = c_const("c")
    p = c_pred("p", 1)
    lit = p(c)

    start(prolog)

    assertz(prolog, lit)

    xvar = c_var("X")

    qlit = p(xvar)

    result = query(prolog, qlit)
    @assert length(result) == 1

    q = c_pred("q", 1)
    a = c_const("a")
    b = c_const("b")

    assertz(prolog, q(a))
    assertz(prolog, q(b))
    assertz(prolog, q(c))

    result2 = query(prolog, q(xvar))

    @assert length(result2) == 3

    rpred = c_pred("r", 2)

    assertz(prolog, rpred(a, b))
    assertz(prolog, rpred(a, c))

    yvar = c_var("Y")

    result3 = query(prolog, rpred(xvar, yvar))

    @assert length(result3) == 2

    f = c_functor("f", 1)

    tpred = c_pred("t", 2)

    assertz(prolog, tpred(a, f(b)))

    results4 = query(prolog, tpred(xvar, yvar))

    @assert length(results4) == 1
    @assert isa(results4[begin][yvar], Structure)

    n = c_pred("n", 1)

    assertz(prolog, n(1))
    assertz(prolog, n(15))
    results5 = query(prolog, n(xvar))

    @assert length(results5) == 2
    @assert isa(results5[begin][xvar], Int64) & isa(results5[begin+1][xvar], Int64)

    results6 = query(prolog, n(xvar); max_solutions=1)
    @assert length(results6) == 1


    number_list = List([1,2,3,4,5])
    member = c_pred("member", 2)

    results7 = query(prolog, member(xvar, number_list))
    @assert length(results7) == 5
    @assert isa(results7[begin][xvar], Int64)
    

    stop(prolog)

end

@testset "SWIPL with rules" begin
   prolog = Swipl()

   start(prolog)

   edge = c_pred("edge", 2)
   path = c_pred("path", 2)

   xvar = c_var("X")
   yvar = c_var("Y")
   zvar = c_var("Z")

   assertz(prolog, edge(1,2))
   assertz(prolog, edge(2,3))
   assertz(prolog, edge(2,4))
   assertz(prolog, edge(4,5))

   clause = path(xvar, yvar) <= edge(xvar, yvar)

   assertz(prolog, clause)

   result = query(prolog, path(xvar, yvar))

   @assert length(result) == 4

   assertz(prolog, path(xvar, yvar) <= edge(xvar, zvar) & path(zvar, yvar))

   result2 = query(prolog, path(xvar, yvar))

   @assert length(result2) == 8

   stop(prolog)

end