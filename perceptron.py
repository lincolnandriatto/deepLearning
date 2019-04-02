from random import random
from math import tan
import numpy as np

X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]]);
d = [ -1, -1, -1, 1]
#W = percptrom(X, d)

def perceptron(X, d):
    N=len(X);
    X = [[0 for x in range(N)], X];
    ne = len(X[0]);
    ns = len(X[0]);
    W = [random() for i in range(ne)];
    #Y = calc_saida(X, W);
    erro = Y - d;
    EQM = 1 / N * sum(sum(erro. * erro));
    nit = 0;
    nitmax = 10000;
    vet_erro = EQM;

    while EQM > 1e-6 & nit < nitmax:
        nit = nit + 1;
        dJdW = calc_grad(X, d, W, N);
        dir = -dJdW;
        alfa = calc_alfa(X, d, W, dir, N);
        W = W + alfa * dir;
        Y = calc_saida(X, W);
        erro = Y - d;
        EQM = 1 / N * sum(sum(erro.* erro))
        vet_erro.push(EQM);

    #plot(0: nit, vet_erro, 'linewidth', 2)
    #xlabel('Numero de epocas')
    #ylabel('EQM')
    #title('Evolucao do EQM')

def calc_grad(X, d, W, N):

    Z=np.dot(X, W.T);
    Y= tan(Z);
    erro = Y -d;
    dJdW = np.dot((1/N), np.dot(((np.dot(erro, (np.dot((1-Y),Y)))).T, X)));
    return dJdW;

def calc_saida(X, W):
    Z= np.dot(X * W.T);
    Y= tan(Z);
    return Y;

def calc_alfa(X, d, W, dir, N):
    alfa_l= 0;
    alfa_u= random();
    Wnew = W + alfa_u*dir;
    #%*******************************************************
    # calcula o alfa_u positivo
    g=calc_grad(X,d,Wnew,N);
    h=g(:)'*dir(:);

    while h<0:
        alfa_u = 2*alfa_u;
        Wnew = W + alfa_u*dir;
        g=calc_grad(X,d,Wnew,N);
        h=g(:)'*dir(:);

    #**********************************************************
    alfa_m = (alfa_l+alfa_u)/2;
    k = ceil(log((alfa_u-alfa_l)/1.0e-5));
    nit = 0;

    while nit<k & abs(h)>1.0e-5:
        Wnew = W + alfa_m*dir;
        g=calc_grad(X,d,Wnew,N);
        h= np.dot(((g(:)).T), dir(:));

        if h>0:
            alfa_u = alfa_m;
        else
            alfa_l = alfa_m;

        alfa_m = (alfa_l+alfa_u)/2;
    alfa = alfa_m;
    return alfa;
