import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:optix_scouting/utilities/classes.dart';
import 'pages/home.dart';
import 'pages/field.dart';
import 'pages/history.dart';
import 'pages/match.dart';
import 'pages/pit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final cameras = await availableCameras(); // just had to input
  // final mainCamera = cameras.first;
  runApp(new MyApp());
}
// Map<String, WidgetBuilder> routes = {
//   'home': (context) => HomePage(),
//   'match': (context) => Match(),
//   'pit': (context) => Pit(),
//   'history': (context) => History(),
//   'field': (context) => Field(),\
// };

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      // routes: routes,
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  late List<Widget> _widgetOptions;

  MatchInfo matchInfo = MatchInfo(
      teamNumber: "3749",
      teamName: "Team Optix",
      matchNumber: 42,
      comp: "San Diego Regional",
      alliance: "Red");
  Map<String, int> scoreChanges = {
    "Upper": 5,
    "Middle": 3,
    "Lower": 2,
  };

  void _onBottomTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
    });
  }

  Map<String, int> getScoreChanges() {
    return scoreChanges;
  }

  MatchInfo getMatchInfo() {
    return matchInfo;
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = [
      HomePage(
        changeIndex: pageController.jumpToPage,
        getMatchInfo: getMatchInfo,
      ),
      Match(
        getScoreChanges: getScoreChanges,
        getMatchInfo: getMatchInfo,
      ),
      Pit(
        teamName: matchInfo.teamName,
        competition: matchInfo.comp,
        changeIndex: pageController.jumpToPage,
      ),
      History(),
      Field(),
    ];

    Widget bottomItem(
        {required int index, required String title, required IconData icon}) {
      if (index == _currentIndex) {
        return Icon(
          icon,
          size: 26,
          color: Colors.white,
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        );
      }
    }

    Widget bottomNavBar = CurvedNavigationBar(
      index: _currentIndex,

      height: 60,
      // selectedFontSize: 12,
      // unselectedFontSize: 12,
      // showUnselectedLabels: true,
      buttonBackgroundColor: Color.fromARGB(255, 78, 118, 247),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      color: Color.fromRGBO(11, 34, 107, 1),
      // unselectedItemColor: Color.fromRGBO(11, 34, 107, 1),
      // selectedItemColor: Color.fromRGBO(11, 34, 107, 1),
      items: [
        bottomItem(
          title: 'Home',
          icon: Icons.home,
          index: 0,
        ),
        bottomItem(
          title: 'Match',
          icon: Icons.sports_esports,
          index: 1,
        ),
        bottomItem(
          title: 'Pit',
          icon: Icons.assignment,
          index: 2,
        ),
        bottomItem(
          title: 'History',
          icon: Icons.history,
          index: 3,
        ),
        bottomItem(
          title: 'Field',
          icon: Icons.palette,
          index: 4,
        ),
      ],
      onTap: _onBottomTapped,
    );

    return MaterialApp(
      title: 'Optix Scouting',
      home: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {});
        }),
        child: Scaffold(
          // body: Center(
          //   child: _widgetOptions.elementAt(_currentIndex),
          // ),
          body: PageView(
              children: _widgetOptions,
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                  print(value);
                });
              },
              physics: NeverScrollableScrollPhysics()),
          bottomNavigationBar: bottomNavBar,
        ),
      ),
    );
  }
}
