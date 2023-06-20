import 'package:d_info/d_info.dart';
import 'package:intl/intl.dart';

import '../../config/api.dart';
import '../../config/app_request.dart';
import '../model/history.dart';

class SourceHistory {
  static Future<Map> analysis(String idUser) async {
    String url = '${Api.history}/analysis.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_user': idUser,
      'today': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });

    if (responseBody == null) {
      return {
      'today': 0.0,
      'yesterday': 0.0,
      'week': [0.0,0.0,0.0,0.0,0.0,0.0,0.0],
      'month': {
        'income': 0.0,
        'outcome': 0.0
      }
    };
    }

    return responseBody;
  }

  static Future<bool> add(String idUser, String type, String date, String total, String details) async {
    String url = '${Api.history}/add.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_user': idUser,
      'type': type,
      'date': date,
      'total': total,
      'details': details,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (responseBody == null) return false;

    if (responseBody['success']) {
      DInfo.dialogSuccess('Berhasil Tambah history');
      DInfo.closeDialog();
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError('Date sudah ada! Gagal tambah history');
      } else {
        DInfo.dialogError('Gagal Tambah History');
      }
      DInfo.closeDialog();
    }

    return responseBody['success'];
  }

  static Future<bool> update(String idHistory, String idUser, String type, String date, String total, String details) async {
    String url = '${Api.history}/update.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_history': idHistory,
      'id_user': idUser,
      'type': type,
      'date': date,
      'total': total,
      'details': details,
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (responseBody == null) return false;

    if (responseBody['success']) {
      DInfo.dialogSuccess('Berhasil Update history');
      DInfo.closeDialog();
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError('Date sudah ada! Gagal Update history');
      } else {
        DInfo.dialogError('Gagal Update History');
      }
      DInfo.closeDialog();
    }

    return responseBody['success'];
  }

  static Future<bool> delete(String idHistory) async {
    String url = '${Api.history}/delete.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_history': idHistory,
    });

    if (responseBody == null) return false;

    return responseBody['success'];
  }

  static Future<List<History>> incomeOutcome(String idUser, String type) async {
    String url = '${Api.history}/income_outcome.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_user': idUser,
      'type': type,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<History>> incomeOutcomeSearch(String idUser, String type, String date) async {
    String url = '${Api.history}/income_outcome_search.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_user': idUser,
      'type': type,
      'date': date,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<History>> history(String idUser) async {
    String url = '${Api.history}/history.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_user': idUser,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<History>> historySearch(String idUser, String date) async {
    String url = '${Api.history}/history_search.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_user': idUser,
      'date': date,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }

  static Future<History?> whereDate(String idHistory, String idUser, String date) async {
    String url = '${Api.history}/where_date.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_history': idHistory,
      'id_user': idUser,
      'date': date
    });

    if (responseBody == null) return null;

    if (responseBody['success']) {
      var e = responseBody['data'];
      return History.fromJson(e);
    }
    return null;
  }

  static Future<History?> detailHistory(String idUser, String type, String date) async {
    String url = '${Api.history}/detail_history.php';
    Map? responseBody = await AppRequest.posts(url, {
      'id_user': idUser,
      'type': type,
      'date': date,
    });

    if (responseBody == null) return null;

    if (responseBody['success']) {
      var e = responseBody['data'];
      return History.fromJson(e);
    }
    return null;
  }
}