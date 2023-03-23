import 'dart:html';

import 'package:flutter/material.dart';

final List _posts = [
  "hej1",
  "hej2",
  "hej3",
],

Widget build(BuildContext context){
  return Scaffold(
    body: Column (children: [
      Expanded(child: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index)),)
    ],)
  )
}