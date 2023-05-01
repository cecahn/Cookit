// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert' show json;
import 'package:first/Constants/Utils/image_constants.dart';
import 'package:first/Constants/export.dart';
import 'package:first/Widgets/appBar.dart';
import 'package:first/Widgets/app_textfield.dart';
import 'package:first/cubit/appCubitStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:requests/requests.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'package:first/Widgets/app_button.dart';
import 'package:first/Widgets/app_google_button.dart';

import '../cubit/appCubit.dart';

/// The scopes required by this application.
const List<String> scopes = <String>['email', 'profile', 'openid'];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

/// The SignInDemo app.
class SignInDemo extends StatefulWidget {
  ///
  const SignInDemo({Key? key}) : super(key: key);

  @override
  State createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print("INIT STATE");
    print("CURRENT USER: $_currentUser");
    print("IS AUTHORIZED: $_isAuthorized");
    
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, in the web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.isSignedIn();
      }

      // Update state
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        // Vi är inloggade!
        final GoogleSignInAuthentication? googleAuth =
            await _currentUser?.authentication;

        final String? accessToken = googleAuth?.accessToken;

        var cookies = await Requests.getStoredCookies('litium.herokuapp.com');

        if (!cookies.keys.contains('session')) {
          print('cookie missing triggering signin flow');
          if (accessToken != null) {
            await Requests.get("https://litium.herokuapp.com/login",
                queryParameters: {'access_token': accessToken},
                withCredentials: true);
          }
        }
        print('hallå!!');
        BlocProvider.of<AppCubits>(context).emit(LoadedState());
      }

    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).    
    _googleSignIn.signInSilently();
  }

  // This is the on-click handler for the Sign In button that is rendered by Flutter.
  //
  // On the web, the on-click handler of the Sign In button is owned by the JS
  // SDK, so this method can be considered mobile only.
  Future<void> _handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      print("===== _handleSignIn() =====");
      print("CURRENT USER: $_currentUser");
      if (_currentUser != null) {
        BlocProvider.of<AppCubits>(context).emit(LoadedState());
      }
    } catch (error) {
      print(error);
      return;
    }
  }

  // Prompts the user to authorize `scopes`.
  //
  // This action is **required** in platforms that don't perform Authentication
  // and Authorization at the same time (like the web).
  //
  // On the web, this must be called from an user interaction (button click).
  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    setState(() {
      _isAuthorized = isAuthorized;
    });
    if (isAuthorized) {
      print("Access granted!");
    }
  }

  Future<void> _handleSignOut() async {
    // TODO: HUR KÖRA DET HÄR NÄR MAN KOMMER TILLBAKS FRÅN APPEN?
    await Requests.get("https://litium.herokuapp.com/logout",
        withCredentials: true);

    await Requests.clearStoredCookies('litium.herokuapp.com');

    print("========= HANDLE_SIGNOUT ==========");
    print("CURRENT USER: $_currentUser");
    print("IS AUTHORIZED: $_isAuthorized");

    _googleSignIn.disconnect();

    print("========= HANDLE_SIGNOUT ==========");
    print("CURRENT USER: $_currentUser");
    print("IS AUTHORIZED: $_isAuthorized");

    /* setState(() {
      _currentUser = null;
      _isAuthorized = false;
    }); */
  }

  void _email_password_signin() { print(">>> _email_password_signin <<<"); }

  void _handle_forgot_password() { print(">>> _handle_forgot_password <<<"); }


  // @override
  Widget _buildBody() { // buildBody
    final GoogleSignInAccount? user = _currentUser;
      
    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          if (_isAuthorized) ...<Widget>[
            // The user has Authorized all required scopes
            const Text("Hejsan"),
          ],
          if (!_isAuthorized) ...<Widget>[
            // The user has NOT Authorized all required scopes.
            // (Mobile users may never see this button!)
            const Text('Additional permissions needed to read your contacts.'),
            ElevatedButton(
              onPressed: _handleAuthorizeScopes,
              child: const Text('REQUEST PERMISSIONS'),
            ),
          ],
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else { 
     
    // The user is NOT Authenticated
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Text('You are not currently signed in.'),
        // This method is used to separate mobile from web code with conditional exports.
        // See: src/sign_in_button.dart
        ElevatedButton.icon(
            //icon: const Icon(Icons.Google, color: Colors.black),
            // onPressed: _handleSignIn,
            onPressed: () {
              _handleSignIn();
            },
            icon: const Icon(Icons.android),
            label: const Text("google")),
      ],
    );
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: customAppBar("CookIt.", ImageConstant.ellips),
        // body: _buildBody()
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
                child: Column(
                  children: [
                  
                    const SizedBox(height: 25),
          
                    Center(
                      child: Text(
                        "Cookit.",
                        style: GoogleFonts.alfaSlabOne(
                          textStyle: const TextStyle(
                          fontSize: 40,
                          ),
                          color: ColorConstant.primaryColor
                          ),
                      )
                    ),
                  
                    const SizedBox(height: 25),
                    
                    AppTextfield(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),
          
                    const SizedBox(height: 10),
          
                    AppTextfield(
                      controller: passwordController,
                      hintText: "Lösenord",
                      obscureText: true,
                    ),
          
                    // Forgot password?
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _handle_forgot_password,
                            child: Text(
                              "Glömt lösenord",
                              style: TextStyle(
                                color: Colors.grey.shade500
                              ),
                            )
                          )
                        ],
                      )
                    ),
          
                    AppButton(text: "Logga in", onTap: _email_password_signin),
          
                    const SizedBox(height: 25),
          
                    AppGoogleButton(
                      text: "Sign in with Google",
                      onTap: _handleSignIn,
                    ),
          
                    /* ElevatedButton.icon(
                      //icon: const Icon(Icons.Google, color: Colors.black),
                      onPressed: _handleSignIn,
                      icon: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        height: 50,
                        child: Image.asset('assets/Images/google/google_g.png')
                        ),
                      label: const Text("Logga in med Google"),
                    ), */
            
                    ElevatedButton.icon(
                      //icon: const Icon(Icons.Google, color: Colors.black),
                      onPressed: _handleSignOut,
                      icon: const Icon(Icons.android),
                      label: const Text("Sign out"),
                    )
                  
                  ]
                )
              ),
          ),
        )
        );
  }
}
