import 'package:dompetku/config/app_color.dart';
import 'package:dompetku/config/app_format.dart';
import 'package:dompetku/data/model/history.dart';
import 'package:dompetku/presentation/controller/c_user.dart';
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/source/source_history.dart';
import '../../controller/history/c_history.dart';
import 'detail_history_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final controllerSearch = TextEditingController();

  refresh() async {
    cHistory.getList(cUser.data.idUser);
  }

  delete(idHistory) async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Hapus',
      'Yakin untuk hapus history ini ?',
      textNo: 'Batal',
      textYes: 'Ya',
    );

    if (yes != false) {
      bool success = await SourceHistory.delete(idHistory);
      if (success) refresh();
    }
  }



  @override
  void initState() {
    refresh();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Text('History'),
            Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controllerSearch,
                    onTap: () async {
                      DateTime? result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023,01,01),
                          lastDate: DateTime(DateTime.now().year + 1)
                      );
                      if(result!=null) {
                        controllerSearch.text = DateFormat('yyyy-MM-dd').format(result);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColor.chart.withOpacity(0.5),
                      suffixIcon: IconButton(
                        onPressed: () {
                          cHistory.search(
                              cUser.data.idUser,
                              controllerSearch.text
                          );
                        },
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16
                      ),
                      hintText: '2023/06/08'
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
            )
          ],
        ),
      ),
      body: GetBuilder<CHistory>(builder: (_) {
        if (_.loading) return DView.loadingCircle();
        if (_.list.isEmpty) return DView.empty('Kosong');
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
              itemCount: _.list.length,
              itemBuilder: (context, index) {
                History history = _.list[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => DetailHistoryPage(
                      idUser: cUser.data.idUser!,
                      type: history.type!,
                      date: history.date!,
                    ));
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      _.list.length - 1 == 9 ? 16 : 8,
                    ),
                    child: Row(
                      children: [
                        DView.spaceWidth(8),
                        history.type == 'Pemasukan' ?
                            Icon(Icons.south_west, color: Colors.green[300],)
                            :Icon(Icons.north_east, color: Colors.red[300],),
                        Text(
                          AppFormat.date(history.date!),
                          style: const TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Expanded(
                            child: Text(
                              AppFormat.currency(history.total!),
                              style: const TextStyle(
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.end,
                            )
                        ),
                        IconButton(onPressed: () => delete(history.idHistory!), icon: const Icon(Icons.delete_forever), color: Colors.red[300]!,),
                      ],
                    ),
                  ),
                );
              }
          ),
        );
      })
    );
  }
}
