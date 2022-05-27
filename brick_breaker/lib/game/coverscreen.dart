import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;

  CoverScreen({required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: Alignment(0, -0.5),
            child: Text(
              'TRENCA MAONS',
              style: TextStyle(color: Colors.grey[800], fontSize: 30),
            ),
          )
        : Stack(
            children: [
              Container(
                alignment: Alignment(0, -0.5),
                child: Text(
                  'TRENCA MAONS',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              Container(
                alignment: Alignment(0, -0.1),
                child: Text(
                  'Toca per començar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
  }
}
