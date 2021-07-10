# Little Study Cases  About ARM/LEG language 

## case 00 
MC404 -- case 00 -- Familiarização com as ferramentas LEG
Nesta case você vai se familiarizar com as ferramentas para o processador LEG: o montador (lasm) e o simulador (legsim).

1) Instalando as ferramentas
O montador lasm e o simulador legsim são programas em java, que você deve copiar para o seu computador. Para instalar os dois programas, siga as instruções na página Ferramentas LEG.

Opcionalmente, você pode usar um ambiente especialmente preparado para MC404 no Cloud 9. Para isso será necessário que você envie uma solicitação de registro para ranido arroba ic ponto unicamp ponto br. Você receberá um convite que permitirá cadastrar-se no Cloud 9 sem necessidade de informar um cartão de crédito.

2) case
Escreva um programa para calcular o valor da expressão

4*(0x5000 + 0x200)
usando apenas os registradores r0 e r1, e deixando o resultado no registrador r0. O seu programa deve ser montado a partir do endereço 0x200.
Parte A: montando o programa manualmente
Consulte as notas de aula (Introdução a organização de computadores e Introdução a linguagens de montagem) e determine a codificação das instruções necessárias para construir o programa.
Abra uma janela de terminal e inicie o simulador legsim, digitando

legsim

no terminal. O programa legsim iniciará colocando um "prompt" na tela:

Insira as instruções manualmente na memória usando o comando iw (inspect word), a partir de um endereço qualquer (por exemplo, 0x200), digitando

iw 200

na linha de comando do simulador. Note o simulador utiliza a notação hexadecimal para todos os valores. Assim 200 representa o hexadecimal 0x200.
Para terminar a inspeção de palavras com o comando iw, digite um ponto ('.') na linha de comando do simulador. Termine seu programa com a instrução "hlt" (halt), para parar a execução. A instrução hlt tem a codificação 0x74000000 e interrompe a execução do processador.

Por exemplo, este é o resultado após a inserção da instrução "carrega registrador r1 com o valor constante 0x5000", seguida da instrução "halt":


Visualize o que foi inserido na memória com o comando d (display memory), a partir do endereço inicial do seu programa, usando o comando d (display), digitando

d 200

na linha de comando do simulador.
Por exemplo, este é o resultado do comando d após a inserção das duas instruções acima:


Note como os bytes são mostrados no comando d: para cada linha, à esquerda é mostrado o endereço, seguido dos valores de 16 bytes, seguido da representação em ASCII de cada byte (para o caso de os bytes representarem carateres). A cada linha o endereço avança 16 bytes.

(O LEG usa a ordem little-endian ou big-endian?)

Visualize o que foi inserido na memória com o comando u (unassemble), a partir do endereço inicial do seu programa, digitando

u 200

na linha de comando do simulador.
Por exemplo, este é o resultado do comando u após a inserção das duas instruções acima:


Observe como o comando desmonta o conteúdo da memória (ou seja, executa a operação inversa do montador: transforma código de máquina em comandos de linguagem de montagem). Para cada linha, à esquerda é mostrado o endereço, seguido dos valores de 16 bytes, seguido da representação em ASCII de cada byte (para o caso de os bytes representarem carateres). A cada linha o endereço avança 16 bytes.

Confira os valores dos registradores usando o comando x (show status), digitando

x

na linha de comando do simulador. Esse comando mostra o valor corrente de todos os registradores:

Note que todos os registradores têm o valor zero, inclusive o registrador apontador de instruções ip (porque o processador acabou de ser "ligado").
Execute o seu programa com o comando g (go), a partir do endereço inicial do seu programa (), digitando

g 200

na linha de comando do simulador.
O processador executa o programa (duas instruções, no nosso exemplo!), e ao encontrar a instrução "halt" interrompe a execução. Ao parar a execução, o simulador informa a razão ("HALT at 0x208"), o estado dos registradores e a próxima instrução a ser executada (a instrução HLT é um caso especial, pois o processador não executa mais nenhuma instrução, por isso no exemplo abaixo a proxima instrução a ser executada é a mesma instrução HLT, no mesmo endereço de memória).


Observe que o registrador r1 teve o seu valor alterado para 0x5000 no caso do nosso exemplo. No caso do seu programa, verifique que o valor do registrador r0 tem o valor correto do resultado da expressão dada, como solicitado na case deste laboratório.

Apenas para mostrar outras funcionalidades, altere os valores dos registradores r0 e r1, para iniciar uma nova execução do programa, usando o comando r (display and alter register), digitando os comandos

r r0
r r1

na linha de comando do simulador (o simulador indica o valor corrente do registrador, você pode entrar com um novo valor):

Use o comando x (show status) para mostrar o novo estado dos registradores:

Note que os registradores r0 e r1 têm novos valores.

Execute o seu programa passo-a-passo (uma instrução por vez), com comandos s (step) sucessivos, a partir do endereço inicial do seu programa. Inicie digitando

s 200

na linha de comando do simulador. O simulador vai executar uma instrução e parar, mostrando um trecho de programa "desmontado" da memória, com a próxima instrução em destaque (highlighted), seguida do estado dos registradores:

