%Moradia
mora_em(ana, santana).
mora_em(raí, santana).
mora_em(bia, tatuapé).
mora_em(edu, mandaqui).
mora_em(gil, penha).
mora_em(eva, vilacarrão).

%Localização
fica_na_zona(santana, norte).
fica_na_zona(mandaqui, norte).
fica_na_zona(tatuapé, leste).
fica_na_zona(penha, leste).
fica_na_zona(vilacarrão, leste).

tem_carro(ana).
tem_carro(gil).

pode_dar_carona_a(X, Y):-
    tem_carro(X), mora_em(Y, Z), fica_na_zona(Z, W), mora_em(X, K), fica_na_zona(K, W).

