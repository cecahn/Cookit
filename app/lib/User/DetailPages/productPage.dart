import 'package:first/Constants/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:requests/requests.dart';
import '../../Constants/Utils/dimensions.dart';
import '../../Constants/Utils/image_constants.dart';
import '../../cubit/appCubit.dart';
import '../../cubit/appCubitStates.dart';
import 'package:first/Services/server_calls.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {
  String? _dateTime;
  String? showDate;
  late DateTime date;

  Future<void> _showDatePicker () async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Ändra till nuvarande utgångsdatum?
      firstDate: DateTime.now(), // Ändra så att man kan sätta ett datum innan dagens datum
      lastDate: DateTime(2025), // Ta bort hårdkodning
      
      ).then((value) {
        setState((){
          date = value!;
          showDate = DateFormat('yyyy-MM-dd').format(date);
          _dateTime = DateFormat('yyyyMMdd').format(date); 
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubits, CubitStates>(builder: (context, state) {
      ProductState detail = state as ProductState;

      // showDate = detail.produkt.bastforedatum;

      return Scaffold(
      body: SingleChildScrollView(
       child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left:0,
              right:0,
              child: Container(
                width:double.maxFinite,
                height: 100,
                
              )
            ),
            Positioned(
              left: 20,
              top:20,
              child: Row(
            children: [
              IconButton(
                onPressed: () {
                  BlocProvider.of<AppCubits>(context).goHome();
                },
                icon: Icon(Icons.arrow_back_ios),
                color:ColorConstant.primaryColor
              )
            ],
              )
            ),
            Positioned(
              right: 20,
              top:20,
              child: Row(
            children: [
              IconButton(
                onPressed: () {
                  ServerCall.deleteFromPantry(detail.produkt.skafferi_id);
                  BlocProvider.of<AppCubits>(context).goHome();
                },
                icon: const Icon(Icons.delete_outline),
                color:ColorConstant.primaryColor)
            ],
              )
            ),

            Positioned(
              top: 60,
              child: Container(
                  
                  padding: const EdgeInsets.only(left:20, right:20, top:10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    // VARUNAMN
                    Text(detail.produkt.namn,
                      style: GoogleFonts.alfaSlabOne(
                        textStyle: TextStyle(
                          color: ColorConstant.primaryColor,
                          fontSize: 30,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        
                        Text("Bäst före datum",
                          style: GoogleFonts.alfaSlabOne(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width:30),

                        // DATE PICKER
                        IconButton (
                          onPressed: () async {
                            await _showDatePicker();
                            ServerCall.changeDate(detail.produkt.skafferi_id, _dateTime);
                            LoadingState();
                          },
                          icon: const Icon(Icons.edit, color: Colors.black)
                        )
                      ],
                    ),

                    // UTGÅNGSDATUM STRÄNG
                    Text(
                      showDate ?? detail.produkt.bastforedatum.toString(),
                      style: GoogleFonts.breeSerif(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    Text("Allergener",
                      style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: detail.produkt.allergener.length,
                      itemBuilder: (context,index) {
                        return Container(
                          margin: EdgeInsets.only(right: Dimensions.width20),
                          child: Row(
                            children: [
                              Text(detail.produkt.allergener[index],
                                style: GoogleFonts.breeSerif(
                                  textStyle: const TextStyle(color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ],
                          )
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Text("Tillverkare",
                      style: GoogleFonts.alfaSlabOne(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // TILLVERKAR-NAMN
                    Text(detail.produkt.tillverkare,
                      style: GoogleFonts.breeSerif(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    )
                    
                      
                    ],
                  ),
                  
              )
            )
            
          ]
        )
      ),
      )
    ); 
    
    },
    buildWhen: (previousState, state) {
      return state is ProductState || state is LoadingState;
    }
    );
  }
}