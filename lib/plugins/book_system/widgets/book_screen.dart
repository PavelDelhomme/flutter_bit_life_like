
import 'package:flutter/material.dart';

import '../../../core/models/character.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookScreen extends StatelessWidget {
  final Character character;
  final List<Book> availableBooks;

  const BookScreen({super.key, required this.character, required this.availableBooks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bibliothèque")),
      body: ListView.builder(
        itemCount: availableBooks.length,
        itemBuilder: (context, index) {
          final book = availableBooks[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text("Par ${book.author}"),
            trailing: IconButton(
              icon: const Icon(Icons.menu_book),
              onPressed: () {
                BookService.readBook(character, book);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Livre lu ! Compétences améliorées.")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}