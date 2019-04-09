%************************************************************************
% Universidade de São Paulo 
% Saida deve ser codificada em -1, 1
% X - Entrada (Nxne)
% d - Saida desejada (Nxns)
% N - numero de instâncias
% ne - numero de entradas
% ns - numero de saidas
% Exemplo
        X = [0 0; 0 1; 1 0; 1 1]
        d = [ -1; -1; -1; 1]
%        W=perceptron(X,d)
% ***********************************************************************

 %data=load('iris.txt');
 %X=data(:,1:4);
 
 IRIS_SETOSA = 1;
 IRIS_VERSICOLOR = 2;
 IRIS_VIRGINICA = 3;

function W=perceptron(X,d)

N=size(X,1);     % numero de exemplos
X=[ones(N,1),X]; % adciona o termo de bias
ne=size(X,2);    % numero de entradas
ns=size(d,2);    % numero de saidas
W = rand(ns,ne)/5; %inicializa os pesos
Y=calc_saida(X,W);  %calcula a saida do perceptron
erro = Y - d; % calcula o erro
EQM = 1/N*sum(sum(erro.*erro)); %Erro quadratico médico
nit = 0;
nitmax = 10000;
vet_erro=EQM;
while EQM > 1e-6 & nit<nitmax
    nit = nit + 1;
    dJdW = calc_grad(X,d,W,N);
    dir = -dJdW;
    alfa=calc_alfa(X,d,W,dir,N);
    W = W + alfa*dir;
    Y=calc_saida(X,W);
    erro = Y - d;
    EQM = 1/N*sum(sum(erro.*erro))
    vet_erro=[vet_erro;EQM];
end
%plot(0:nit,vet_erro,'linewidth',2)
plot(0:nit,vet_erro)
xlabel('Numero de epocas')
ylabel('EQM')
title ('Evolucao do EQM')
end

function clasificar_tipos(X)
  numeroColunas = size(X,2)
  numeroTotal = size(X,1);
  indice = 0;
  tipoLista = []
  
  while indice < numeroTotal
    indice = indice + 1;
    tipo = [X(indice, numeroColunas)];
    j = 0
    valorExistente = false
    while j<size(tipoLista, 2)
      j = j+1
      if tipoLista(j) == tipo
        valorExistente = true
      end  
    end
    
    if !valorExistente
      tipoLista = [tipoLista, tipo]
    end
  end
end 

function [X]=carregaDataSet()
 data=load('dataSetIrisTiposClassified.txt');
 X=data(:,1:5);
end

function oneVsOne()

 X = carregaDataSet();
 
 matriz_setosa = seleciona_dataset_por_tipo(IRIS_SETOSA, X);
 matriz_versicolor = seleciona_dataset_por_tipo(IRIS_VERSICOLOR, X);
 matriz_virginica = seleciona_dataset_por_tipo(IRIS_VIRGINICA, X);
 
 setosa_vs_versicolor = matriz_a_vs_matriz_b(matriz_setosa, matriz_versicolor);
 setosa_vs_virginica = matriz_a_vs_matriz_b(matriz_setosa, matriz_virginica);
 versicolor_vs_virginica = matriz_a_vs_matriz_b(matriz_versicolor, matriz_virginica);
 
 [setosa_vs_versicolor_treino, setosa_validacao, versicolor_validacao]=obtem_treino_validacao(setosa_vs_versicolor);
 
 %W=perceptron(setosa_vs_versicolor_treino(:,1:4),setosa_vs_versicolor_treino(:,6));
 resultado_setosa_validacao = predicit_one(setosa_vs_versicolor_treino(:,1:4),setosa_vs_versicolor_treino(:,6), setosa_validacao(:,1:4))
 resultado_versicolor_validacao = predicit_one(setosa_vs_versicolor_treino(:,1:4),setosa_vs_versicolor_treino(:,6), versicolor_validacao(:,1:4))
 
 [setosa_vs_virginica_treino, setosa_validacao, virginica_validacao]=obtem_treino_validacao(setosa_vs_virginica);
 
 resultado_setosa_validacao = predicit_one(setosa_vs_virginica_treino(:,1:4),setosa_vs_virginica_treino(:,6), setosa_validacao(:,1:4))
 resultado_virginica_validacao = predicit_one(setosa_vs_virginica_treino(:,1:4),setosa_vs_virginica_treino(:,6), virginica_validacao(:,1:4))
 
 [versicolor_vs_virginica_treino, versicolor_validacao, virginica_validacao]=obtem_treino_validacao(versicolor_vs_virginica);
 
 resultado_versicolor_validacao = predicit_one(versicolor_vs_virginica_treino(:,1:4),versicolor_vs_virginica_treino(:,6), versicolor_validacao(:,1:4));
 resultado_virginica_validacao = predicit_one(versicolor_vs_virginica_treino(:,1:4),versicolor_vs_virginica_treino(:,6), virginica_validacao(:,1:4));
 
  
