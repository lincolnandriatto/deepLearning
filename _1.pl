gerou(ana, ary).
gerou(ivo, ary).
gerou(ana, eva).
gerou(ivo, eva).
gerou(bia, rui).
gerou(bia, rai).
gerou(gil, rui).
gerou(gil, rai).
gerou(ary, noé).
gerou(paty, noé).
gerou(eva, clô).
gerou(rui, clô).
gerou(rai, lia).
gerou(gal, lia).

homem(ivo).
homem(gil).
homem(ary).
homem(rui).
homem(rai).
homem(noé).

mulher(ana).
mulher(bia).
mulher(paty).
mulher(eva).
mulher(gal).
mulher(clô).
mulher(lia).

casal(X, Y):-
    gerou(X, Z),gerou(Y, Z),
    X\=Y.

mãe(X, Y):-
    mulher(X), gerou(X, Y).

pai(X, Y):-
   homem(X), gerou(X, Y).

filho(X, Y):-
    homem(X),gerou(Y, X).

filha(X, Y):-
        mulher(X),gerou(Y, X).

irmaos(X, Y):-
    gerou(Z, X),gerou(Z, Y).

avô(X, Y):-
    homem(X),gerou(X, W),gerou(W, Y).

avó(X, Y):-
    mulher(X),gerou(X, W),gerou(W, Y).

tia(X, Y):-
    filha(X, Z),irmaos(X, W),gerou(Z, W),gerou(W, Y).

tio(X, Y):-
    filho(X, Z),irmaos(X, W),gerou(Z, W),gerou(W, Y).

prima(X, Y):-
    mulher(X),gerou(Z, X),irmaos(Z, W),gerou(W, Y).

primo(X, Y):-
    homem(X),gerou(Z, X),irmaos(Z, W),gerou(W, Y).


%Questões:
%(1) - Noé é primo de Clô?
%sim
%primo(noé, clô).
%
%(2) - Clô é prima de Lia?
%sim
%prima(clô, lia).
%
%(3) - Eva é tia de Noé?
%sim
%tia(eva, noé).
%
%(4) - Ary é tipo de Clô?
%sim
%tio(ary, clô).
%
%(5) - Ana é avó de Clô?
%sim
%avó(ana, clô).
%
%(6) - Ivo é avô de Noé?
%sim
%avô(ivo, noé).
%
%(7) - Rui é pai de Clô?
%sim
%pai(rui, clô).
%
%(8) - Gal é mãe de Lia?
%sim
%mae(gal, lia).
%
%(9) - Paty e Ary são casados?
%sim
%casal(paty, ary).
%
%(10) Noé é filho de Pat?
%sim
%filho(noé, pat).
%
%(11) - Clô é filha de Eva?
%sim
%filha(clô, eva).
%
