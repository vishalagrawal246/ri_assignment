import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EmpData {
  List<dynamic> currentEmpList;
  List<dynamic> previousEmpList;

  EmpData({required this.currentEmpList, required this.previousEmpList});
}

class FetchData {
  static Future<EmpData> fetchSavedData() async {
    List<dynamic> currentEmpList = [];
    List<dynamic> previousEmpList = [];
    String? path;

    if (kIsWeb) {
      // Web: No need to specify a path
      await Hive.initFlutter();
      path = null;
    } else {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      path = appDocumentDirectory.path;
    }
    await BoxCollection.open(
      'ListOfEmp', // Name of your database
      {'currentEmp', 'previousEmp'},
      path: path, // Names of your boxes
    );
    await Hive.openBox<Map>('currentEmp');
    await Hive.openBox<Map>('previousEmp');
    final Box currentEmp = Hive.box<Map>('currentEmp');
    final Box previousEmp = Hive.box<Map>('previousEmp');
    //currentEmpList = currentEmp.get('qqq');
    for (var element in currentEmp.keys) {
      currentEmpList.add(currentEmp.get(element.toString()));
    }
    for (var element in previousEmp.keys) {
      previousEmpList.add(previousEmp.get(element.toString()));
    }

    debugPrint('${currentEmpList + currentEmp.keys.toList()}');
    debugPrint('================================+');
    debugPrint('${previousEmpList + previousEmp.keys.toList()}');
    return EmpData(
      currentEmpList: currentEmpList,
      previousEmpList: previousEmpList,
    );
  }
}
