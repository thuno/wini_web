import 'package:flutter/material.dart';
import 'package:wini_web/login_page.dart';
import 'package:wini_web/home_page.dart';
import 'package:wini_web/socket_io.dart';
import 'package:wini_web/test_sms.dart';

void main() {
  WiniIO.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: MyRouteInformationParser(),
      routerDelegate: MyRouteDelegate(),
      title: 'wini_web',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    );
  }
}

enum RoutePage {
  login,
  home,
  unknow,
}

class MyRouteConfig {
  final RoutePage pathName;
  final String? socketId;
  final Object? data;

  MyRouteConfig({this.pathName = RoutePage.login, this.data, this.socketId});

  MyRouteConfig.unKown()
      : pathName = RoutePage.unknow,
        data = null,
        socketId = null;
}

class MyRouteInformationParser extends RouteInformationParser<MyRouteConfig> {
  @override
  Future<MyRouteConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final String routeName = routeInformation.location ?? '/';
    final Uri uri = Uri.parse(routeName);
    if (routeName == '' || uri.pathSegments.isEmpty) {
      return MyRouteConfig.unKown();
    } else if (routeName.contains('login')) {
      return MyRouteConfig(
          pathName: RoutePage.login, socketId: uri.queryParameters['socketId'], data: routeInformation.state);
    } else if (routeName.contains('home')) {
      return MyRouteConfig(pathName: RoutePage.home, data: routeInformation.state);
    } else {
      throw 'unknow';
    }
  }

  @override
  RouteInformation? restoreRouteInformation(MyRouteConfig configuration) {
    switch (configuration.pathName) {
      case RoutePage.login:
        return RouteInformation(location: '/login?socketId=${configuration.socketId ?? "lalala"}');
      case RoutePage.home:
        return const RouteInformation(location: '/home');
      default:
        throw 'unknow';
    }
  }
}

class MyRouteDelegate extends RouterDelegate<MyRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRouteConfig> {
  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  MyRouteConfig? _configuration;

  set myRouteConfig(MyRouteConfig value) {
    if (_configuration?.pathName == RoutePage.home) {}
    if (_configuration?.pathName == value.pathName) return;
    _configuration = value;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MyRouteConfig configuration) async {
    _configuration = configuration;
  }

  @override
  MyRouteConfig? get currentConfiguration => _configuration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: <Page>[
        // if (GoogleService.user == null)
        //   MaterialPage(
        //     key: const ValueKey('login_page'),
        //     child: LoginPage(socketId: _configuration?.socketId),
        //   ),
        // if (GoogleService.user != null)
        //   const MaterialPage(
        //     key: ValueKey('home_page'),
        //     child: HomePage(),
        //   ),
        const MaterialPage(
          key: ValueKey('home_page'),
          child: ReadSMS(),
        ),
      ],
      onPopPage: (route, result) {
        if (_configuration!.pathName == RoutePage.home) {
          return false;
        } else if (!route.didPop(result)) {
          return false;
        }
        notifyListeners();

        return true;
      },
    );
  }
}
