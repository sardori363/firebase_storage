import 'package:flutter/material.dart';
import 'package:real_time_db/models/user.dart';
import 'package:real_time_db/pages/details_page.dart';
import 'package:real_time_db/services/rtdb.dart';

class HomePage extends StatefulWidget {
  static const id = "/home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> list = [];

  void loadNotes() async {
    list = await RTDBService.getUsers();
    setState(() {});
  }

  void _openDetail() async {
    var result = await Navigator.pushNamed(context, DetailPage.id);
    if (result != null && result == true) {
      loadNotes();
    }
  }

  Future<void> _openDetailWithNote(PostModel user) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  user: user,
                )));
    if (result != null && result == true) {
      loadNotes();
    }
  }

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("assets/nav-left.png"),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
          child: Text(
            "Recent users",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/search.png"),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 20),
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: () async {
              print(list[index].id!);
              await RTDBService.deleteUser(list[index].id!);
              print(list[index].id!);
              list.removeWhere((user) => user.id == list[index].id);
              // Call setState to trigger a UI update
              setState(() {});
            },
            onTap: () {
              _openDetailWithNote(list[index]);
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 10,
              child: Container(
                // padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                          child: Text(
                        list[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                    ),
                    Container(
                      child: Center(
                          child: Text(
                        list[index].email,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      )),
                    ),
                    Container(
                      child: Center(
                          child: list[index].img == null
                              ? Text("no img")
                              : Image.network(list[index].img!)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openDetail();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
