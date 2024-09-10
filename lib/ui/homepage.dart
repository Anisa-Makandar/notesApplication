import 'package:flutter/material.dart';
import 'package:notes_application/domain/db_helper.dart';
import 'package:notes_application/ui/detailspage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper dbHelper = DBHelper.getinstance();
  List<Map<String, dynamic>> allNotes = [];
  final List<Color> cardColors = [
    Color(0xFFFFAB91),
    Color(0xFFFFCC80),
    Color(0xFFE6EE9B),
    Color(0xFF80DEEA),
    Color(0xFFCF93D9),
    Color(0xFF80CBC4),
    Color(0xFFF48FB1),
  ];

  @override
  void initState() {
    super.initState();
    getMyNotes(); // Load the notes from the database when the page initializes
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF252525),
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
                        Text(
                          'Notes',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                          height: 40,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFF3B3B3B),
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      itemCount: allNotes.length,
                      itemBuilder: (context, index) {
                        Color cardColor = cardColors[index % cardColors.length];

                        return GestureDetector(
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  isUpdate: true, // Indicates updating mode
                                  id: allNotes[index][DBHelper
                                      .COLUMN_NOTE_ID], // Pass the note's ID
                                  initialTitle: allNotes[index][DBHelper
                                      .COLUMN_NOTE_TITLE], // Pass the note's title
                                  initialDesc: allNotes[index][DBHelper
                                      .COLUMN_NOTE_DESC], // Pass the note's description
                                ),
                              ),
                            );
                            // Reload notes after returning from DetailPage
                            if (result == true) {
                              getMyNotes();
                            }

                            // var result = await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DetailPage(),
                            //   ),
                            // );
                            // if (result == true) {
                            //   getMyNotes(); // Reload the notes after returning from DetailsPage
                            // }
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${allNotes[index][DBHelper.COLUMN_NOTE_TITLE]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      // Text(
                                      //   '${formattedDate}',
                                      //   style: TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w500,
                                      //     color: Color(0x47000000),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 11,
                        crossAxisSpacing: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 40,
              bottom: 50,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF252525),
                onPressed: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(),
                    ),
                  );

                  if (result == true) {
                    getMyNotes(); // Reload the notes after returning from DetailsPage
                  }
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMyNotes() async {
    allNotes = await dbHelper.getAllNotes();
    setState(() {});
  }
}
