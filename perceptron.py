from random import random
from math import tan, ceil, log
import numpy as np
import matplotlib.pyplot as plt

#X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]]);
#d = [ -1, -1, -1, 1]
#W = percptrom(X, d)

def init():
    X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]]);
    d = np.array([[ -1], [-1], [-1], [1]]);
    perceptron(X, d);

def perceptron(X, d):
    N=len(X);
    X = np.concatenate((np.ones((N, 1)), X), axis=1)
    ne = np.size(X, 1);
    ns = np.size(d, 1);
    W = np.random.rand(ns, ne)/5;
    Y = calc_saida(X, W);
    erro = Y - d;
    EQM = 1 / N * sum(sum(erro * erro));
    nit = 0;
    nitmax = 10000;
    vet_erro = [];
    vet_erro.append(EQM);

    while EQM > 1e-6 and nit < nitmax:
        nit = nit + 1;
        dJdW = calc_grad(X, d, W, N);
        dir = -dJdW;
        alfa = calc_alfa(X, d, W, dir, N);
        W = W + alfa * dir;
        Y = calc_saida(X, W);
        erro = Y - d;
        EQM = 1 / N * sum(sum(erro * erro))
        vet_erro.append(EQM);

    #plot(0: nit, vet_erro, 'linewidth', 2)
    #xlabel('Numero de epocas')
    #ylabel('EQM')
    #title('Evolucao do EQM')
    plt.plot(vet_erro)
    plt.title("Evolução do EQM")
    plt.show()

def calc_grad(X, d, W, N):
    Z = np.dot(X, W.T);
    Y = np.tan(Z);
    erro = Y - d;
    dJdW = np.dot((1/N), np.dot((erro * (1-Y * Y)).T, X));
    return dJdW;

def calc_saida(X, W):
    Z= np.dot(X, W.T);
    Y= np.tan(Z);
    return Y;

def calc_alfa(X, d, W, dir, N):
    alfa_l= 0;
    alfa_u= random();
    Wnew = W + alfa_u*dir;
    #%*******************************************************
    # calcula o alfa_u positivo
    g=calc_grad(X,d,Wnew,N);
    h=np.dot(g.flatten().T, dir.flatten());

    while h < 0:
        alfa_u = 2*alfa_u;
        Wnew = W + np.dot(alfa_u, dir);
        g=calc_grad(X,d,Wnew,N);
        h=np.dot(g.flatten().T, dir.flatten());

    #**********************************************************
    alfa_m = (alfa_l+alfa_u)/2;
    k = ceil(log((alfa_u-alfa_l)/1.0e-5));
    nit = 0;

    while nit < k and abs(h) > 1.0e-5:
        Wnew = W + alfa_m*dir;
        g = calc_grad(X, d, Wnew, N);
        h = np.dot(g.flatten().T, dir.flatten());
        nit = nit + 1;
        if h>0:
            alfa_u = alfa_m;
        else:
            alfa_l = alfa_m;

        alfa_m = (alfa_l+alfa_u)/2;
    alfa = alfa_m;
    return alfa;

init()
