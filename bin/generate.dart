import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:dart_pubspec_licenses/dart_pubspec_licenses.dart' as oss;
import 'package:pana/src/license.dart' as pana_license;

const possibleLicenseFileNames = [
  'LICENSE',
  'LICENSE.md',
  'license',
  'license.md',
  'License',
  'License.md',
  'LICENCE',
  'LICENCE.md',
  'licence',
  'licence.md',
  'Licence',
  'Licence.md',
  'COPYING',
  'COPYING.md',
  'copying',
  'copying.md',
  'Copying',
  'Copying.md',
  'UNLICENSE',
  'UNLICENSE.md',
  'unlicense',
  'unlicense.md',
  'Unlicense',
  'Unlicense.md',
];

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('output', abbr: 'o', defaultsTo: 'assets/json/licenses.json');
  final argResults = parser.parse(arguments);
  final outputFile = File(argResults['output']);

  print('=== License Automator v1.0.0 ===');

  print('1/4: Listing all dependencies (using dart_pubspec_licenses)...');
  // oss.Package 객체에는 name, description, version, license로 구성됨.
  final deps = await oss.listDependencies(pubspecYamlPath: 'pubspec.yaml');
  final allPackages = [...deps.allDependencies, deps.package];

  print('2/4: Loading package config to find file paths...');
  final packageConfigFile = File('.dart_tool/package_config.json');
  if (!await packageConfigFile.exists()) {
    stderr.writeln('Error: .dart_tool/package_config.json not found.');
    exit(1);
  }

  final Map<String, String> packagePath = {};
  final packageCongfigJson =
      json.decode(await packageConfigFile.readAsString());
  for (final pkg in (packageCongfigJson['packages'] as List)) {
    final String name = pkg['name'];
    final String rootUri = pkg['rootUri'];
    packagePath[name] = p.fromUri(rootUri);
  }

  print('3/4: Analyzing licenses with pana (this may take a moment)...');
  final finalJsonList = <Map<String, dynamic>>[];

  for (final pkgInfo in allPackages) {
    final String pkgName = pkgInfo.name;
    String detectedSpdx = 'Unknown';

    final String? pkgPath = packagePath[pkgName];
    if (pkgPath != null) {
      // 이 패키지 폴더에서 'LICENSE' 파일 찾기
      File? licenseFile;
      for (final fileName in possibleLicenseFileNames) {
        final file = File(p.join(pkgPath, fileName));
        if (await file.exists()) {
          licenseFile = file;
          break;
        }
      }

      if (licenseFile != null) {
        final licenses = await pana_license.detectLicenseInFile(licenseFile,
            relativePath: licenseFile.path);
        if (licenses.isNotEmpty) {
          detectedSpdx = licenses.first.spdxIdentifier;
        }
      }
    }

    final finalMap = {
      'name': pkgInfo.name,
      'description': pkgInfo.description,
      'homepage': pkgInfo.homepage,
      'repository': pkgInfo.repository,
      'authors': pkgInfo.authors,
      'version': pkgInfo.version,
      'license': pkgInfo.license,
      'spdxIdentifiers': detectedSpdx,
      'isMarkdown': pkgInfo.isMarkdown,
      'isSdk': pkgInfo.isSdk,
    };
    finalJsonList.add(finalMap);
  }
  print('4/4: Saving final JSON to ${outputFile.path}');
  await outputFile.parent.create(recursive: true);
  final encoder = JsonEncoder.withIndent('  ');
  await outputFile.writeAsString(encoder.convert(finalJsonList));

  print('🎉 License generation complete!');
  exit(0);
}
