import 'package:flutter/material.dart';

class GameWinScreen extends StatelessWidget {
  final bool isGameWin;
  final function;

  GameWinScreen({required this.isGameWin, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameWin
        ? Stack(
            children: [
              Container(
                alignment: Alignment(0, -0.15),
                child: Text(
                  'H A S  G U A N Y A T',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                alignment: Alignment(0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey[300],
                      child: Text(
                        'SURT',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