Para executar a próxima instrução, use novamente o comando s (dessa vez sem indicar o endereço inicial). Ou mais simplesmente, tecle "entra" ("return"), pois o simulador sempre executa o comando anterior (s nesse caso) quando a linha de comando é vazia. Execute todas as instruções de seu programa e vá conferindo o valor dos registradores.
Para terminar a simulação, use o comando q (quit), que termina a execução do simulador.

Parte B: montando o programa com o montador LEG (lasm)
Usando um editor de texto, escreva um programa usando as instruções set e add vistas em aula. Use a diretiva .org 0x200 para que seu programa seja montado a partir do endereço 0x200. Nomeie o arquivo do programa por exemplo de case00.s.
Aqui está um exemplo de programa contendo apenas duas instruções:

@ meu primeiro programa

    .org 0x200

start:                 @ um rótulo padrão, vamos usar no Susy
    set   r0, 0x5000   @ uma instrução exemplo
    hlt                @ esta instrução faz com que o montador interrompa
                       @ a execução
Abra uma janela de terminal use o montador lasm para montar o seu programa, digitando

lasm -o case00 case00.s

no terminal. Esse comando cria um arquivo de nome case00, que é um arquivo binário contendo o seu programa.
Abra uma janela de terminal e inicie o simulador legsim, carregando o seu programa, digitando

legsim -l case00

no terminal.
Execute o seu programa digitando

g start

no terminal. Observe que você pode usar no simulador rótulos definidos no seu programa (como start). Verifique o registrador r0 tem o resultado correto da expressão dada.
Submeta o seu programa-fonte em linguagem de montagem do LEG, usando o sistema Susy. O arquivo de submissão deve chamar-se case00.s, e a primeira instrução de seu programa deve estar no endereço 0x200.
Peso
O peso deste lab na composição da nota é 1.

## case 01 

MC404 -- case 01 -- Invertendo uma sequência de caracteres
Escreva um programa em linguagem de montagem LEG para inverter uma dada cadeia de caracteres ASCII. Por exemplo, se a cadeia de entrada é

ABCDEF1234
o seu programa deve produzir a cadeia

4321FEDCBA
A primeira instrução a ser executada pelo seu programa deve estar no endereço de rótulo start. Ao terminar de inverter a cadeia, seu programa deve executar a instrução HLT (interrompe processamento).

Entrada
A cadeia de caracteres a ser invertida inicia no endereço 0x1000. Um byte com o valor 0x00 indica o final da cadeia (e não deve ser incluído na inversão!). A cadeia contém no máximo 15 caracteres e no mínimo um caractere (não contando o byte indicador de final).
Saída
A cadeia de caracteres invertida deve iniciar também no endereço 0x1000 (ou seja, a cadeia deve ser invertida no mesmo lugar em que é dada).
Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem LEG. O arquivo de submissão deve chamar-se case01.s. A primeira instrução a ser executada pelo seu programa deve estar no endereço de rótulo start.
Peso
O peso deste lab na composição da nota é 1.


## case 02

MC404 -- case 02 -- Soma de vetores
São fornecidos

um vetor de inteiros sem sinal, de 16 bits, com elementos armazenados consecutivamente (dois elementos por palavra) a partir do endereço 0x108, de rótulo vetor;
um valor que é uma potência de 2 (entre 2,4,8), armazenado numa palavra de memória (32 bits) cujo rótulo é divisor, e endereço 0x100.
O número de elementos do vetor, dado em uma palavra de memória (32 bits) cujo rótulo é num_elem (valor entre 1 e 16), cujo endereço é 0x104.
Escreva um programa em linguagem de montagem LEG para calcular a soma dos elementos de vetor divididos pelo valor de divisor (ou seja, cada elemento deve ser dividido por divisor e o resultado deve ser a soma de todos esses valores). O resultado deve ser colocado no registrador r0.
Por exemplo, se vetor tem inicialmente os valores [5,12,1,16,3,27,0] e o valor de divisor é 4, ao final da execução de seu programa r0 deve conter o valor 14 (soma dos valores [1,3,0,4,0,6,0]).

A primeira instrução a ser executada pelo seu programa deve estar no endereço de rótulo init. Ao terminar seu programa deve executar a instrução HLT (interrompe processamento).

Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem LEG. O arquivo de submissão deve chamar-se case02.s. O número máximo de submissões no Susy é 10. Teste exaustivamente seu programa localmente, usando o simulador LEG; não use o Susy como ferramenta de teste!
Peso
O peso deste lab na composição da nota é 1.


## case 03

MC404 -- case 03 -- Soma de vetor de 64 bits
Parte A
Escreva uma função de nome add64 com dois parâmetros, que são números inteiros sem sinal de 64 bits, passados pela pilha, e calcule a soma desses dois números, retornando o resultado nos registradores r1 (palavra mais significativa do resultado) e r0 (palavra menos significativa do resultado). Sua função pode desconsiderar erros de estouro de campo.

