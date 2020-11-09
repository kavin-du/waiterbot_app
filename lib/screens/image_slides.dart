import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../mix_ins/validator_mixin.dart';

class ImageSlides extends StatefulWidget {
  @override
  _ImageSlidesState createState() => _ImageSlidesState();
}

class _ImageSlidesState extends State<ImageSlides> with ValidatorMixin {

  final _imageList = ['images/slides1.jpg', 'images/slides2.jpg', 'images/slides3.jpg', 'images/slides4.jpg'];
  final _sentences = ['Save your time', 'No more queues', 'Efficient Service', 'Enjoy your meal'];
  int _current = 0; // index for image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // prevent shrinking image when keyboard opens
      body: Builder(builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/slide_background.jpg',
                fit: BoxFit.fitHeight,
              ),
            ),

            Container(                  
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.all(Radius.circular(65))
                  ),
            ),

            Container(
              margin: EdgeInsets.only(left: 35, right: 35, top: 175),
              child: Column(
                  children: [
                    slides(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                    ),
                    button()
                  ],
                ),
              
            ),
          ],
        );
      }),
    );
  }

  Widget slides(){
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }
          ),
          items: this._imageList.map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5),
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(item),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.5
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  // child: Image.asset(item, fit: BoxFit.cover, width: 1000)
                ),
            ),
          )).toList(),
        ),
        Text(
          _sentences[_current],
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: this._imageList.map((item){
            int index = this._imageList.indexOf(item);
            return Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ? Colors.blue : Colors.grey,
              ),
            ); 
          } ).toList(),
        )
      ],
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 10,
      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
      child: Text(
        'SKIP',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        /** logic for button press */
      },
      color: Colors.amberAccent,
    );
  }
}
