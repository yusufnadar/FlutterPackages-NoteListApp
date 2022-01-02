import 'package:flutter/material.dart';
import 'package:flutter_packages/model/category_model.dart';
import 'package:flutter_packages/service/database_helper.dart';
import 'package:flutter_packages/ui/notes_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Defterim'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog('add');
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          size: 26,
        ),
      ),
      body: FutureBuilder<List<CategoryModel>?>(
          future: DatabaseHelper.instance.getCategories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Kategori yok'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      CategoryModel category = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  NotesPage(id:snapshot.data![index].id)));
                        },
                        child: ListTile(
                          title: Text(
                            category.category!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          leading: GestureDetector(
                              onTap: () {
                                dialog('edit',category: category);
                              },
                              child: const FaIcon(
                                FontAwesomeIcons.edit,
                                size: 22,
                              )),
                          trailing: GestureDetector(
                              onTap: () {
                                dialog('delete',category: category);
                              },
                              child: const FaIcon(
                                FontAwesomeIcons.trashAlt,
                                size: 22,
                              )),
                        ),
                      );
                    });
              }
            }
          }),
    );
  }

  dialog(result,{CategoryModel? category}) {
    if (result == 'edit') {
      controller2.text = category!.category!;
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: TextFormField(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            controller: controller2,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                CategoryModel categoryModel = CategoryModel(id: category.id,category: controller2.text);
                var result = await DatabaseHelper.instance.editCategory(categoryModel);
                if(result!){
                  back();
                  controller2.clear();
                  setState(() {

                  });
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
        ),
      );
    } else if (result == 'delete') {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Emin misiniz?'),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      var result = await DatabaseHelper.instance.deleteCategory(category!.id);
                      if(result!){
                        back();
                        setState(() {

                        });
                      }
                    },
                    child: const Text('Sil'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      back();
                    },
                    child: const Text('Vazgeç'),
                  ),
                ],
              ));
    } else {
      return showDialog(
        barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Kategori Giriniz'),
                content: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Kategori', border: OutlineInputBorder()),
                  controller: controller,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      CategoryModel category =
                          CategoryModel(category: controller.text);
                      Navigator.of(context).pop();
                      var result =
                          await DatabaseHelper.instance.addCategories(category);
                      if (result!) {
                        setState(() {
                          controller.clear();
                        });
                      }
                    },
                    child: const Text('Ekle'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      back();
                        controller.clear();
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