Cada parâmetro de 64 bits é empilhado da seguinte forma: primeiro é empilhada a palavra (32 bits) mais significativa, depois a palavra (32 bits) menos significativa do parâmetro.

Por exemplo, se os argumentos da função são

0x11111111AAAAAAAA e 0x22222222AAAAAAAA
respectivamente, em decimal, 1229782940824283818 e 2459565878785256106, a pilha no momento da execução da função é:

   |          |
   ------------
   | 11111111 |
   ------------
   | AAAAAAAA |
   ------------
   | 22222222 |
   ------------
   | AAAAAAAA | <-- sp
   ------------
   |          |

e o resultado deve ser
r1=0x33333334 e r0=0x55555554
Por razões de testes no Susy, o início da função (rótulo add64) deve estar no endereço 0x1000.

Parte B
Escreva um trecho de programa, cujo endereço de início é 0x2000 e tem rótulo init, que calcule a soma dos elementos de um vetor de números de 64 bits, deixando o resultado nos registradores r1 (parte mais significativa do resultado) e r0 (parte menos significativa do resultado). O vetor, com um máximo de 100 elementos, está armazenado a partir do endereço 0x104, de rótulo vetor. O número de elementos está armazenado em uma palavra de 32 bits de rótulo num_elem (inteiro sem sinal), no endereço 0x100.

Você pode assumir que o número de elementos do vetor é maior ou igual a 1.

Assuma que na memória, um número de 64 bit é armazenado da seguinte forma:

a palavra menos significativa (32 bits) é armazenada no endereço X e
a palavra mais significativa (32 bits) é armazenada no endereço X+4.
A primeira instrução a ser executada pelo seu programa deve estar no endereço de rótulo init. Lembre que você tem que reservar espaço para a pilha e inicializar o registrador apontador de pilha (sp).

Ao terminar seu programa deve executar a instrução HLT (interrompe processamento).

Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem LEG. O arquivo de submissão deve chamar-se case03.s. O número máximo de submissões no Susy é 10. Teste exaustivamente seu programa localmente, usando o simulador LEG; não use o Susy como ferramenta de teste!
Peso
O peso deste lab na composição da nota é 1.



## case 04

MC404 -- case 04 -- Calculadora binária
Nesta case você deve construir uma calculadora binária. Para simplificar, a calculadora vai ter apenas uma operação, de multiplicação. E para simplificar ainda mais, o valor inicial da calculadora deve ser 1. Esta case não pode ser feita no Cloud 9, pois este não tem suporte para elementos gráficos como os leds e o teclado!

Parte A
Escreva uma função de nome multiplica com dois parâmetros (números inteiros sem sinal, 32 bits), passados pela pilha, que retorna em r0 o valor resultante da multiplicação dos dois parâmetros passados. Considere que os parâmetros são valores relativamente baixos que não causarão estouro de campo do resultado.

Dica: tem uma função quase pronta nas notas de aula! (mas a passagem dos parâmetros é por registrador).

Parte B
Escreva uma função de nome read, sem parâmetros, que espera o usuário teclar um número hexadecimal de dois dígitos, seguidos da tecla '*' (ou da tecla '#', veja a seguir), e retorna em r0 o valor do número hexadecimal teclado e em r1 o valor da última tecla pressionada (correspondente a '#' ou '*'). Por exemplo, se o usuário pressionar a tecla "3" seguida da tecla "8" seguida da tecla "*", a função deve retornar em r0 o valor 0x38 e em r1 o valor 10 (o teclado devolve esse valor para a tecla '*'). Se o o usuário pressionar a tecla "0" seguida da tecla "5" seguida da tecla "#", a função deve retornar em r0 o valor 0x05 e em r1 o valor 11 (o teclado devolve esse valor para a tecla '#').

Você pode considerar que o usuário sempre vai digitar dois dígitos e depois a tecla '*' ou a tecla '#', e que não ocorrerá erro de atropelamento (overrun) no teclado (ou seja, o usuário é lento para digitar, seu programa vai conseguir tratar a tecla antes que outra seja pressionada). Note que, como o teclado não tem teclas para os dígitos hexadecimais de 'a' a 'f', a calculadora somente conseguirá multiplicar números hexadecimais que contenham apenas os dígitos de '0' a '9'!

O dispositivo teclado deve usar as portas 0x80 (porta de dados) e 0x81 (porta de estado). Não vimos ainda "interrupções", portanto esse parâmetro do dispositivo deve ser 0x00. Por exemplo, uma descrição possível do dispositivo teclado para o simulador é:

%keyboard CalcPlus
0x80 0x81 0x00
Parte C
Escreva um programa para construir uma calculadora binária, que efetua apenas operações de multiplicação.

Um painel de oito leds, conectado à porta 0x40, deve ser usado para mostrar o resultado. Inicialmente, o painel de leds deve conter o valor inicial da calculadora, que é 1. Por exemplo, a seguinte descrição pode ser usada para definir o painel de oito leds para o simulador:

