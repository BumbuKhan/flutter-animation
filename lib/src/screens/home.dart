import 'package:flutter/material.dart';
import 'dart:math';

import '../widgets/cat.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxAnimationController;

  initState(){
    super.initState();

    catController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    catAnimation = Tween(begin: -40.0, end: -80.0)
      .animate(
        CurvedAnimation(
          parent: catController,
          curve: Curves.easeInExpo,
        )
      );

      boxAnimationController = AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this,
      );

      boxAnimation = Tween(begin: 0.1, end: 0.2)
        .animate(
          CurvedAnimation(
            parent: boxAnimationController,
            curve: Curves.easeIn,
          )
        );

      boxAnimation.addStatusListener((status) {
        if(status == AnimationStatus.completed){
          boxAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          boxAnimationController.forward();
        }
      });
      boxAnimationController.forward();
  }
    
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: () {
          if (catController.status == AnimationStatus.completed) {
            boxAnimationController.forward();
            catController.reverse();
          } else if (catController.status == AnimationStatus.dismissed) {
            boxAnimationController.stop();
            catController.forward();
          }
        },
      )
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 1,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          width: 10,
          height: 130,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: pi * boxAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 1,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          width: 10,
          height: 130,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: -pi * boxAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0,
          left: 0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      color: Colors.brown,
      width: 200,
      height: 200
    );
  }
}