animal(gato).
animal(rato).
animal(passaro).
animal(minhoca).

nome(tom, gato).
nome(jerry, rato).
nome(piupiu, passaro).
nome(moli, minhoca).

gosta(gato, rato).
gosta(gato, passaro).
gosta(passaro, minhoca).

comem(X, Y):-
    animal(X), animal(Y), nome(X,Z), nome(Y, W), gosta(Z, W).

quem_e_animal(X, Y):-
    comem(X, Y).