%leds Resultado
rrrrrrrr 0x40
Ao iniciar o programa, o painel de resultado deve mostrar o valor 1. Esse é o valor corrente da calculadora. O usuário deve então digitar um número de dois dígitos seguido da tecla '*' ou da tecla '#' (seu programa deve usar a função read). A calculadora deve efetuar a multiplicação do valor corrente com o valor digitado, atualizar o valor corrente com o valor do resultado (seu programa deve utilizar a função multiplica), e atualizar o painel de leds com o resultado. A calculadora deve então esperar que o usuário digite um novo valor de dois dígitos, seguido da tecla '*', e o processo de multiplicação continua até que o usuário digite dois dígitos seguidos da tecla '#'.

Seu programa deve executar continuamente, efetuando as multiplicações, até o usuário teclar dois dígitos seguidos da tecla '#', quando então seu programa deve parar de executar (use a instrução HLT para parar a execução do programa no simulador).

A primeira instrução a ser executada pelo seu programa deve estar no endereço de rótulo init. Lembre que você tem que reservar espaço para a pilha e inicializar o registrador apontador de pilha (sp).

Por razões de testes no Susy, você não deve utilizar a memória abaixo do endereço 0x1000.

Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem LEG. O arquivo de submissão deve chamar-se case04.s. O número máximo de submissões no Susy é 10. Teste exaustivamente seu programa localmente, usando o simulador LEG; não use o Susy como ferramenta de teste!
Peso
O peso deste lab na composição da nota é 1.

## case 05

MC405 -- case 05 -- Contador temporizador
Nesta case você deve construir um contador (de tempo) decrescente, que pode ser usado como um temporizador. Para simplificar, o contador vai ter apenas um dígito decimal.

O contador vai ser composto por um teclado e um por um display de sete segmentos. O usuário pode escolher um valor (entre 0 e 9) usando o teclado. O contador mostra o valor escolhido pelo usuário e inicia a contagem regressiva, atualizando o valor no display a cada segundo, até o display mostrar o valor zero. Como veremos, o contador não vai marcar o tempo de forma precisa; veremos no futuro como implementar um temporizador mais preciso.

O contador deve iniciar mostrando o valor zero. Se o usuário digitar a tecla 3, o contador deve mostrar o valor 3 no display, esperar um segundo (mais ou menos!), mostrar o valor 2 no display, esperar um segundo, mostrar o valor 1, esperar um segundo, mostrar o valor 0 e esperar pela próxima entrada do usuário.

Esta case não pode ser feita no Cloud 9, pois este não tem suporte para elementos gráficos como o teclado!

Parte A
Escreva uma rotina de tratamento de interrupção do teclado, que simplesmente atualize o valor de uma variável de nome contador com o valor da tecla pressionada pelo usuário.

Dica: tem uma rotina de tratamento do teclado nas notas de aula!

Parte B
Escreva um procedimento de nome mostra, com um parâmetro (um valor entre 0 e 9), passado pelo registrador r0 e mostra esse valor no display de sete segmentos.

Parte C
Escreva um procedimento de nome decrementa que recebe em r0 um valor entre 0 e 9, mostra esse valor inicial, espera um certo tempo, decrementa e mostra o novo valor, espera um certo tempo, decrementa e mostra o novo valor, etc, até que o valor seja zero, A espera deve ser feita com um "loop de espera", que apenas gasta tempo, por exemplo inicializando um registrador qualquer com um valor específico e decrementando o valor desse registrador até que seja igual a zero.

Você deve ler o valor específico usado na espera de uma variável de nome intervalo. (Obs.: no meu laptop, para conseguir um tempo de mais ou menos um segundo usando um loop simples como o descrito acima, essa variável deve ser inicializada com o valor 0x400000. No Susy, o valor dessa variável vai ser bem mais baixo, para executar mais rápido, já que esse loop de espera apenas gasta tempo, mas para verificar visualmente ele tem que ser alto).

O dispositivo teclado deve usar as portas 0x80 (porta de dados) e 0x81 (porta de estado), e deve usar a interrupção de tipo 0x10. Você deve obrigatoriamente usar interrupções, caso contrário sua nota será drasticamente reduzida! Note que, usando interrupções, você não precisa consultar a porta de estado do teclado, a não ser que queira tratar erros de atropelamento (mas não precisa!).

Por exemplo, uma descrição possível do dispositivo teclado para o simulador é:

%keyboard Entrada
0x80 0x81 0x10
e uma descrição possível do display de sete segmentos é
%7segs  Contador
0x20
Parte D
Escreva um programa para construir o Contador temporizador, usando as funções definidas acima.

Seu programa deve executar continuamente, efetuando a temporização com o valor inicial digitado pelo usuário no teclado. Seu programa deve escrever no display de sete segmentos o menor número de valores possíveis para que o temporizador esteja correto. Em outras palavras, você não deve escrever no display o valor que já está no display. Por exemplo, se o display mostra o valor 0, você não deve escrever o valor correspondente a 0 novamente na porta do display.

A primeira instrução a ser executada pelo seu programa deve estar no endereço de rótulo init. Lembre que você tem que reservar espaço para a pilha, inicializar o registrador apontador de pilha (sp), inicializar o vetor de interrupções e habilitar interrupções (com a instrução 'sti').

