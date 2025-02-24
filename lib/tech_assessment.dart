import 'package:flutter/material.dart';

class TechRouter implements RouterConfig<List<Location>> {
  TechRouter({
    required Location initialRoute,
  }) {
    backButtonDispatcher = RootBackButtonDispatcher();

    routerDelegate = TechRouterDelegate(
      initialRoute: initialRoute,
    );

    state.add(initialRoute);
    routeInformationParser = TechRouterInformationParser(
      state: state,
    );
    routeInformationProvider =
        TechRouterInformationProvider(initialRoute: initialRoute, state: state);
  }

  @override
  late final BackButtonDispatcher backButtonDispatcher;

  @override
  late final TechRouterDelegate routerDelegate;

  @override
  late final TechRouterInformationParser routeInformationParser;

  @override
  late final TechRouterInformationProvider routeInformationProvider;

  late final LocationState state = LocationState();

  void push(Location location) {
    state.add(location);
    routeInformationProvider.push(location);
  }

  void pop() {
    routerDelegate.pop();
  }
}

class TechRouterDelegate extends RouterDelegate<List<Location>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<Location>> {
  TechRouterDelegate({
    required Location initialRoute,
  }) : _configuration = [initialRoute];

  List<Location> _configuration;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  List<Location> get currentConfiguration => _configuration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // todo: you need to something here
      ],
      onDidRemovePage: (page) {},
    );
  }

  @override
  Future<void> setNewRoutePath(List<Location> configuration) async {
    _configuration = configuration;
    notifyListeners();
  }

  void pop() {
    _configuration.removeLast();
    notifyListeners();
  }
}

class TechRouterInformationParser
    extends RouteInformationParser<List<Location>> {
  const TechRouterInformationParser({
    required this.state,
  });

  final LocationState state;

  @override
  Future<List<Location>> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final segments = uri.pathSegments;

    return segments.map((l) {
      return Location(
        path: l,
        builder: state.get(l).builder,
      );
    }).toList();
  }

  @override
  RouteInformation? restoreRouteInformation(List<Location> configuration) {
    return RouteInformation(
      uri: Uri.parse(configuration.map((l) => l.path).join('/')),
    );
  }
}

class TechRouterInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  TechRouterInformationProvider({
    required Location initialRoute,
    required this.state,
  }) : _configuration = RouteInformation(uri: Uri.parse(initialRoute.path));

  final LocationState state;
  RouteInformation _configuration;

  @override
  RouteInformation get value => _configuration;

  void push(Location location) {
    // todo: you need to do something here.
    notifyListeners();
  }
}

class Location {
  final String path;
  final WidgetBuilder builder;

  Location({required this.path, required this.builder});
}

class LocationState {
  final Map<String, Location> _routes = {};

  void add(Location location) {
    _routes[location.path] = location;
  }

  Location get(String path) => _routes[path]!;
}
