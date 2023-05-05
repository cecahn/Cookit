import 'package:first/Constants/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:requests/requests.dart';

import '../cubit/appCubit.dart';
import '../cubit/appCubitStates.dart';



customAppBar(String header, bool showLogout, context) { 
    return AppBar(
        title: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(header,
                style: GoogleFonts.alfaSlabOne(
                    textStyle: const TextStyle(
                      fontSize: 30,
                    ),
                    // color: Colors.teal))),
                    color: ColorConstant.primaryColor))),
        actions: [
          IconButton(
            icon: Image.asset(
              showLogout ? ImageConstant.logout : ImageConstant.ellips,
              width: 100,
              height: 100,
            ),
            onPressed: () async {
              if (showLogout) {
                await Requests.get("https://litium.herokuapp.com/logout", withCredentials: true);
                await Requests.clearStoredCookies('litium.herokuapp.com');
                
                BlocProvider.of<AppCubits>(context).emit(WelcomeState());
              }
            },
          ),
        ],
        backgroundColor: Colors.white);
  }