Por razões de testes no Susy, você não deve utilizar a memória abaixo do endereço 0x1000.

Simplificações
Você pode assumir que:

O usuário não vai pressionar qualquer tecla enquanto o temporizador estiver contando.
O usuário sempre vai digitar apenas um dígito, e esperar o temporizador contar.
O usuário não vai pressionar as teclas '*' ou '#'.
Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem LEG. O arquivo de submissão deve chamar-se case05.s. O número máximo de submissões no Susy é 10. Teste exaustivamente seu programa localmente, usando o simulador LEG; não use o Susy como ferramenta de teste!
Peso
O peso deste lab na composição da nota é 1.



## case 06

MC404 -- case 06 -- Tudo em Maiúsculas
Escreva um programa que leia do console uma cadeia de caracteres ASCII, com no máximo 256 caracteres, transforme as letras minúsculas da cadeia em maiúsculas, e escreva o resultado de volta no console. Ao final o registrador r10 deve conter o número de letras que foram alteradas.

Para escrever no console seu programa deve usar as chamadas ao sistema read e write. Consulte no manual de dispositivos a forma de utilização do console.

Para a chamada read o vetor onde devem ser armazenados os bytes lidos deve estar obrigatoriamente no endereço 0x2000.

Ao término da execução, seu programa deve usar a chamada ao sistema exit(0).

A primeira instrução a ser executada pelo seu programa deve estar no endereço de rótulo init. Lembre que você tem que reservar espaço para a pilha, inicializar o registrador apontador de pilha (sp).

Por razões de testes no Susy, você não deve utilizar a memória abaixo do endereço 0x1000.

Exemplo
Se a cadeia de entrada for
Meu burro custou R$ 100,00, mas nao o vendo por dinheiro algum.
a saída no console deve ser
MEU BURRO CUSTOU R$ 100,00, MAS NAO O VENDO POR DINHEIRO ALGUM.
e o registrador r10 deve conter o valor 0x29 (41 em decimal).
Note que as letras na entrada não são acentuadas (a codificação é ASCII).

Entrada
A entrada é feita pelo console.
Saída
A saída é feita através do console e do registrador r10.
Esta case não pode ser feita no Cloud 9, pois este não tem suporte para elementos gráficos como o console!

Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem LEG. O arquivo de submissão deve chamar-se case06.s. O número máximo de submissões no Susy é 10. Teste exaustivamente seu programa localmente, usando o simulador LEG; não use o Susy como ferramenta de teste!
Peso
O peso deste lab na composição da nota é 1.
Dicas
O parâmetro r0 da chamada ao sistema exit deve ser igual a zero, para indicar que o programa terminou de executar sem erros.
Note que a diferença na representação ASCII entre uma letra maiúscula e uma minúscula é apenas um bit; portanto basta trocar o valor desse bit para transformar uma letra de maiúscula para minúscula (e vice-versa).
Veja nas notas de aula um exemplo de programa que usa chamada a sistema.
Note que é necessáro usar a opção "-c" do legsim para "caregar" o dispositivo console na simulação (legsim -c).

## case 07

MC404 -- case 07 -- Familiarização com as ferramentas ARM
Nesta case você vai se familiarizar com as ferramentas para o processador ARM: os programas da família GNU (montador e ligador) e o simulador (armsim).

Instalando as ferramentas
O simulador armsim é um programa em java, que você deve copiar para o seu computador. Vamos utilizar o montador e o ligador GNU para a arquitetura ARM (veremos mais adiante no curso como esses dois programas operam). Para instalar os programas, siga as instruções na página Ferramentas ARM.

case
Escreva um programa em linguagem de montagem ARM para escrever na console uma cadeia de 16 caracteres, com o valor 'Um teste simples', utilizando a chamada a sistema write. Você deve também utilizar a chamada a sistema exit para terminar a execução de seu programa.

Montando o programa com as ferramentas GNU
Abra uma janela de terminal e use o montador arm-none-eabi-as para montar o seu programa, e o ligador arm-none-eabi-ld para criar o arquivo executável digitando
arm-none-eabi-as -o case07.o case07.s
arm-none-eabi-ld -o case07 case07.o
no terminal. Esses dois comandos criam um arquivo de nome case07, que é um arquivo binário contendo o seu programa.
Note que é necessário utilizar dois programas para criar o arquivo executável do ARM: o montador e o ligador. Veremos mais adiante no curso como eles funcionam.
Abra uma janela de terminal e inicie o simulador armsim, carregando o seu programa, digitando
armsim -c -l case07
no terminal (note que como o programa usa o console, é necessário especificar a opção "-c").
Execute o seu programa digitando
g _start
no terminal.
Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem ARM. O arquivo de submissão deve chamar-se case07.s, e a primeira instrução de seu programa deve estar no endereço de rótulo _start. Por razões de testes no Susy, o rótulo deve _start estar no endereço 0x1000 (use a diretiva .org).
O número máximo de submissões no Susy é 10. Teste exaustivamente seu programa localmente, usando o simulador armsim; não use o Susy como ferramenta de teste!

