import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cubit/appCubit.dart';
import '../../Services/receptModel.dart';
import '../../Constants/Utils/dimensions.dart';

class AppRecipeTile extends StatelessWidget {
  final Recept recept;

  const AppRecipeTile({
    Key? key,
    required this.recept
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<AppCubits>(context)
            .ReceptPage(recept);
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Colors.grey.shade400
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 7,
              spreadRadius: 2 
            )
            ]
          ),
          margin: EdgeInsets.only(bottom: Dimensions.width15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Receptbild
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)
                  ),
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(
                      recept.bild
                    ),
                    fit: BoxFit.cover
                  ),
                )
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(
                    borderRadius:
                        BorderRadius.only(
                      topRight:
                          Radius.circular(
                              Dimensions
                                  .radius20),
                      bottomRight:
                          Radius.circular(
                              Dimensions
                                  .radius20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        recept.titel,
                        style: GoogleFonts.alfaSlabOne(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            height: 1
                          ),
                          color: Colors.black87,
                        )
                      ),
                    ],
                  )
                ),
              ),
            ],
          )
        ),
      );
    }
}