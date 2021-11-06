import 'package:flutter/material.dart';
import 'package:sqlite_app/student_form.dart';
import 'package:sqlite_app/db/databaseProvider.dart';
import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late DatabaseHandler handler;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   this.handler = DatabaseHandler();
  //   this.handler.initializeDB().whenComplete(() async {
  //     // await this.addUsers();
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    DatabaseHandler handler = Provider.of<DatabaseHandler>(context);
    handler.initializeDB();
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StudentForm()),
              );
              setState(() {});
            },
            icon: Icon(Icons.person_add_alt_1_outlined),
          ),
        ],
      ),
      body: FutureBuilder(
        future: handler.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text("Are you sure you wish to delete this Student?"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("DELETE")
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCEL"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await handler.deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      title: Text("Name: ${snapshot.data![index].name!}"),
                      subtitle: Text(
                          "Age: ${snapshot.data![index].age.toString()}\nPlace: ${snapshot.data![index].place!}\nEmail: ${snapshot.data![index].email!}"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentForm(student: snapshot.data![index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
