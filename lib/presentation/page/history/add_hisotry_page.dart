import 'dart:convert';

import 'package:dompetku/config/app_color.dart';
import 'package:dompetku/data/source/source_history.dart';
import 'package:dompetku/presentation/controller/c_user.dart';
import 'package:dompetku/presentation/controller/history/c_add_history.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../config/app_format.dart';

class AddHistoryPage extends StatelessWidget {
  AddHistoryPage({Key? key}) : super(key: key);
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();
  final cAddhistory = Get.put(CAddHistory());
  final cUser = Get.put(CUser());

  addHistory() async {
    bool success = await SourceHistory.add(
        cUser.data.idUser.toString(),
        cAddhistory.type,
        cAddhistory.date,
        cAddhistory.total.toString(),
        jsonEncode(cAddhistory.items)
    );

    if(success) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Tambah Baru'),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Tanggal',
              style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Obx(
                () {
                  return Text(cAddhistory.date);
                }
              ),
              DView.spaceWidth(),
              ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023,01,01),
                        lastDate: DateTime(DateTime.now().year + 1)
                    );
                    if(result!=null) {
                      cAddhistory.setDate(DateFormat('yyyy-MM-dd').format(result));
                    }
                  },
                  icon: const Icon(Icons.event),
                  label: const Text('Pilih'),
              )
            ],
          ),
          DView.spaceHeight(),
          const Text(
              'Tipe',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.spaceHeight(4),
          Obx(
            () {
              return DropdownButtonFormField(
                  value: cAddhistory.type,
                  items: ['Pemasukan', 'Pengeluaran'].map((e) {
                    return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    cAddhistory.setType(value);
                  },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true
                ),
              );
            }
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerName,
            hint: 'Pengeluaran',
            title: 'Sumber/Objek Pengeluaran',
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerPrice,
            hint: '3000',
            title: 'Harga',
            inputType: TextInputType.number,
          ),
          DView.spaceHeight(),
          ElevatedButton(
              onPressed: () {
                cAddhistory.addItem({
                  'name': controllerName.text,
                  'price': controllerPrice.text
                });
                controllerName.clear();
                controllerPrice.clear();
              },
              child: Text('Tambah ke items')
          ),
          DView.spaceHeight(),
          Center(
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                color: AppColor.bg,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          DView.spaceHeight(),
          Text(
            'Items',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.spaceHeight(8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: GetBuilder<CAddHistory>(
              builder: (_) {
                return Wrap(
                  runSpacing: 0,
                  spacing: 8,
                  children: List.generate(_.items.length, (index) {
                    return Chip(
                      label: Text(_.items[index]['name']),
                      deleteIcon: Icon(Icons.clear),
                      onDeleted: () => _.deleteItem(index),
                    );
                  })
                );
              }
            ),
          ),
          DView.spaceHeight(),
          Row(
            children: [
              Text(
                'Total: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DView.spaceWidth(8),
              Obx(
                () {
                  return Text(AppFormat.currency(cAddhistory.total.toString()),
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary
                          ),
                        );
                }
              )
            ],
          ),
          DView.spaceHeight(30),
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => addHistory(),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                      'SUBMIT',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
