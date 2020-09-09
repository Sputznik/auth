import 'dart:async';
import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auth/models/categories-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesList extends StatefulWidget {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List _selectedTopics = List();
  Future<List<Topic>> _listTopics;
  StreamSubscription<DataConnectionStatus> listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  // SIMPLE CHECK TO SEE INTERNET CONNECTION
  checkInternet() async {
    // ACTIVELY LISTEN FOR STATUS UPDATES
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          setState(() {
            _listTopics = getData();
          });
          // print('Data connection is available.');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Text('Follow Topics'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: _listTopics,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Scaffold(
                      body: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Topic topic = snapshot.data[index]; //Your item
                            return CheckboxListTile(
                              activeColor: Colors.red[900],
                              value: _selectedTopics.contains(topic.id),
                              onChanged: (bool selected) {
                                _onCategorySelected(selected, topic.id);
                              },
                              title: Text(topic.name),
                            );
                          }),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            width: double.infinity,
            child: FlatButton(
              onPressed: _selectedTopics.length == 0 ? null : onConfirmTopics,
              disabledColor: Colors.red[900].withOpacity(0.4),
              disabledTextColor: Colors.white,
              color: Colors.red[900],
              textColor: Colors.white,
              child: Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }

  void _onCategorySelected(bool selected, topicId) {
    if (selected == true) {
      setState(() => _selectedTopics.add(topicId));
    } else {
      setState(() => _selectedTopics.remove(topicId));
    }
  }

  Future<List<Topic>> getData() async {
    var response = await http.get(
        'https://www.ykasandbox.com/wp-admin/admin-ajax.php?action=get_categories');
    return Categories.fromJson(json.decode(response.body)).topics;
  }

  onConfirmTopics() {
    setTopicsSeen(); //SET THE TOPICS SEEN VALUE
    Navigator.pushReplacementNamed(
        context, 'dashboard'); // REDIRECTS TO THE DASHBOARD
  }

  setTopicsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String categories = _selectedTopics.join(',');
    //Stores al the selected topics id
    prefs.setString('categories', categories);
    //Sets the topics flag
    prefs.setBool('topics', true);
  }
}
