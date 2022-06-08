import 'package:flutter/material.dart';
import 'package:wini_web/home_page.dart';
import 'package:wini_web/tab_page.dart';

void main() {
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
      title: 'Flutter Demo',
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
  home,
  tab,
  unknow,
}

class MyRouteConfig {
  final RoutePage pathName;
  final Object? data;

  MyRouteConfig({this.pathName = RoutePage.home, this.data});

  MyRouteConfig.unKown()
      : pathName = RoutePage.unknow,
        data = null;
}

class MyRouteInformationParser extends RouteInformationParser<MyRouteConfig> {
  @override
  Future<MyRouteConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final String routeName = routeInformation.location ?? '';
    var socketId = RegExp(r'/socketId=[a-zA-Z0-9]$');
    if (socketId.hasMatch(routeName)) {
      return MyRouteConfig(data: PageData(routeName.substring(routeName.indexOf('socketId=') + 10)));
    } else {
      if (routeName == '') {
        return MyRouteConfig.unKown();
      } else if (routeName == '/') {
        return MyRouteConfig();
      }
      {
        return MyRouteConfig(
            pathName: RoutePage.values.firstWhere((route) => '/$route' == routeName), data: routeInformation.state);
      }
    }
  }

  @override
  RouteInformation? restoreRouteInformation(MyRouteConfig configuration) {
    switch (configuration.pathName) {
      case RoutePage.home:
        return const RouteInformation(location: '/');
      default:
        return RouteInformation(location: '/${configuration.pathName}', state: configuration.data);
    }
  }
}

class MyRouteDelegate extends RouterDelegate<MyRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRouteConfig> {
  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  MyRouteConfig? _configuration;

  set myRouteConfig(MyRouteConfig value) {
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
        const MaterialPage(
          key: ValueKey('home'),
          child: MyHomePage(),
        ),
        if (_configuration?.pathName == RoutePage.tab)
          const MaterialPage(
            key: ValueKey('tab'),
            child: TabView(),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        notifyListeners();

        return true;
      },
    );
  }
}

class PageData {
  final String? socketId;
  PageData(this.socketId);
}