end  

function [taxa_acerto]=validacao_resultado(resultado, resultado_esperado)
   qtd_resultado_esperado = size(resultado == resultado_esperado)
   qtd_resultado = size(resultado)
   taxa_acerto = 0
   if qtd_resultado_esperado == qtd_resultado
     taxa_acerto = 100;
   else
     taxa_acerto = qtd_resultado_esperado*100/qtd_resultado
   end   
end  

function [matriz_final]=matriz_a_vs_matriz_b(ma, mb)

  ma_saida = define_saida_matriz(ma, 1)
  mb_saida = define_saida_matriz(mb, -1)
  
  matriz_final = [ma_saida; mb_saida];
end

function [data_set]=define_saida_matriz(X, saida)
  indice = 0;
  numLinhas = size(X,1)
  data_set = [];
  while indice < numLinhas
    indice = indice +1;
    data_set = [data_set; X(indice,:), saida]
  end
end  

function [matriz]=seleciona_dataset_por_tipo(tipo, dataSet)
  indice = 0;
  matriz = [];
  while indice < size(dataSet, 1)
    indice = indice + 1;
    valor = dataSet(indice,size(dataSet, 2));
    if valor == tipo
      matriz = [matriz; dataSet(indice,:)];
    end 
  end
end  

function [matrizTreino, matrizValidacaoPositiva, matrizValidacaoNegativa]=obtem_treino_validacao(X)
  matrizValoresPositivo = [];
  matrizValoresNegativos = [];
  numeroTreinoTotal = size(X,1);
  numeroColunasMatrizEntrada = size(X,2);
  
  indice = 0;
  
  while indice < numeroTreinoTotal
    indice = indice + 1;
    valorLinha = X(indice,:);
    resultadoTreino = valorLinha(numeroColunasMatrizEntrada);
    if (resultadoTreino == 1)
      matrizValoresPositivo = [matrizValoresPositivo; valorLinha];
    else 
      matrizValoresNegativos = [matrizValoresNegativos; valorLinha];
    end 
  end 
  
  numeroTreinoPositivo=size(matrizValoresPositivo,1);
  numTreino = 0;
  numTreino = numeroTreinoPositivo*0.6;
  
  numTreino = ceil(numTreino);
  numValidacao = numeroTreinoPositivo - numTreino;
  
  matrizTreino = matrizValoresPositivo(1:numTreino,:);
  matrizValidacaoPositiva = matrizValoresPositivo(1:numValidacao, :);
  matrizTreino = [matrizTreino;matrizValoresNegativos];
  matrizValidacaoNegativa = matrizValoresNegativos;
 
end

function R=predicit_one(X, d, Xv)
  W=perceptron(X,d)
  N=size(Xv,1);     % numero de exemplos
  Xv=[ones(N,1),Xv]; % adciona o termo de bias  
  R=calc_saida(Xv,W);
end

function dJdW=calc_grad(X,d,W,N)
Z=X*W';
Y= tanh(Z);
erro = Y -d;
dJdW = 1/N*((erro.*(1-Y.*Y))'*X);

end

function Y=calc_saida(X,W)
Z=X*W';
Y= tanh(Z);
end

function alfa=calc_alfa(X,d,W,dir,N)
alfa_l= 0;
alfa_u= rand;
Wnew = W + alfa_u*dir;
%*******************************************************
% calcula o alfa_u positivo
g=calc_grad(X,d,Wnew,N);
h=g(:)'*dir(:);
while h<0
    alfa_u = 2*alfa_u;
    Wnew = W + alfa_u*dir;
    g=calc_grad(X,d,Wnew,N);
    h=g(:)'*dir(:);
end
%**********************************************************
alfa_m = (alfa_l+alfa_u)/2;
k = ceil(log((alfa_u-alfa_l)/1.0e-5));
nit = 0;

while nit<k & abs(h)>1.0e-5
    Wnew = W + alfa_m*dir;
    g=calc_grad(X,d,Wnew,N);
    h=g(:)'*dir(:);
    if h>0
        alfa_u = alfa_m;
    else
        alfa_l = alfa_m;
    end
    alfa_m = (alfa_l+alfa_u)/2;
end
alfa = alfa_m;
end

W = perceptron(X,d)
