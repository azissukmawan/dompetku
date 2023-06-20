import 'dart:convert';

import 'package:dompetku/config/app_format.dart';
import 'package:dompetku/presentation/controller/history/c_detail_history.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_color.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage({Key? key, required this.idUser, required this.date, required this.type}) : super(key: key);
  final String idUser;
  final String type;
  final String date;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final cDetailHistory = Get.put(CDetailHistory());

  @override
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.type, widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
            if(cDetailHistory.data.date == null) return DView.nothing();
            return Row(
              children: [
                Expanded(
                    child: Text(
                      AppFormat.date(cDetailHistory.data.date!),
                    )
                ),
                cDetailHistory.data.type == 'Pemasukan' ?
                    Icon(Icons.south_west, color: Colors.green[300],)
                    :Icon(Icons.north_east, color: Colors.red[300],),
                DView.spaceWidth(),
              ],
            );
          }
        ),
      ),
      body: GetBuilder<CDetailHistory>(
        builder: (_) {
          if (_.loading) return DView.loadingCircle();
          if (_.data.date == null) return DView.empty('Tidak Ada Data History');
          List details = jsonDecode(_.data.details!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                    'Total',
                  style: TextStyle(
                    color: AppColor.primary.withOpacity(0.6),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Text(
                  AppFormat.currency(_.data.total!),
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: AppColor.primary,
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColor.bg
                  ),
                ),
              ),
              DView.spaceHeight(20),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      Map item = details[index];
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            DView.spaceWidth(),
                            Text('${index + 1}. ', style: const TextStyle(fontSize: 20),),
                            DView.spaceWidth(8),
                            Expanded(
                                child: Text(
                                    item['name'],
                                  style: const TextStyle(fontSize: 16),
                                )
                            ),
                            Text(
                              AppFormat.currency(item['price']),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      thickness: 0.5,
                    ),
                    itemCount: details.length,
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
