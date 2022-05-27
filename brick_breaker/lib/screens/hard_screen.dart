import 'dart:async';

import 'package:brick_breaker/game/ball.dart';
import 'package:brick_breaker/game/bricks.dart';
import 'package:brick_breaker/game/coverscreen.dart';
import 'package:brick_breaker/game/game_over.dart';
import 'package:brick_breaker/game/game_won.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:brick_breaker/game/player.dart';
import 'package:flutter/material.dart';

class HardScreen extends StatefulWidget {
  const HardScreen({Key? key}) : super(key: key);

  @override
  _EasyScreenState createState() => _EasyScreenState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _EasyScreenState extends State<HardScreen> {
  //variables pilota
  double ballX = 0;
  double ballY = 0;
  double ballXincrements = 0.01;
  double blalYincrements = 0.01;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  //variables jugador
  double playerX = -0.6;
  double playerWidth = 0.4;

  //variables brick
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.02;
  static int numberOfBricksRow = 4;
  static double wallGap = 0.5 *
      (2 - numberOfBricksRow * brickWidth - (numberOfBricksRow - 1) * brickGap);

  List MyBricks = [
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 3 * (brickWidth + brickGap), firstBrickY, false],
    [
      firstBrickX + 0 * (brickWidth + brickGap),
      firstBrickY + 3 * brickHeight,
      false
    ],
    [
      firstBrickX + 1 * (brickWidth + brickGap),
      firstBrickY + 3 * brickHeight,
      false
    ],
    [
      firstBrickX + 2 * (brickWidth + brickGap),
      firstBrickY + 3 * brickHeight,
      false
    ],
    [
      firstBrickX + 3 * (brickWidth + brickGap),
      firstBrickY + 3 * brickHeight,
      false
    ],
  ];

  int bricksBroken = 0;

  //variables partida
  bool hasGameStarted = false;
  bool isGameOver = false;
  bool isGameWin = false;

  AudioCache cache = AudioCache();
  AudioPlayer soundPlayer = AudioPlayer();

  void _playFile() async {
    soundPlayer = await cache.loop('Sound3.wav'); // assign player here
  }

  void startGame() {
    if (hasGameStarted != true) {
      _playFile();
      Timer.periodic(Duration(milliseconds: 10), (timer) {
        //update direction
        updateDirection();

        //move ball
        moveBall();

        //check player dead
        if (isPlayerDead()) {
          timer.cancel();
          isGameOver = true;
          soundPlayer.stop();
        }

        //check brick is hit
        checkForBrokenBricks();
        if (bricksBroken == MyBricks.length) {
          timer.cancel();
          isGameWin = true;
          soundPlayer.stop();
        }
      });
      hasGameStarted = true;
    }
  }

  void checkForBrokenBricks() {
    //checks for when ball hits bottom of brick
    for (var i = 0; i < MyBricks.length; i++) {
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + brickWidth &&
          ballY <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;
          ballYDirection = direction.DOWN;

          double leftSideDist = (MyBricks[i][0] - ballX).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (MyBricks[i][1] - ballY).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeight - ballY).abs();

          //mirem el canto mes petit, per saber cap a quina direcio sha de moure el player
          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case 'left':
              ballXDirection = direction.LEFT;
              break;

            case 'right':
              ballXDirection = direction.RIGHT;
              break;

            case 'up':
              ballYDirection = direction.UP;
              break;

            case 'down':
              ballYDirection = direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [
      a,
      b,
      c,
      d,
    ];
    double currentMin = a;
    //busquem el minim valor de cada costat
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    //fem el return del valor que trobi el for anterior
    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }

    return '';
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  //check if brick is hit

  void moveBall() {
    //horitzontally
    if (ballXDirection == direction.LEFT) {
      ballX -= ballXincrements;
    } else if (ballXDirection == direction.RIGHT) {
      ballX += ballXincrements;
    }

    //vertically
    if (ballYDirection == direction.DOWN) {
      ballY += blalYincrements;
    } else if (ballYDirection == direction.UP) {
      ballY -= blalYincrements;
    }
  }

  void updateDirection() {
    setState(() {
      //player check
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }
      //top check
      else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }
      //left wall
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      }
      //right wall
      else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void moveLeft() {
    setState(() {
      //only move left if player not off screen
      if (!(playerX - 0.1 <= -1)) {
        playerX -= 0.1;
      }
    });
  }

  void moveRight() {
    setState(() {
      //only move right if player not off screen
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.red[200],
        body: Center(
          child: Stack(
            children: [
              CoverScreen(
                hasGameStarted: hasGameStarted,
              ),

              GameOverScreen(
                isGameOver: isGameOver,
              ),

              GameWinScreen(
                isGameWin: isGameWin,
              ),

              //pilota
              MyBall(
                ballX: ballX,
                ballY: ballY,
              ),

              //jugador
              MyPlayer(
                playerX: playerX,
                playerWidth: playerWidth,
              ),
              //buttons
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: new Icon(
                            Icons.arrow_left,
                            size: 40,
                          ),
                          onPressed: () {
                            moveLeft();
                          },
                        ),
                        IconButton(
                          icon: new Icon(
                            Icons.arrow_right,
                            size: 40,
                          ),
                          onPressed: () {
                            moveRight();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //player pos
              Container(
                alignment: Alignment(playerX, 0.9),
                child: Container(
                  width: 4,
                  height: 15,
                ),
              ),
              Container(
                alignment: Alignment(playerX + playerWidth, 0.9),
                child: Container(
                  width: 4,
                  height: 15,
                ),
              ),

              //bricks
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[0][0],
                brickY: MyBricks[0][1],
                brickBroken: MyBricks[0][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[1][0],
                brickY: MyBricks[1][1],
                brickBroken: MyBricks[1][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[2][0],
                brickY: MyBricks[2][1],
                brickBroken: MyBricks[2][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[3][0],
                brickY: MyBricks[3][1],
                brickBroken: MyBricks[3][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[4][0],
                brickY: MyBricks[4][1],
                brickBroken: MyBricks[4][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[4][0],
                brickY: MyBricks[4][1],
                brickBroken: MyBricks[4][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[5][0],
                brickY: MyBricks[5][1],
                brickBroken: MyBricks[5][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[6][0],
                brickY: MyBricks[6][1],
                brickBroken: MyBricks[6][2],
              ),
              Brick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[7][0],
                brickY: MyBricks[7][1],
                brickBroken: MyBricks[7][2],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
