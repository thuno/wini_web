import 'package:flutter/material.dart';
import 'package:wini_web/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wini_web/socket_io.dart';

class GoogleService {
  static GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  static GoogleSignInAccount? user;
}

class LoginPage extends StatefulWidget {
  final String? socketId;
  const LoginPage({Key? key, this.socketId}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleSignIn() async {
    // await Firebase.initializeApp(
    //   options: FirebaseOptions(
    //     apiKey: "AIzaSyDmWRhh2GIb8zSxpYOdTaUp9MLFD7nK7uY",
    //     appId: "1:896533840329:web:a71d00f5d88bb45979e818",
    //     messagingSenderId: "896533840329",
    //     projectId: "wini-signin",
    //   ),
    // );
    // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    print(widget.socketId);
    final GoogleSignInAccount? googleUser = await GoogleService.googleSignIn.signIn();
    GoogleService.user = googleUser;
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    if (widget.socketId != null) {
      WiniIO.emitGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
        socketId: widget.socketId,
      );
    }
    (Router.of(context).routerDelegate as MyRouteDelegate).myRouteConfig =
        MyRouteConfig(pathName: RoutePage.home, socketId: widget.socketId);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Wini app sign in with Google'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You are not currently signed in.'),
            ElevatedButton(
              onPressed: _handleSignIn,
              child: const Text('SIGN IN'),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
