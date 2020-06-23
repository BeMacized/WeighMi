import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weigh_mi/theme.dart';
import 'package:weigh_mi/views/main/main-view.provider.dart';
import 'package:weigh_mi/views/main/main.view.dart';
import 'package:weigh_mi/views/measure/measure-view.provider.dart';
import 'package:weigh_mi/views/measure/measure.view.dart';
import 'package:weigh_mi/views/settings/settings.view.dart';

import 'globals.dart';
import 'providers/measure.provider.dart';
import 'providers/weight-entry.provider.dart';

void main() {
  runApp(WeightTrackerApp());
}

class WeightTrackerApp extends StatefulWidget {
  @override
  _WeightTrackerAppState createState() => _WeightTrackerAppState();
}

class _WeightTrackerAppState extends State<WeightTrackerApp> with WidgetsBindingObserver {
  WeightEntryProvider weightEntryProvider = WeightEntryProvider();
  MeasureProvider measureProvider = MeasureProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    measureProvider.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    weightEntryProvider.loadEntries();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    bool fullscreenDialog = false;
    switch (settings.name) {
      case '/':
      case '/main':
        builder = (BuildContext _) => MainView();
        break;
      case '/measure':
        builder = (BuildContext _) => MeasureView();
        break;
      case '/settings':
        builder = (BuildContext _) => SettingsView();
        break;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Weight Tracker',
        navigatorKey: Application.navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        theme: getAppTheme(context),
//        initialRoute: '/settings',
      ),
      providers: [
        //
        // SERVICE PROVIDERS
        //
        Provider<WeightEntryProvider>(
          create: (_) => weightEntryProvider,
        ),
        Provider<MeasureProvider>(
          create: (_) => measureProvider,
        ),
        //
        // VIEW PROVIDERS
        //
        Provider<MainViewProvider>(
          create: (_) => MainViewProvider(weightEntryProvider),
        ),
        Provider<MeasureViewProvider>(
          create: (_) => MeasureViewProvider(measureProvider, weightEntryProvider),
        ),
      ],
    );
  }
}
