import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:moviedb_flutter/moviedb_app.dart';

void main() {
  runApp(ProviderScope(child: MoviedbApp()));
}
