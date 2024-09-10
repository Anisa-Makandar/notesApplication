import 'package:flutter/material.dart';
import 'package:notes_application/domain/db_helper.dart';

class DetailPage extends StatefulWidget {
  final bool isUpdate;
  final int? id;
  final String? initialTitle;
  final String? initialDesc;

  DetailPage({
    this.isUpdate = false,
    this.id = 0,
    this.initialTitle,
    this.initialDesc,
  });
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  DBHelper dbHelper = DBHelper.getinstance();
  bool isUpdate = false;
  int id = 0;

  @override
  void initState() {
    super.initState();
    isUpdate = widget.isUpdate;
    id = widget.id!;
    if (isUpdate) {
      titleController.text = widget.initialTitle ?? '';
      descController.text = widget.initialDesc ?? '';
    }
    getMyNotes(); // Load notes from the database when the page initializes
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF252525),
        body: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 11.0, horizontal: 25),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 3, right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context); // Go back to the previous screen
                          },
                          child: Container(
                            height: 40,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF3B3B3B),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Check for empty fields before saving
                            if (titleController.text.isNotEmpty ||
                                descController.text.isNotEmpty) {
                              bool check = false;

                              if (isUpdate) {
                                // Update the note
                                check = await dbHelper.updateNote(
                                  updatedTitle: titleController.text,
                                  updatedDesc: descController.text,
                                  id: id,
                                );
                              } else {
                                // Add a new note
                                check = await dbHelper.addNote(
                                  title: titleController.text,
                                  desc: descController.text,
                                );
                              }

                              // If note is successfully added, navigate back to the home page
                              if (check) {
                                getMyNotes();
                                Navigator.pop(context,
                                    true); // Pass 'true' for successful save
                              }
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF3B3B3B),
                            ),
                            child: Icon(
                              isUpdate ? Icons.edit : Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: titleController,
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                hintStyle: TextStyle(color: Color(0x55FFFFFF)),
                                border: InputBorder.none,
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: descController,
                              maxLines:
                                  null, // Make the description field expandable
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Type Something...',
                                hintStyle: TextStyle(color: Color(0x55FFFFFF)),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: widget.isUpdate
                  ? IconButton(
                      onPressed: () async {
                        bool check = await dbHelper.deleteNote(id: id);
                        if (check) {
                          Navigator.pop(context,
                              true); // Go back and refresh the HomePage
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  // Load all notes from the database
  void getMyNotes() async {
    allNotes = await dbHelper.getAllNotes();
    setState(() {});
  }
}