Peso
O peso deste lab na composição da nota é 1.
Dicas
Tem um exemplo de programa ARM usando as chamadas ao sistema write e exit nas notas de aula!
A instrução de chamada ao sistema swi no ARM é muito similar à instrução de chamada de sistema do sys LEG.
Note que o seu programa deve conter uma linha com a diretiva .global _start (o ligador usa essa informação, veremos mais adiante no curso).
Note também que no exemplo de programa os valores númericos são sempre precedidos pelo caractere `#' (como na instrução mov r0,#1).
Não vimos ainda instruções do ARM, mas você provavelmente consegue interpretar o programa de exemplo. Neste lab você tem que fazer uma pequena modificação no programa exemplo. Nas próximas aulas veremos em detalhes as instruções do ARM.
Nesta case você tem apenas introduzir a cadeia no programa.

## case 08 

MC404 -- case 08 -- Palíndromo em bits
Escreva um programa em linguagem de montagem ARM para

ler do console uma cadeia de caracteres hexa (0-9 e A-F); o número de caracteres lidos pode estar entre 1 e 8 (o valor tem no máximo 32 bits).
verificar se o valor hexa que essa cadeia representa é um palíndromo em bits
escrever no console uma linha contendo o caractere 'N' se for palíndromo, ou o caractere 'S' caso contrário (não se esqueça do caractere final de linha, '\n')
O seu programa deve terminar quando o valor de entrada for zero (utilize a chamada a sistema exit para terminar a execução de seu programa).
Um valor é palíndromo em bits quando, na sua representação binária, os bits lidos da esquerda para a direita são os iguais aos bits lidos da direita para a esquerda. Por exemplo, os valores 0x88800111 0x40000002 são palíndromos, mas os valores 0x88888888 e 0x11111111 não são palíndromos. Note que na entrada pela console o prefixo '0x' não é utilizado.

Por exemplo, se for digitado no console 8888111, seu programa deve escrever uma linha contendo apenas a letra `S' no console. A seguir, se for digitado no console 1111, seu programa deve escrever uma linha contendo apenas a letra `N' no console. A seguir, se for digitado no console 0, seu programa deve parar de executar, executando a chamada a sistema exit.

Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem ARM. O arquivo de submissão deve chamar-se case08.s, e a primeira instrução de seu programa deve estar no endereço de rótulo _start.
O número máximo de submissões no Susy é 10. Teste exaustivamente seu programa localmente, usando o simulador armsim; não use o Susy como ferramenta de teste!

Peso
O peso deste lab na composição da nota é 1.


## case 10

MC404 -- case 10 -- Semáforos com temporizador
Nesta case vamos exercitar o uso de interrupções, e também usar um novo dispositivo: o temporizador (timer).

O temporizador é um dispositivo que gera uma interrupção a cada intervalo de tempo programado. O temporizador tem apenas uma porta de dados, de escrita apenas, que é usada para programar o intervalo de tempo. Escrever um valor X na porta do temporizador faz com que o temporizador gere uma interrupção a cada X milisegundos. Escrever o valor zero na porta do temporizador faz com que o temporizador pare de gerar interrupções. No arquivo de dispositivos para o simulador armsim, o formato de descrição de um temporizador é:

%timer
PORTA INT
PORTA é o endereço da porta de dados, e INT é o tipo de interrupção associado.

Para usar interrupções no ARM, é preciso preparar as pilhas dos modos que vamos usar, e inicializar o vetor de interrupções, antes de entrar no modo usuário e habilitar interrupções. Veja aqui um programa exemplo que usa interrupção. Para mudar de um modo de execução para outro (por exemplo Supervisor para IRQ), durante a preparação, você deve usar uma instrução especial, msr. Note no entanto que o uso dessa instrução somente é permitido em modos privilegiados -- uma vez que seu programa está em modo Usuário ele não tem mais privilégio para mudar de modo. Veja mais detalhes no exemplo e nas notas de aula.

case
Escreva um programa em linguagem de montagem ARM para controlar os semáforos de cruzamento de duas ruas. O programa deve controlar dois semáforos (um para cada rua), cada um com três luzes, vermelha, amarela e verde, além de um mostrador de dois dígitos para indicar o tempo que falta para mudança de estado do semáforo, similar ao semáforo da figura abaixo:

A mudança de estado é feita automaticamente, a cada 30 segundos, controlada pelo temporizador. A cada interrupção do temporizador, os semáforos devem mudar de estado, sequencialmente abrindo e fechando o tráfego das ruas. Ou seja, os semáforos devem estar sequencialmente nos estados Estado1, Estado2, Estado3, Estado2, Estado1, Estado2... onde

