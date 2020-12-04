import 'package:flutter/material.dart';

import 'colorcheme.dart';
import 'calander.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: eventPage(),
    );
  }
}

class eventPage extends StatefulWidget {
  @override
  _eventPageState createState() => _eventPageState();
}

class _eventPageState extends State<eventPage> {
  String comittee, eventname, stime, etime, date;

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

  Widget _buildDateRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            date = value;
          });
        },
        decoration: InputDecoration(labelText: 'Roll Number'),
      ),
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => calendarPage()));

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

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
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
          ),
        ),
      ],
    );
  }

  void Values(){
    var value = [comittee, eventname, stime, etime, date];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Manager'),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: purple,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildContainer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
