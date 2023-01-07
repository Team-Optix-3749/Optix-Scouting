import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util.dart';

class HomePage extends StatefulWidget with Util {
  final Function changeIndex;
  final Function getTeamNumber;
  HomePage({Key? key, required this.changeIndex, required this.getTeamNumber})
      : super(key: key);

  static const String routeName = "/HomePage";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  String? preset;
  Map<String, int> presets = {
    "Default": 0,
    "Default ": 1,
    // "Add preset": 2,
  };
  Map<int, Icon> presetIcons = {
    0: Icon(
      Icons.sports_esports,
      color: Colors.black54,
    ),
    1: Icon(
      Icons.assignment,
      color: Colors.black54,
    ),
    2: Icon(
      Icons.add,
      color: Colors.black54,
    )
  };
  int gotoIndex = -1;

  late TextEditingController _PresetController;

  final List<Image> images = [
    Image.asset(
      'assets/Emo_Venom.jpg',
      width: double.infinity,
      fit: BoxFit.fitWidth,
    ),
    Image.asset(
      'assets/RoboticsCompDay2-10.jpg',
      width: double.infinity,
      fit: BoxFit.fitWidth,
    ),
    Image.asset(
      'assets/Venom-12.jpg',
      width: double.infinity,
      fit: BoxFit.fitWidth,
    ),
    Image.asset(
      'assets/RoboticsCompDay2-11.jpg',
      width: double.infinity,
      fit: BoxFit.fitWidth,
    ),
  ];

  String _teamNumber = '3749';
  String _matchNumber = '42';
  bool _isEditingTeamNumber = false;
  bool _isEditingMatchNumber = false;
  late TextEditingController _TeamNumberController;
  late TextEditingController _MatchNumberController;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<String> getLabels() {
    return [_teamNumber, _matchNumber];
  }

  void setLabels(String team, String match) {
    _teamNumber = team;
    _matchNumber = match;
  }

  Widget _editTeamNumber() {
    if (_isEditingTeamNumber) {
      return SizedBox(
        width: 200.0,
        height: 20,
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSubmitted: (value) {
            setState(
              () {
                _teamNumber = value;
                _isEditingTeamNumber = false;
                widget.getTeamNumber(_teamNumber, _matchNumber);
              },
            );
          },
        ),
      );
    }

    return InkWell(
      onTap: () {
        setState(() {
          _isEditingTeamNumber = true;
        });
      },
      child: Text(
        _teamNumber,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16.5,
        ),
      ),
    );
  }

  Widget _editMatchNumber() {
    if (_isEditingMatchNumber) {
      return SizedBox(
        width: 21.0,
        height: 22,
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSubmitted: (value) {
            setState(
              () {
                _matchNumber = value;
                widget.getTeamNumber(_teamNumber, _matchNumber);

                _isEditingMatchNumber = false;
              },
            );
          },
        ),
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingMatchNumber = true;
        });
      },
      child: Text(
        _matchNumber,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16.5,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      images.forEach((image) {
        precacheImage(image.image, context);
      });
    });
    _TeamNumberController = TextEditingController(text: _teamNumber);
    _MatchNumberController = TextEditingController(text: _matchNumber);
    _PresetController = TextEditingController();
    _isEditingTeamNumber = false;
    _isEditingMatchNumber = false;
    setState(() {
      widget.getTeamNumber(_teamNumber, _matchNumber);
    });
    super.initState();
  }

  @override
  void dispose() {
    _TeamNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 0, right: 16),
                  child: _editTeamNumber(),
                ),
                Text(
                  'Team Optix',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14.5,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(minWidth: 60, maxWidth: 60),
                      child: Text(
                        'Match: ',
                        style: TextStyle(fontSize: 16.5),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minWidth: 25, maxWidth: 25),
                      child: _editMatchNumber(),
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(minWidth: 500, maxWidth: 500),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'FIRST ENERGIZED',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    Widget presetSection = Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 32, right: 0),
          child: Center(
            child: Container(
              width: 150,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: const Text(
                    'Select Preset',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  items: presets.keys
                      .map(
                        (p) => DropdownMenuItem<String>(
                          value: p,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                p.trim(),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                child: presetIcons[presets[p]],
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  value: preset,
                  onChanged: (value) {
                    setState(() {
                      preset = value!;
                      switch (presets[preset]) {
                        case -1:
                          gotoIndex = 0;
                          break;
                        case 0:
                          gotoIndex = 1;
                          break;
                        case 1:
                          gotoIndex = 2;
                          break;
                        default:
                          break;
                      }
                      print(gotoIndex);
                    });
                  },
                  buttonHeight: 40,
                  dropdownWidth: 140,
                  itemHeight: 40,
                  dropdownMaxHeight: 160,
                  searchController: _PresetController,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4,
                      top: 8,
                      left: 8,
                      right: 8,
                    ),
                    child: TextFormField(
                      controller: _PresetController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for an preset...',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: ((item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  }),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      _PresetController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          child: OutlinedButton(
            child: Text(
              "  Start Scout  ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Match(),
              //   ),
              // );
              if (gotoIndex < 0) {
                showDialog(
                  context: context,
                  builder: ((context) => Util.buildPopupDialog(
                      context, "No preset", <Widget>[Text("Select a preset")])),
                );
              } else {
                widget.changeIndex(gotoIndex);
              }
            },
          ),
        )
      ],
    );

    return MaterialApp(
      title: 'Optix Scouting',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('HOME'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: (() {}),
                child: Icon(Icons.settings),
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 255),
              child: CarouselSlider.builder(
                itemCount: images.length,
                options: CarouselOptions(
                  aspectRatio: 13 / 10,
                  autoPlay: true,
                  viewportFraction: 1,
                  height: 312,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                itemBuilder: (context, index, realIdx) {
                  return Container(
                    child: images[index],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, top: 16),
              alignment: Alignment.centerLeft,
              child: Container(
                child: const Text(
                  "Scouting ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            titleSection,
            presetSection,
            Container(
              padding: EdgeInsets.all(16),
              child: Divider(
                thickness: 2,
                color: Color.fromARGB(64, 0, 0, 0),
              ),
            ),
            Wrap(
              children: images
                  .map((item) => Container(
                        width: 0,
                        height: 0,
                        color: Colors.white,
                        child: Image(
                          image: item.image,
                        ),
                      ))
                  .toList()
                  .cast<Widget>(),
            ),
          ],
        ),
      ),
    );
  }
}
