import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_time_db/models/user.dart';
import 'package:real_time_db/services/rtdb.dart';
import 'package:real_time_db/services/storage_service.dart';

class DetailPage extends StatefulWidget {
  static const id = "/detail_page";
  PostModel? user;
  DetailPage({super.key, this.user});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();

  List<PostModel> list = [];
  List<String> itemList = [];
  bool isStorageCame = false;

  Future<void> _store() async {
    widget.user =
        PostModel(name: nameController.text, email: emailController.text);

    await RTDBService.create(postModel: widget.user!);
    print(widget.user?.email);
    Navigator.pop(context, true);
  }

  void loadNote(PostModel? user) {
    if (user != null) {
      setState(() {
        nameController.text = user.name;
        emailController.text = user.email;
      });
    }
  }

  Future<File> takeFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    File file = File(xFile?.path ?? "");
    return file;
  }

  Future<String> uploadFile() async {
    String link = await StorageService.upload(file: await takeFile());
    widget.user?.img = link;
    print("upload check: ${widget.user?.img}");
    setState(() {});
    return link;
  }

  Future<void> getFile() async {
    isStorageCame = false;
    itemList = await StorageService.getFile();
    isStorageCame = true;
    setState(() {});
  }

  @override
  void initState() {
    loadNote(widget.user);
    getFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await _store();
                nameController.clear();
                emailController.clear();
              },
              icon: const Icon(Icons.done_outline),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: nameController,
              maxLength: 25,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  hintText: "Name",
                  hintStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          Expanded(
            flex: 8,
            child: TextField(
              controller: emailController,
              maxLines: 50,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          Expanded(
            flex: 2,
            child: (widget.user?.img != null && widget.user!.img!.isNotEmpty)
                ? Image.network(widget.user!.img!)
                : Text("There could be your photo"),
          ),
          Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: MaterialButton(
              onPressed: () async {
                String img = await uploadFile();
                widget.user!.img = img;
                setState(() {});
              },
              child: Icon(Icons.photo),
            ),
          ),
        ]));
  }
}
