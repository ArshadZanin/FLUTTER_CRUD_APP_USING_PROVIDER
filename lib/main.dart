import 'package:flutter/material.dart';
import 'package:sqlite_app/db/databaseProvider.dart';
import 'package:sqlite_app/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DatabaseHandler(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sqlite App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Students Data'),
      ),
    );
  }
}
