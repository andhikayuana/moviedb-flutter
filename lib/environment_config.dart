import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  final moviedbApiKey = const String.fromEnvironment("MOVIEDB_API_KEY");
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
