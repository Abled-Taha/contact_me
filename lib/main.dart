import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  late Future people;
  Future getPeople() async {
    var response = await Dio()
        .get('http://192.168.10.2:5000/225338242/find');
    await Future.delayed(Duration(seconds: 1));
    return response.data;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contact Me'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    build(context);
                  });
                },
                child: Icon(
                  Icons.refresh_rounded,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: getPeople(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (index < snapshot.data.length) {
                    final person = snapshot.data['$index'];
                    String email = person['email'].toString();
                    String subject = person['subject'].toString();

                    return Container(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Center(
                          child: Text(
                            email,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        isThreeLine: true,
                        subtitle: Column(
                          children: [
                            Text(
                              subject,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Dio().request(
                                    'http://192.168.10.2:5000/225338242/delete/$email');
                                setState(() {
                                  build(context);
                                });
                              },
                              child: Text('Remove Entry'),
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Text('');
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
