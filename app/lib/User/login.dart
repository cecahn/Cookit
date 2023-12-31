// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert' show json;
import 'package:first/Constants/Utils/image_constants.dart';
import 'package:first/Widgets/appBar.dart';
import 'package:first/cubit/appCubitStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:requests/requests.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../cubit/appCubit.dart';

/// The scopes required by this application.
const List<String> scopes = <String>['email', 'profile', 'openid'];


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
  
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: scopes,
  );

  @override
  void initState() {
    super.initState();

    _googleSignIn.isSignedIn().then((loggedIn) {
      if (loggedIn) {
        _googleSignIn.signOut();
        print("loggar ut...");
      }
    });

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
        /*    
        var r2 = await Requests.get("https://litium.herokuapp.com/skafferi",
            withCredentials: true);
        print(r2.json()); 
        */
        print('hallå!!');
        BlocProvider.of<AppCubits>(context).emit(LoadedState());
      }

    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).    
    // _googleSignIn.signInSilently();
  }

  // This is the on-click handler for the Sign In button that is rendered by Flutter.
  //
  // On the web, the on-click handler of the Sign In button is owned by the JS
  // SDK, so this method can be considered mobile only.
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
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

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    /*   
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
      */
    // The user is NOT Authenticated
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Text('You are not currently signed in.'),
        // This method is used to separate mobile from web code with conditional exports.
        // See: src/sign_in_button.dart
        ElevatedButton.icon(
            //icon: const Icon(Icons.Google, color: Colors.black),
            onPressed: _handleSignIn,
            icon: const Icon(Icons.android),
            label: const Text("google")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar("CookIt.", false, context),
        body: Center(
            child: Column(children: [
          ElevatedButton.icon(
            //icon: const Icon(Icons.Google, color: Colors.black),
            onPressed: _handleSignIn,
            icon: const Icon(Icons.android),
            label: const Text("google"),
          )
        ])));
  }
}
