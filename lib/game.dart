import 'dart:async';
import 'dart:math';
import 'package:demo_fireman/components/arvore_fire.dart';
import 'package:flutter/material.dart';

class Obstacle {
  double x;
  double y;
  double size;
  bool counted; // indica se já foi contado (passado)

  Obstacle({
    required this.x,
    required this.y,
    required this.size,
    this.counted = false,
  });
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  double posX = 0;
  double posY = 50;
  double velocidadeY = 0;
  double gravidade = 0.8;

  double tamanhoQuadrado = 50;
  late double chao;

  // relacionado ao personagem
  bool andarEsquerda = false;
  bool andarDireita = false;
  double velocidade = 5;

  // relacionado ao mundo
  double velocidadeMundo = 6;
  double groundOffset = 0;

  List obstaculos = [];

  // pontuacao
  int score = 0;

  // variavel para controlar se o personagem esta morto
  bool morreu = false;

  Timer? gameTimer;
  Timer? obstaculoTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chao = MediaQuery.of(context).size.height - 120;

      posY = chao - tamanhoQuadrado;

      iniciarJogo();
    });
  }

  void iniciarJogo() {
    gameTimer?.cancel();
    obstaculoTimer?.cancel();

    gameTimer = Timer.periodic(Duration(milliseconds: 16), (_) {
      if (!mounted) return;

      setState(() {
        if (morreu) return;

        // gravidade
        velocidadeY += gravidade;
        posY += velocidadeY;

        if (posY >= chao - tamanhoQuadrado) {
          posY = chao - tamanhoQuadrado;
          velocidadeY = 0;
        }

        // mover jogador

        final maxX = MediaQuery.of(context).size.width - tamanhoQuadrado;

        if (andarEsquerda) {
          posX -= velocidade;
          if (posX < 0) posX = 0;
        }

        if (andarDireita) {
          posX += velocidade;
          if (posX > maxX) posX = maxX;
        }

        groundOffset -= velocidadeMundo;

        if (groundOffset <= -50) {
          groundOffset = 0;
        }

        for (var obst in obstaculos) {
          obst.x -= velocidadeMundo;
        }

        obstaculos.removeWhere((o) => o.x < -o.size);

        final playerLeft = posX;
        final playerTop = posY;
        final playerRight = posX + tamanhoQuadrado;
        final playerBottom = posY + tamanhoQuadrado;

        for (var obst in obstaculos) {
          final obstLeft = obst.x;
          final obstTop = obst.y;
          final obstRight = obst.x + obst.size;
          final obstBottom = obst.y + obst.size;

          final colisao =
              !(playerRight < obstLeft ||
                  playerLeft > obstRight ||
                  playerTop < obstBottom ||
                  playerBottom > obstTop);

          if (colisao) {
            morreu = true;
            gameTimer?.cancel();
            obstaculoTimer?.cancel();

            Future.delayed(Duration.zero, () => showGameOverDialog());
            break;
          }
        }
      });
    });

    obstaculoTimer = Timer.periodic(Duration(seconds: 2), (_) {
      if (!morreu) {
        gerarObstaculo();
      }
    });
  }

  gerarObstaculo() {
    final random = Random();

    setState(() {
      obstaculos.add(
        Obstacle(
          x: MediaQuery.of(context).size.width + 100,
          y: chao - 50,
          size: 30 + random.nextInt(50).toDouble(),
        ),
      );
    });
  }

  pular() {
    if (posY >= chao - tamanhoQuadrado) {
      setState(() {
        velocidadeY = -15;
      });
    }
  }

  andarParaDireita() {
    setState(() {
      andarDireita = true;
    });
  }

  andarParaEsquerda() {
    setState(() {
      andarEsquerda = true;
    });
  }

  pararAndarDireita() {
    setState(() {
      andarDireita = false;
    });
  }

  pararAndarEsquerda() {
    setState(() {
      andarEsquerda = false;
    });
  }

  reiniciarJogo() {
    setState(() {
      posX = 0;
      posY = 50;
      velocidadeY = 0;
      morreu = false;
      obstaculos.clear();
      groundOffset = 0;

      iniciarJogo();
    });
  }

  showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("SE QUEIMOU!!!"),
          content: Column(
            children: [
              Text("Você infelizmente se queimou. Tente Novamente."),
              GestureDetector(
                onTap: () {
                  // Evento que irá reiniciar o jogo.
                  reiniciarJogo();
                },
                child: Container(child: Text("Reiniciar")),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.maxFinite,
                color: Colors.grey,
                height: 25,
              ),
              Container(
                width: double.maxFinite,
                color: Colors.brown,
                height: 60,
              ),
            ],
          ),
          Positioned(
            width: MediaQuery.of(context).size.width * 1,
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [ArvoreFire(), ArvoreFire()],
            ),
          ),
          Positioned(
            bottom: 35,
            left: 160,
            child: Container(color: Colors.deepOrange, height: 50, width: 50),
          ),
        ],
      ),
    );
  }
}
