import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_autoput2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: const MyHomePage(),);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final List<BookItem> bookList = <BookItem>[];

  //初期処理
  @override
  void initState(){
    super.initState();
    search();
    setState(() {});
  }

  //初期処理中身
  Future<void> search() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final snapshot = await fireStore.collection('books').orderBy('no').get();
    for(var element in snapshot.docChanges){
      bookList.add(BookItem(element.doc.get('no'), element.doc.get('title'), element.doc.get('author'), element.doc.get('year')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アウトプット2'),
      ),
      body: ListView.builder(
        itemCount: bookList.length, //一覧の行数を指定
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(bookList[index].no),
            title: Text(bookList[index].title),
            subtitle: Text(bookList[index].author),
            trailing: Text(bookList[index].year),
          );
        },
      ),
    );
  }
}

class BookItem {
  String no;
  String title;
  String author;
  String year;
  BookItem(this.no, this.title, this.author, this.year);
}
