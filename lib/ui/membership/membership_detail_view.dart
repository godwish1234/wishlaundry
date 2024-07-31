import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/localizations/locale_keys.g.dart';
import 'package:wishlaundry/routing/app_link_location_keys.dart';
import 'package:wishlaundry/ui/membership/membership_detail_view_model.dart';

class MembershipDetailView extends StatefulWidget {
  const MembershipDetailView({super.key});

  static MaterialPage page() => const MaterialPage(
        name: AppLinkLocationKeys.membershipDetail,
        key: ValueKey(AppLinkLocationKeys.membershipDetail),
        child: MembershipDetailView(),
      );

  @override
  State<MembershipDetailView> createState() => _MembershipDetailViewState();
}

class _MembershipDetailViewState extends State<MembershipDetailView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();

  void openDialog(MembershipDetailViewModel vm, int product) {
    priceController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return product == 1
            ? AlertDialog(
                title: Text(LocaleKeys.top_up.tr()),
                content: Text(LocaleKeys.question_topup.tr()),
                actions: <Widget>[
                  TextButton(
                    // Use TextButton instead of FlatButton
                    child: Text(LocaleKeys.cancel.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    // Use TextButton instead of FlatButton
                    child: Text(LocaleKeys.add.tr()),
                    onPressed: () async {
                      await vm.updateMemberData(
                          vm.data?['balance'],
                          vm.data?['type'] == 1
                              ? (vm.data?['balance'] + 200000)
                              : (vm.data?['balance'] + 500000),
                          vm.data?['type'] == 1 ? 200000 : 500000,
                          product,
                          vm.data?['transactions'],
                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                          vm.data?['type'] == 1
                              ? DateFormat('dd/MM/yyyy HH:mm').format(
                                  DateTime.now().add(const Duration(days: 60)))
                              : DateFormat('dd/MM/yyyy HH:mm').format(
                                  DateTime.now()
                                      .add(const Duration(days: 120))));

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text(LocaleKeys.purchase.tr()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                        key: _formKey,
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: LocaleKeys.price.tr()),
                            controller: priceController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == '') {
                                return LocaleKeys.form_price_empty.tr();
                              }
                              if (int.parse(value!) > vm.data?['balance']) {
                                return 'Saldo tidak cukup';
                              }
                              return null;
                            }))
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    // Use TextButton instead of FlatButton
                    child: Text(LocaleKeys.cancel.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    // Use TextButton instead of FlatButton
                    child: Text(LocaleKeys.add.tr()),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await vm.updateMemberData(
                          vm.data?['balance'],
                          (vm.data?['balance'] -
                              int.parse(priceController.text)),
                          int.parse(priceController.text),
                          product,
                          vm.data?['transactions'],
                          vm.data?['dateCreated'],
                          vm.data?['dateExpiry'],
                        );

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MembershipDetailViewModel>.reactive(
        viewModelBuilder: () => MembershipDetailViewModel(),
        onViewModelReady: (vm) => vm.initialize(),
        builder: (context, vm, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(LocaleKeys.membership_detail.tr()),
                centerTitle: false,
              ),
              body: vm.isBusy
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: vm.refreshData,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: gradientCardSample(vm),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        openDialog(vm, 1);
                                      },
                                      child: Text(LocaleKeys.top_up.tr()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent),
                                      onPressed: DateFormat("dd/MM/yyyy")
                                              .parse(vm.data?['dateExpiry'])
                                              .isAfter(DateTime.now())
                                          ? () {
                                              openDialog(vm, 2);
                                            }
                                          : null,
                                      child: Text(LocaleKeys.purchase.tr()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: ListView.builder(
                                itemCount:
                                    vm.data?['transactions'].toList().length,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Text('${index + 1}.'),
                                    title: Text(vm.data!['transactions']
                                                .toList()[index]['product'] ==
                                            1
                                        ? 'Top up'
                                        : vm.data!['transactions']
                                                        .toList()[index]
                                                    ['product'] ==
                                                3
                                            ? 'Saldo sebelumnya'
                                            : 'Pembelian'),
                                    subtitle: Text(
                                        DateFormat('dd MMM yyyy, kk:mm')
                                            .format(vm.data!['transactions']
                                                .toList()[index]['timestamp']
                                                .toDate())
                                            .toString()),
                                    trailing: Text(
                                      'Rp. ${NumberFormat.decimalPatternDigits(
                                        locale: 'en_us',
                                        decimalDigits: 0,
                                      ).format(vm.data!['transactions'].toList()[index]['price'])}',
                                      style: TextStyle(
                                          color: vm.data!['transactions']
                                                          .toList()[index]
                                                      ['product'] ==
                                                  1
                                              ? Colors.green
                                              : vm.data!['transactions']
                                                              .toList()[index]
                                                          ['product'] ==
                                                      3
                                                  ? Colors.orange
                                                  : Colors.red),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
        });
  }
}

Widget gradientCardSample(MembershipDetailViewModel vm) {
  return Container(
    height: 200,
    width: double.infinity,
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: vm.data?['type'] == 1
            ? [Color(0xffd4d4d4), Color(0xffa6a6a6)]
            : [
                Colors.yellow,
                Colors.orangeAccent,
                Colors.yellow.shade300,
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ), // Adds a gradient background and rounded corners to the container
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    vm.data?['type'] == 1
                        ? 'Silver Membership'
                        : 'Gold Membership',
                    style: TextStyle(
                        color: Colors.black)), // Adds a title to the card
                const Spacer(),
                Stack(
                  children: List.generate(
                    2,
                    (index) => Container(
                      margin: EdgeInsets.only(left: (15 * index).toDouble()),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Colors.white54),
                    ),
                  ),
                ) // Adds a stack of two circular containers to the right of the title
              ],
            ),
            Text(vm.data?['name'],
                style: TextStyle(
                    color: Colors.black)) // Adds a subtitle to the card
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                NumberFormat.decimalPatternDigits(
                  locale: 'en_us',
                  decimalDigits: 0,
                ).format(vm.data?['balance']),
                style: TextStyle(fontSize: 24, color: Colors.black)),
            Text(
              'EXP: ${DateFormat('dd/MM/yyyy').format(DateFormat("dd/MM/yyyy").parse(vm.data?['dateExpiry']))}',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ) // Adds a price to the bottom of the card
      ],
    ),
  );
}
