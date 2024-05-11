import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron/cron.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:licenta_ui/models/average_parameters_per_day.dart';
import 'package:licenta_ui/requests.dart';

import 'app_bar.dart';
import 'charts_screen.dart';
import 'models/ideal_parameters_object.dart';
import 'models/plant.dart';
import 'models/real_parameters_object.dart';
import 'monitoring_screen.dart';
import 'notifications/verify_parameters.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RealParametersObject realParametersObject = RealParametersObject();
  RealParametersObject lastRealParametersObject = RealParametersObject();
  IdealParametersObject idealParametersObject = IdealParametersObject();
  String lastPlantSpecies = '';

  var selectedIndex = 0;
  Timer? _timer;
  Cron cron = Cron();
  List<String>? dropDownOptions;
  String dropdownDisplayedValue = 'Select plant species';
  List<List<double>> weeklySummary = [[], [], [], []];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: Text(
                  'Allow',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      }
    });

    // AwesomeNotifications().createdStream.listen((notification) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text(
    //       'Notification Created on ${notification.channelKey}',
    //     ),
    //   ));
    // });

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel') {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
    });
    getPlants();
    getRealParameters();
    getAverageParametersPerWeek();
    cron.schedule(Schedule.parse('01 00 * * *'), () async {
      getAverageParametersPerWeek();
      print("This code runs at 12am everyday");
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getAndVerifyRealParameters();
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> getRealParameters() async {
    var response = await BaseClient().getRealParameters('/real_parameters/');
    setState(() {
      realParametersObject =
          RealParametersObject.fromJson(json.decode(response));
    });
  }

  Future<void> getAndVerifyRealParameters() async {
    getRealParameters();
    if (dropdownDisplayedValue == 'Select plant species') return;

    verifyRealParameters(realParametersObject, lastRealParametersObject,
        idealParametersObject, lastPlantSpecies);
    lastRealParametersObject = realParametersObject;
    lastPlantSpecies = idealParametersObject.species;
  }

  Future<void> getPlants() async {
    var response = await BaseClient().getPlants('/plants/');
    List<Plant> plants = plantsFromJson(response);
    setState(() {
      dropDownOptions = getSpecies(plants);
    });
  }

  Future<void> getAverageParametersPerWeek() async {
    var response = await BaseClient()
        .getAverageParametersPerWeeek('/average_parameters_per_week/');
    List<AverageParametersPerDay> averageParametersPerWeek =
        averageParametersPerDayFromJson(response);
    setState(() {
      for (var averageParametersPerDay in averageParametersPerWeek) {
        {
          weeklySummary[0].add(averageParametersPerDay.averageTemperature);
          weeklySummary[1].add(averageParametersPerDay.averageLightLevel);
          weeklySummary[2].add(averageParametersPerDay.averageAirMoisture);
          weeklySummary[3].add(averageParametersPerDay.averageSoilMoisture);
        }
      }
    });
  }

  void openIndications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Be carefull!'),
        content: Text(
            'It looks like soil moisture is very low. Either your plant desperately needs water or you forgot to place the monitoring device into plant\'s soil. Don\'t forget to do so and to choose your plant\'s species for better advice. '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Ok',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> dropdownCallback(String? selectedValue) async {
    var response =
        await BaseClient().getIdealParameters('/plants/$selectedValue');
    setState(() {
      idealParametersObject =
          IdealParametersObject.fromJson(json.decode(response));
    });
    if (selectedValue is String) {
      setState(() {
        dropdownDisplayedValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MonitoringPage(realParametersObject: realParametersObject);
        break;
      case 1:
        page = ChartsPage(
          weeklySummary: weeklySummary,
        );
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    var colorScheme = Theme.of(context).colorScheme;

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: AppBarTitle(),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.black,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Good to know'),
                    content: Text(
                        'Firstly, you should place the monitoring device into your plant\'s soil to collect the needed data. Secondly, be sure that you select your plant\'s species as we can give you better advice for carring your plant. Enjoy!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ]),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Column(
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.zero),
                    color: Colors.teal),
                child: DropdownButton<String>(
                  hint: Text('Select plant species'),
                  dropdownColor: Colors.teal[100],
                  focusColor: Colors.teal,
                  borderRadius: BorderRadius.circular(12),
                  value: dropdownDisplayedValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 35.0,
                  iconEnabledColor: Colors.black,
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                  onChanged: dropdownCallback,
                  items: dropDownOptions
                      ?.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(child: mainArea),
              SafeArea(
                child: BottomNavigationBar(
                  backgroundColor: Colors.teal[50],
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.auto_graph),
                      activeIcon: Icon(Icons.auto_graph_outlined),
                      label: 'Monitoring',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.chartBar),
                      activeIcon: FaIcon(FontAwesomeIcons.solidChartBar),
                      label: 'History',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  backgroundColor: Colors.teal[50],
                  extended: constraints.maxWidth >= 600,
                  minWidth: 70,
                  useIndicator: true,
                  indicatorColor: Colors.teal[75],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_graph),
                      selectedIcon: Icon(Icons.auto_graph_outlined),
                      label: Text('Monitoring'),
                    ),
                    NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.chartBar),
                        selectedIcon: FaIcon(FontAwesomeIcons.solidChartBar),
                        label: Text('History')),
                    // NavigationRailDestination(
                    //   icon: Icon(Icons.favorite),
                    //   selectedIcon: Icon(Icons.favorite_outlined),
                    //   label: Text('Actions'),
                    // ),
                    // NavigationRailDestination(
                    //   icon: Icon(Icons.account_circle_outlined),
                    //   selectedIcon: Icon(Icons.account_circle),
                    //   label: Text('Profile'),
                    // )
                  ],
                ),
              ),
              Expanded(child: mainArea),
            ],
          );
        }
      }),
    );
  }
}
