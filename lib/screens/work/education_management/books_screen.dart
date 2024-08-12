import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Classes/objects/book.dart';
import '../../../Classes/person.dart';

class BooksScreen extends StatefulWidget {
  final Person person;

  BooksScreen({required this.person});

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    String data = await rootBundle.loadString('assets/books.json');
    List<dynamic> jsonResult = jsonDecode(data);
    books = jsonResult.map((bookJson) => Book.fromJson(bookJson)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text("Author: ${book.author}\nImproves: ${book.skills.keys.join(', ')}"),
            onTap: () {
              widget.person.useBook(book);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Read ${book.title} and improved skills!")),
              );
            },
          );
        },
      ),
    );
  }
}
