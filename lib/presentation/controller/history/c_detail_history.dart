import 'package:dompetku/data/model/history.dart';
import 'package:get/get.dart';

import '../../../data/source/source_history.dart';

class CDetailHistory extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _data = History().obs;
  History get data => _data.value;

  getData(idUser, type, date) async {
    _loading.value = true;
    update();

    History? history = await SourceHistory.detailHistory(idUser, type, date);
    _data.value = history ?? History();
    update();

    Future.delayed(const Duration(milliseconds: 900), () {
      _loading.value = false;
      update();
    });
  }
}