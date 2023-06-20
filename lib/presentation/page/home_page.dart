import 'package:dompetku/config/app_asset.dart';
import 'package:dompetku/config/app_color.dart';
import 'package:dompetku/config/app_format.dart';
import 'package:dompetku/config/session.dart';
import 'package:dompetku/presentation/controller/c_home.dart';
import 'package:dompetku/presentation/controller/c_user.dart';
import 'package:dompetku/presentation/page/history/detail_history_page.dart';
import 'package:dompetku/presentation/page/auth/login_page.dart';
import 'package:dompetku/presentation/page/history/add_hisotry_page.dart';
import 'package:dompetku/presentation/page/history/income_outcome_page.dart';
import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'history/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    // TODO: implement initState
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Row(
              children: [
                Image.asset(AppAsset.profile),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          'HAI,',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Obx(() {
                          return Text(
                              cUser.data.name ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          );
                        }
                      )
                    ],
                  ),
                ),
                Builder(
                  builder: (ctx) {
                    return Material(
                      color: AppColor.bg,
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(ctx).openEndDrawer();
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                              Icons.menu,
                              color: AppColor.primary,
                          ),
                        ),
                      ),
                    );
                  }
                )
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  cHome.getAnalysis(cUser.data.idUser!);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  children: [
                    Text(
                      'Pengeluaran hari ini',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DView.spaceHeight(),
                    chartToday(context),
                    DView.spaceHeight(30),
                    Center(
                      child: Container(
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColor.bg,
                        ),
                      ),
                    ),
                    DView.spaceHeight(30),
                    Text(
                      'Pengeluaran minggu ini',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DView.spaceHeight(),
                    weekly(),
                    DView.spaceHeight(30),
                    Text(
                      'Perbandingan bulan ini',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DView.spaceHeight(),
                    monthly(context),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.fromLTRB(30, 16, 16, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(AppAsset.profile),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                cUser.data.name ?? '',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              );
                            }
                            ),
                            Obx(() {
                              return Text(
                                cUser.data.email ?? '',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300
                                ),
                              );
                            }
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        Session.deleteUser();
                        Get.off(() => const LoginPage());
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 24,
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
          ListTile(
            onTap: () {
              Get.to(() => AddHistoryPage())?.then((value) {
                if(value??false) {
                  cHome.getAnalysis(cUser.data.idUser!);
                }
              });
            },
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            title: const Text('Tambah baru'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1,),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(type: 'Pemasukan'));
            },
            leading: const Icon(Icons.south_west),
            horizontalTitleGap: 0,
            title: const Text('Pemasukan'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1,),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(type: 'Pengeluaran'));
            },
            leading: const Icon(Icons.north_east),
            horizontalTitleGap: 0,
            title: const Text('Pengeluaran'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1,),
          ListTile(
            onTap: () {
              Get.to(() => const HistoryPage());
            },
            leading: const Icon(Icons.history),
            horizontalTitleGap: 0,
            title: const Text('Riwayat'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1,),
        ],
      ),
    );
  }

  Row monthly(BuildContext context) {
    return Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: Stack(
                        children: [
                          Obx(
                            () {
                              return DChartPie(
                                data: [
                                  {'domain': 'income', 'measure': cHome.monthIncome},
                                  {'domain': 'outcome', 'measure': cHome.monthOutcome},
                                  if(cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                                    {'domain': 'nol', 'measure': 1},
                                ],
                                fillColor: (pieData, index) {
                                  switch (pieData['domain']) {
                                    case 'income':
                                      return AppColor.primary;
                                    case 'outcome':
                                      return AppColor.chart;
                                    default:
                                      return AppColor.bg.withOpacity(0.5);
                                  }
                                },
                                donutWidth: 15,
                                labelColor: Colors.transparent,
                                showLabelLine: false,
                              );
                            }
                          ),
                          Center(
                              child: Obx(
                                () {
                                  return Text(
                                      '${cHome.percentIncome}%',
                                    style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                      color: AppColor.primary,
                                    )
                                  );
                                }
                              )
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 16,
                                width: 16,
                                color: AppColor.primary,
                              ),
                              DView.spaceWidth(8),
                              const Text('Pemasukan'),
                            ],
                          ),
                          DView.spaceHeight(8),
                          Row(
                            children: [
                              Container(
                                height: 16,
                                width: 16,
                                color: AppColor.chart,
                              ),
                              DView.spaceWidth(8),
                              const Text('Pengeluaran'),
                            ],
                          ),
                          DView.spaceHeight(20),
                          Obx(
                            () {
                              return Text(cHome.monthPercent);
                            }
                          ),
                          DView.spaceHeight(10),
                          const Text('Atau setara :'),
                          Obx(
                            () {
                              return Text(
                                AppFormat.currency(cHome.differentMonth.toString()),
                                style: const TextStyle(
                                  color: AppColor.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          )
                        ],
                      ),
                    ),
                  ],
                );

  }

  AspectRatio weekly() {
    return AspectRatio(
                  aspectRatio: 16/9,
                  child: Obx(
                    () {
                      return DChartBar(
                        data: [
                          {
                            'id': 'Bar',
                            'data': List.generate(7, (index) {
                              return {'domain': cHome.weekText()[index], 'measure': cHome.week[index]};
                            }),
                          },
                        ],
                        domainLabelPaddingToAxisLine: 8,
                        axisLineTick: 2,
                        axisLineColor: AppColor.primary,
                        measureLabelPaddingToAxisLine: 16,
                        barColor: (barData, index, id) => AppColor.primary,
                        showBarValue: true,
                      );
                    }
                  ),
                );
  }

  Material chartToday(BuildContext context) {
    return Material(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.primary,
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 4),
                        child: Obx(
                          () {
                            return Text(AppFormat.currency(cHome.today.toString()),
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColor.secondary
                              ),
                            );
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                        child: Obx(
                          () {
                            return Text(cHome.todayPercent,
                              style: const TextStyle(color: AppColor.secondary, fontSize: 16),
                            );
                          }
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => DetailHistoryPage(
                              idUser: cUser.data.idUser!,
                              type: 'Pengeluaran',
                              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text('Selengkapnya'),
                              Icon(Icons.navigate_next)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
  }
}