Estado1 representa verde para a rua Rua1 e vermelho para a rua Rua2,
Estado2 representa amarelo para as duas ruas, e
Estado3 representa vermelho para a rua Rua1 e verde para para a rua Rua2.
Adicionalmente, o mostrador de dois dígitos associado ao semáforo (note que há dois mostradores, um para cada rua) deve mostrar o número de segundos que restam para a mudança do estado aberto (verde) para o estado fechado (vermelho). A partir do momento em que o mostrador indica que faltam cinco segundos para a mudança, a luz amarela do semáforo deve ser acesa (e, obviamente, a verde e a vermelha devem ser apagadas).
No início do programa, o sinal deve estar verde para o semáforo da porta 0x90000 e vermelho para o semáforo da porta 0x90001, e os mostradores devem estar com o valor 30.

O rótulo da primeira posição de seu programa deve ser "_start". Os endereços das portas dos dispositivos devem ser:

Semáforo 0:
Leds: 0x90000
Mostradores de sete segmentos: 0x90010 (menos significativo) e 0x90011 (mais significativo)
Semáforo 1:
Leds: 0x90001
Mostradores de sete segmentos: 0x90020 (menos significativo) e 0x90021 (mais significativo)
Temporizador: 0x90030, interrupção FIQ
Nos dois semáforos, o led mais à esquerda é o vermelho. No início do programa, o sinal deve estar verde para o semáforo da porta 0x90000 e vermelho para o semáforo da porta 0x90001.
Uso de arquivo de configuração para o ligador ARM/GCC
Para que vocês possam acessar a memória desde o endereço 0x0000 (e assim inicializar o vetor de interrupções), é necessário fornecer um arquivo de configuração para o ligador (executável arm-none-eabi-ld).
O arquivo de configuração de configuração deve conter as linhas

SECTIONS {
         . = 0x00000000;
.text : { * (.text); }
. = 0x00010000;
.data : { * (.data); }
}
Veremos em uma aula futura o que esse arquivo especifica; mas sem esse arquivo o ligador não deixa que utilizemos o início da memória.

Devemos fornecer esse arquivo na linha de comando do ligador, com a opção '-T'. Assim, se você nomear esse arquivo como "mapa.lds", para montar o seu programa você deve utilizar por exemplo:

$ arm-none-eabi-as -o case10.o case10.s
$ arm-none-eabi-ld -o case10 -Tmapa.lds case10.o
Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem ARM. O arquivo de submissão deve chamar-se case10.s, e a primeira instrução de seu programa deve estar no endereço de rótulo _start.
Verificação do funcionamento
A verificação da corretude do funcionamento NÃO será automática. Você deve fazer a entrega pelo Susy dentro do prazo especificado, e demonstrar a execução de seu código presencialmente para um monitor ou professor, na aula de lab. Se você não terminar a case na aula de lab correspondente, ele deve ser demonstrado na aula seguinte de laboratório.
O número máximo de submissões no Susy é 10.

Dicas
Os nomes dos painéis não são fixos; você pode usar o que quiser. Mas os endereços dados acima devem ser obedecidos.
Organize o seu código de forma que o programa execute o menor tempo possível na rotina de tratamento de interrupção. Embora no caso deste lab isso não tenha muita importância, já que há apenas uma interrupção, em um sistema real há em geral várias outras interrupções, de forma que a melhor forma de garantir que todas as interrupções serão atendidas é executar o programa, sempre que possível, em modo usuário.
Peso
O peso deste lab na composição da nota é 1.


## case 11 

MC404 -- case 11 -- Jogo da Memória
Escreva um programa para implementar um Jogo de Memória simples. O jogo tem um teclado, um mostrador de dois dígitos de sete segmentos, um painel com três leds (verde, amarelo e vermelho) um botão do tipo "push" e um controle deslizante (slider). O mostrador de dois dígitos vai ser usado para mostrar números que devem ser memorizados. O controle deslizante vai ser utilizado para determinar a velocidade do jogo, e deve variar em uma escala de 1 (mais lento) a 5 (mais rápido). O controle deslizante inicia na posição 1. O painel de leds vai ser utilizado para mostrar o estado do jogo. O botão vai ser utilizado para iniciar o jogo.

A cada jogada, o programa mostra uma sequência aleatória de F números entre 00 e 99, onde F é a Fase do jogo. O jogo inicia na Fase 1 (ou seja, mostrando uma sequência de apenas um número). O jogador deve então digitar no teclado a sequência mostrada. Se o jogador acerta a sequência, o jogo passa para a Fase seguinte (F é incrementado, e na jogada seguinte a sequência de números tem um número a mais); se o jogador erra, a Fase do jogo permanece a mesma.

Inicialmente, o mostrador está desligado e os leds estão desligados. O jogador pressiona o botão e o jogo inicia, com F=1. A cada jogada:

