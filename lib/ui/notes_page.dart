import 'package:flutter/material.dart';
import 'package:flutter_packages/model/note_model.dart';
import 'package:flutter_packages/service/database_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  final id;

  NotesPage({Key? key, this.id}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var liste = [0xfff28c8f, 0xfff2b8a4, 0xff558fa7, 0xff2d6073];
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Not Sayfası',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  dialog('add');
                },
                icon: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.red.shade500,
                )),
          ),
        ],
      ),
      body: FutureBuilder<List<NoteModel>?>(
          future: DatabaseHelper.instance.getNotes(widget.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Henüz notumuz yok'),
                );
              } else {
                return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      NoteModel oneNote = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    back();
                                    dialog('edit', oneNote: oneNote);
                                  },
                                  child: const Text('Güncelle'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    back();
                                  },
                                  child: const Text('Vazgeç'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDoubleTap: () {
                          DatabaseHelper.instance
                              .changeCompleted(oneNote.id, oneNote.completed);
                          setState(() {});
                        },
                        onLongPress: ()async{
                          var result = await DatabaseHelper.instance.deletNote(oneNote.id);
                          if(result){
                            setState(() {

                            });
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          color: oneNote.completed == 1
                              ? Color(liste[index % 4])
                              : Colors.grey.shade700,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    oneNote.note!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DateFormat.Hm()
                                      .format(DateTime.parse(oneNote.date!)),
                                  style:
                                  const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
  }

  int? isCompleted;

  dialog(result, {NoteModel? oneNote}) {
    if (result == 'edit') {
      controller2.text = oneNote!.note!;
      isCompleted = oneNote.completed;
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: TextFormField(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: controller2,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      NoteModel noteModel = NoteModel(
                          categoryId: widget.id,
                          note: controller2.text,
                          date: DateTime.now().toIso8601String(),
                          id: oneNote.id);
                      var sonuc =
                          await DatabaseHelper.instance.editNote(noteModel);
                      if (sonuc!) {
                        setState(() {});
                        controller2.clear();
                        back();
                      }
                    },
                    child: const Text('Kaydet'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      back();
                    },
                    child: const Text('Vazgeç'),
                  ),
                ],
              ));
    }  else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Not Giriniz'),
                content: TextFormField(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: controller,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      NoteModel note = NoteModel(
                          note: controller.text,
                          date: DateTime.now().toIso8601String(),
                          categoryId: widget.id,
                          completed: 0);
                      var result = await DatabaseHelper.instance.addNote(note);
                      if (result!) {
                        back();
                        controller.clear();
                        setState(() {});
                      }
                    },
                    child: const Text('Ekle'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      back();
                    },
                    child: const Text('Vazgeç'),
                  ),
                ],
              ));
    }
  }

  back() {
    Navigator.of(context).pop();
  }
}
