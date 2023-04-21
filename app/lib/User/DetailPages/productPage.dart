import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/Utils/image_constants.dart';
import '../../cubit/appCubit.dart';
import '../../cubit/appCubitStates.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(builder: (context, state){
      ProductState detail = state as ProductState;
      return Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: [
                Positioned(
                  left:0,
                  right:0,
                  child: Container(
                    width:double.maxFinite,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageConstant.saknas),
                        fit:BoxFit.cover
                        ),
                      
                    )
                  )
                ),
                Positioned(
                  left: 20,
                  top:20,
                  child: Row(
                children: [
                  IconButton(onPressed: () { 
                    BlocProvider.of<AppCubits>(context).goHome();
                  }, icon: Icon(Icons.arrow_back_ios), color:Colors.white)
                ],
                  )
                ),
                Positioned(
                  top: 200,
                  child: Container(
                      
                      padding: const EdgeInsets.only(left:20, right:20, top:30),
                      //color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: 1000,
                      decoration: const BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(30),

                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          
                          children:[
                            Text(detail.produkt.namn,
                            style: GoogleFonts.alfaSlabOne(
                            textStyle: const TextStyle(
                            color: Colors.teal,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                          
                        ],
                      )
                  ))
              
              
              ]
            )
          ),
    );

    });
  }
}