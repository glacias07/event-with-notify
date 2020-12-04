import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'colorcheme.dart';
import 'loginpage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: calendarPage(),
      theme: ThemeData(fontFamily: 'ubuntu'),
    );
  }
}

class calendarPage extends StatefulWidget {
  @override
  _calendarPageState createState() => _calendarPageState();
}

class _calendarPageState extends State<calendarPage> {
  FlutterLocalNotificationsPlugin fltrNotification;
  CalendarController _calendarController;
  TextEditingController _eventController;

  String email = '';
  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  Future logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    Fluttertoast.showToast(
        msg: "Logout Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  final GlobalKey<AnimatedListState> _key = GlobalKey();
  FirebaseAuth userid = FirebaseAuth.instance;
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  //bool _canShowButton = true;

  // void hideWidget() {
  //   setState(() {
  //     _canShowButton = !_canShowButton;
  //   });
  // }

  @override
  void dispose() {
    _calendarController.dispose();
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: DrawerHeader(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                    ),
                    child: Center(
                      child: Text('Attendance\nManager',
                          style: TextStyle(
                              color: Colors.teal[100],
                              fontWeight: FontWeight.w700,
                              fontSize: 30.0)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey[700],
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Add Event',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                        onTap: () {
                          openAlertBox();
                        },
                      ),
                      Divider(
                        height: 4,
                        thickness: 0.5,
                        color: Colors.grey,
                      ),

                      // userid == null ?
                      // Container(
                      //   child: ListTile(
                      //     leading: Icon(
                      //       Icons.add,
                      //       color: Colors.white,
                      //     ),
                      //     title: Text(
                      //       'Log In',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //     trailing: Icon(
                      //       Icons.keyboard_arrow_right,
                      //       color: Colors.white,
                      //     ),
                      //     onTap: () {Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => LoginPage()));},
                      //   ),
                      // ) :
                      Container(
                        child: ListTile(
                          leading: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Log out',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                          onTap: () {
                            logOut(context);
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ],
                    padding: EdgeInsets.only(top: 0),
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: purple,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Event Management',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            TableCalendar(
              calendarController: _calendarController,
              initialCalendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              formatAnimation: FormatAnimation.slide,
              // onDaySelected: (date) {
              //   print(date.toIso8601String());
              // },
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                leftChevronIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 15,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 15,
                ),
                leftChevronMargin: EdgeInsets.only(left: 70),
                rightChevronMargin: EdgeInsets.only(right: 70),
              ),
              calendarStyle: CalendarStyle(
                  weekendStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white)),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.white),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.87,
                    child: AnimatedList(
                        key: _key,
                        initialItemCount: _items.length,
                        itemBuilder: (context, index, animation) {
                          return eventBox(
                              stime, etime, comittee, eventname, index);
                        })),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _addItem(),
        ),
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.Max, priority: Priority.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);
    var scheduledTime = DateTime.now().add(Duration(seconds: 5));

    fltrNotification.schedule(
        1, 'task', 'it works', scheduledTime, generalNotificationDetails);
  }

  Future<LoginPage> _signOut() async {
    await FirebaseAuth.instance.signOut();

    return new LoginPage();
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('You will recieve a reminder in 1 hour'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Row eventBox(String startTime, String endTime, String comName,
      String eventName, int index) {
    bool _visible = true;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          width: MediaQuery.of(context).size.width * 0.15,
          child: Text(
            startTime,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: MediaQuery.of(context).size.width * 0.028,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Color(0xffdfdeff),
              ),
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              // color: Color(0xffdfdeff),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/pp.jpg',
                              width: 60,
                              height: 60,
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comName,
                            style: TextStyle(
                                color: purple, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            eventName,
                            style: TextStyle(
                                color: purple, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer,
                                color: purple,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '$startTime  - $endTime ',
                                style: TextStyle(
                                    color: purple,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 0.5,
                    color: Colors.teal[300],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          //!_canShowButton? const SizedBox.shrink():
                          Text(
                            'Sent the list to\nthe coordinator?',
                            style: TextStyle(
                                color: purple, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            child:
                                //!_canShowButton? const SizedBox.shrink():
                                Visibility(
                              visible: _visible,
                              child: IconButton(
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  _removeItem(index);
                                },
                              ),
                            ),
                            width: 55,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            child:
                                //!_canShowButton? const SizedBox.shrink():
                                IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _showAddDialog();
                                _showNotification();
                              },
                            ),
                            width: 55,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
        )
      ],
    );
  }

  void _removeItem(int i) {
    String removeditem = _items.removeAt(i);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return eventBox(
          '11 AM', '12 PM', 'Developer Students Club', 'Meeting', i);
    };
    _key.currentState.removeItem(i, builder);
  }

  void _addItem() {
    int i = _items.length > 0 ? _items.length : 0;
    _items.insert(i, 'item 1');
    _key.currentState.insertItem(i);
  }

  String comittee, eventname, stime, etime, date;

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[],
                    ),
                    _builddropdown(),
                    _buildEventRow(),
                    _buildTimeRow(),
                    _buildSubmitButton(),
                  ],
                ),
              ));
        });
  }

  Widget _builddropdown() {
    return DropdownButton<String>(
      value: comittee,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 24,
      elevation: 10,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        width: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          comittee = newValue;
        });
      },
      items: <String>[
        'Student Council',
        'Developer Students Club',
        'National Service Scheme'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 10, top: 10),
          child: RaisedButton(
            elevation: 4.0,
            color: logincolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              _addItem();
              Navigator.pop(context);
            },
            child: Text(
              "Submit",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTimeRow() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 100,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      stime = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    hintText: 'eg: 10 am',
                    labelStyle: TextStyle(color: purple),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Text(
                'To',
                style: TextStyle(color: purple, fontSize: 20),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 100,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      etime = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    hintText: 'eg: 11 am',
                    labelStyle: TextStyle(color: purple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventRow() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        keyboardType: TextInputType.name,
        onChanged: (value) {
          setState(() {
            eventname = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Event Name',
          labelStyle: TextStyle(color: purple),
        ),
      ),
    );
  }
}
