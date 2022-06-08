import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wini_web/login_page.dart';
import 'package:wini_web/main.dart';

class HomePage extends StatefulWidget {
  final String socketId;
  const HomePage({Key? key, this.socketId = 'lalala'}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _handleSignOut() async {
    await GoogleService.googleSignIn.disconnect();
    (Router.of(context).routerDelegate as MyRouteDelegate).myRouteConfig = MyRouteConfig(pathName: RoutePage.login);
    GoogleService.user = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect to socket: ${widget.socketId}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: GoogleService.user!,
            ),
            title: Text(GoogleService.user!.displayName ?? ''),
            subtitle: Text(GoogleService.user!.email),
          ),
          const Text('Signed in successfully.'),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }
}
