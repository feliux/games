function life(A,it,largo,alto)
%
% life(A,it,largo,alto)
%
% Game of Life.
%
% NOTA: proyecto no acabado. No optimizado. Población mediante matrices.
% Queda pendiente como variable de entrada las condiciones de supervivencia,
% nacimiento y muerte.
%
% Variables de entrada:
% A = población inicial (matriz inicial).
% it = iteraciones.
% largo, alto = tamaño del tablero.
%
% Ejemplo:
% vidajuego(randi([0 1],randi([3 7],1,1),randi([3 7],1,1)),100,60,60)
%
% Población según letras:
% F=[1 1 1;1 0 0;1 1 0;1 0 0;1 0 0]
% E=[1 1 1;1 0 0;1 1 1;1 0 0;1 1 1]
% L=[1 0 0;1 0 0;1 0 0;1 0 0;1 1 1]
% I=[1 0 0;1 0 0;1 0 0;1 0 0;1 0 0]
% X=[1 0 1;0 1 0;0 1 0;0 1 0;1 0 1]
% D=[1 1 1;1 0 1;1 0 1;1 0 1;1 1 1]
% A=[0 1 0;1 0 1;1 0 1;1 1 1;1 0 1]
% N=[1 0 1;0 1 0;0 1 0;0 1 0;1 0 1]
%
disp(' ')
disp(A);
[m,n]=size(A);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COFIGURAMOS MATRIZ A
%
%  Analizamos la matriz A con el objetivo de construir una matriz cuadrada par.
%  Primero añadimos columnas (si hacen falta) con el objetivo de hacerla cuadrada.
z=m-n;
if z>0
A=[A zeros(m,z)];   % Añadimos 'z' columnas de ceros.
elseif z<0
%  Segundo vemos si hay que añadir filas.
A=[A;zeros(abs(z),n)];   % Añadimos 'z' filas de ceros
end
[m,n]=size(A);  % Reescribimos el tamaño de A por si ha cambiado.
%  Tercero vemos si tiene un numero par de filas.
if rem(m,2)==1
A=[A;zeros(1,n)];   % Añadimos fila de ceros.
end
[m,n]=size(A);  % Reescribimos el tamaño de A por si ha cambiado.
%  Cuarto vemos si tiene un número par de columnas.
if rem(n,2)==1
A=[A zeros(m,1)];   % Añadimos columna de ceros
end
[m,n]=size(A);  % Reescribimos el tamaño de A por si ha cambiado.
%
% En caso de querer editar el programa o ver qué está haciendo con la matriz A,
% poner la linea siguiente para ejecutar...
%A
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURAMOS TABLERO P
%
%  Ahora construimos el tablero P con la matriz A cuadrada par en el centro...
%  Para el siguiente tablero es necesario que A sea cuadrada par.
P=[zeros((alto-m)/2,largo);zeros(m,(largo-n)/2) flipud(A) zeros(m,(largo-n)/2);zeros((alto-m)/2,largo)];
[p,q]=size(P);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPARAMOS ESTADO INICIAL TABLERO Y CONSOLA
%
a=[];b=[];c=[];d=[];e=[];f=[];g=[];h=[]; % Ver bucle while...
disp(' ')
disp('Pulsar cualquier tecla para continuar.');
disp('Pulsar CRTL+C para interrumpir el programa.');
%
%  Por ahora nuestro tablero P contendrá la matriz A invertida verticalmente.
%  Para solucionar el problema debemos hacerle un espejado vertical a la imagen.
%  Sea P la matriz imagen (tablero) y E=espejo la matriz identidad espejada (es decir,
%  con 1 en la diagonal contraria a la matriz identidad).
espejo=fliplr(eye(largo));   % Matriz identidad espejada.
% eye(largo) construye una matriz identidad de tamaño "largo".
% fliplr cambia las columnas de la matriz.
P=espejo*P;   % Realizamos el espejado vertical.
%
% La matriz P estará compuesta por casi todas las casillas con valor 0
% por lo que al pintar con imshow tendremos un tablero negro (valor 0 es black)
% con las casillas vivas de color blanco (valor 1 es white).
% Queremos un tablero blanco con las casillas vivas de color negro, para ello
% el comando ones(largo)-P es una manera práctica de cambiar los 0 por 1.
imshow(ones(largo)-P);    % Pintamos tablero
% ones(largo) construye matriz de 1 de tamaño "largo".
axis on
pause
tic
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGORITMO
%
Ps=P;     % Trabajamos sobre matriz Ps. Cambiamos a P al final del while.
i=1;      % Contador de iteraciones.
while i<=it
    for j=2:p-1   % Los for evalúan en P. Los if cambian valores en Ps. Al final P<-Ps.
        for k=2:q-1
            a=P(j-1,k-1);    % Estas son las 8 celdas adyacentes que tendremos que evaluar)
            d=P(j-1,k); 
            f=P(j-1,k+1);
            b=P(j,k-1);           
            g=P(j,k+1);
            c=P(j+1,k-1); 
            e=P(j+1,k); 
            h=P(j+1,k+1);
            total=a+b+c+d+e+f+g+h;   % Número de celdas que estan vivas.
            if P(j,k)==1   % Para una celda que está viva...
                if total==2 || total==3   % Condición supervivencia: 2,3 celdas vivas.
                    Ps(j,k)=1;
                else
                    Ps(j,k)=0;   % Condición muerte: <2,>3 celdas vivas
                end
            else    % Para una celda que está muerta (vacía)...
                if total==3   % Condición nacimiento: 3 celdas vivas.
                    Ps(j,k)=1;
                else
                    Ps(j,k)=0;
                end
            end
        end
    end
    if Ps==P
    disp(' ')
    disp('Se ha conseguido una configuracion estable')
    break
    end
    P=Ps;     % Cambiamos P
    imshow(ones(largo)-P);
    axis on
    pause(0.000001);
    i=i+1;
end
disp(' ')
fprintf('Tiempo en ejecutar las %i iteraciones: ',i-1)
toc
disp(' ')
disp('SIMULACION TERMINADA')
title('SIMULACION TERMINADA')