o jogo mostra uma sequência de F números aleatórios (veja abaixo como gerar um número aleatório), da sequinte forma: mostra um número por um tempo TLig, deixa o mostrador desligado por um tempo TDesl (para separar os números mostrados). Os tempos TLig e TDesl são dependentes do estado do controle deslizante, que controla a velocidade do jogo. Na velocidade 1 (inicial), use por exemplo TLig=2s e TDesl=1s. Para cada velocidade subsequente (2, 3,... alterando o controle deslizante), diminua em 100ms o valor de cada um desses tempos.
Os números deve ser mostrados sempre com dois dígitos (por exemplo, o valor 9 deve ser mostrado como 09).
Ao final da sequência, inicia o Tempo de Resposta TResp, ou seja o tempo que o jogador tem para responder, entrando com a sequência mostrada pelo teclado. O jogador deve então digitar no teclado a sequência de números mostrada, e os números digitados devem ser mostrados no mostrador. Inicialmente o mostrador está com os dois dígitos apagados. Para cada número o jogador vai sempre digitar dois dígitos (assuma que o jogador vai obedecer, não precisa se preocupar com erros).
Quando o jogador pressiona a primeira tecla, o dígito correspondente deve ser mostrado no dígito mais significativo do mostrador (o dígito menos significativo deve continuar apagado).
Quando o jogador pressiona a segunda tecla, o dígito correspondente deve ser mostrado no dígito menos significativo do mostrador (o dígito mais significativo deve continuar mostrando o primeiro dígito).
Se o número digitado pelo jogador está correto, o mostrador apaga os dois dígitos após 50ms e espera pelo próximo número digitado. Se o número digitado pelo jogador está errado, o jogador "perde": o mostrador "pisca" três vezes o valor "EE" no mostrador (100ms aceso, 100ms apagado a cada piscada), indicando o erro, e volta para o estado Desligado. O jogador deve apertar o botão novamente para iniciar um outro jogo, que iniciará na mesma Fase.
Se o jogador digita corretamente todos os números da sequência, o mostrador "pisca" cinco vezes o valor "CC" no mostrador (100ms aceso, 100ms apagado a cada piscada), indicando sucesso, e volta para o estado Desligado (o jogador deve apertar o botão novamente para iniciar um outro jogo, que iniciará na Fase seguinte).
O Tempo de Resposta depende do controle deslizante. Inicie por exemplo com TResp= F x 5s para a velocidade inicial (controle deslizante em 1), e diminua de 500ms esse valor para cada velocidade subsequente. Ou seja, TResp= 1 x 5s para o controle deslizante em 1, TResp= 1 x 4.5s para o controle deslizante em 2, TResp= 1 x 4.0s para o controle deslizante em 3, etc.
Os leds indicam a progressão do Tempo de Resposta. Ao iniciar o Tempo de Resposta, o led verde é aceso (indicando que há bastante tempo para o jogador concluir a digitação da sequência); Quando metade do Tempo de Resposta passa, o led verde é apagado e o led amarelo é aceso; quando três quartos do tempo de resposta passam, o led amarelo é apagado e o led vermelho é aceso. Quando o jogo está no estado desligado (após o usuário acertar ou errar a sequência), os leds devem estar apagados.
Se o Tempo de Resposta "estourar" (terminar o tempo que o jogador tem para responder), o jodador "perde": o mostrador "pisca" três vezes o valor "EE" no mostrador (100ms aceso, 100ms apagado a cada piscada), e volta para o estado Desligado. O jogador deve apertar o botão novamente para iniciar um outro jogo, que iniciará na mesma Fase.
Considere que o jogador somente altera o controle deslizante quando o jogo está Desligado. Veja em Manual de dispositivos os parâmetros para criar um controle deslizante para o simulador.

Submissão
Você deve submeter o seu programa-fonte em linguagem de montagem ARM. O arquivo de submissão deve chamar-se case11.s. Neste laboratório, o Susy está sendo utilizado apenas para entrega, e o Susy não faz nenhuma verificação de correção. Para validar a entrega e receber a nota, você deverá mostrar o seu programa funcionando em uma aula de laboratório, para o professor ou para um dos monitores.

Endereços dos dispositivos
Você pode escolher os endereços e as interrupções que quiser.
Gerador de números aleatórios
Para exercitar o uso do ligador para construção de um arquivo executável a partir de mais de um arquivo objeto, vamos utilizar um gerador de números aleatórios, escrito em C, para gerar os números da sequência aleatória. Baixe aqui um exemplo de uso do gerador em C. O gerador de números aleatórios é dado em um arquivo de nome random.c.

Para criar o arquivo executável de seu programa é necessário usar três programas: o compilador C, o montador e o ligador GNU-ARM (respectivamente arm-none-eabi-gcc, arm-none-eabi-as e arm-none-eabi-ld). O compilador, o montador e o simulador já estão instalados no lab. Você pode por exemplo usar os seguintes comandos para criar o arquivo executável de nome case11:

arm-none-eabi-gcc -c random.c
arm-none-eabi-as -o case11.o case11.s
arm-none-eabi-ld -o case11 -Tmapa.lds case11.o random.o
O primeiro comando acima compila o arquivo random.c, gerando o arquivo objeto random.o (a flag -c indica para o gcc não gerar um arquivo executável, como é o procedimento padrão); o segundo programa cria o arquivo objeto case11.o, e finalmente o ligador é usado para gerar o arquivo executável case11.

O arquivo mapa.lds deve conter o seguinte texto:

SECTIONS {
  . = 0x00000000;
  .text : { * (.text); }
  . = 0x00010000;
  .data : { * (.data); }
}
Peso
O peso deste lab na composição da nota é 2.