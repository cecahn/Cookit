import 'package:get/get.dart';

class Dimensions {

  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width; 

  
 //844 screen height
 //220 the height we want

  static double pageViewContainer= screenHeight/(844/220);

  static double height10= screenHeight/84.4;
  static double height20= screenHeight/42.2;
  static double height15= screenHeight/56.27;
  static double height30= screenHeight/28.13;

  //Width
  static double width10= screenHeight/84.4;
  static double width20= screenHeight/42.2;
  static double width15= screenHeight/56.27;
  static double width30= screenHeight/28.13;


  static double font20= screenHeight/42.2;

   static double radius15= screenHeight/56.27;
  static double radius20= screenHeight/42.2;
  static double radius30= screenHeight/28.13;

}