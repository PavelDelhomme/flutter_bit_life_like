import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/plugins/book_system/widgets/book_screen.dart';
import 'package:bitlife_like/plugins/book_system/models/book.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = GameStateService.instance.character;
    final books = GameStateService.instance.inventory
        .whereType<Book>()
        .cast<Book>()
        .toList();

    return BookScreen(character: character, availableBooks: books);
  }
}
