#!/usr/bin/env dart
import 'dart:io';
import 'package:args/command_runner.dart';
import '../lib/app.dart';
import '../lib/cli/document.dart';
import '../lib/cli/user.dart';

main(List<String> args) async {
    await bootstrap();

    var runner = new CommandRunner('ds-cli', 'Document Store CLI')
        ..addCommand(new DocumentCommand())
        ..addCommand(new UserCommand());

    runner
        .run(args)
        .catchError((error) {
            print(error.message);
            exit(64);
        });
}
