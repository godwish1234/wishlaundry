import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/components/my_text_field.dart';
import 'package:wishlaundry/constants/admins.dart';
import 'package:wishlaundry/helpers/helper.dart';
import 'package:wishlaundry/localizations/locale_keys.g.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/routing/app_link_location_keys.dart';
import 'package:wishlaundry/services/services.dart';
import 'package:wishlaundry/ui/components/date_helpers.dart';
import 'package:wishlaundry/ui/components/drawer.dart';
import 'package:wishlaundry/ui/home/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static MaterialPage page() => const MaterialPage(
        name: AppLinkLocationKeys.home,
        key: ValueKey(AppLinkLocationKeys.home),
        child: HomeView(),
      );

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();
  final TextEditingController clothesTextController = TextEditingController();
  final TextEditingController underpantsTextController =
      TextEditingController();
  final TextEditingController brasTextController = TextEditingController();
  final TextEditingController socksTextController = TextEditingController();
  final TextEditingController othersTextController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();
  String? _selectedShelf;
  TextEditingController _packsController = TextEditingController();

  TextEditingController datePickedTextController = TextEditingController();

  String dropdownValue = 'REG';

  // firestore
  final FirestoreServiceImpl firestoreService = FirestoreServiceImpl();
  static final authenticationService =
      GetIt.instance.get<AuthenticationService>();
  final _appStateManager = GetIt.I<AppStateManager>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? attempts;

  bool isSearched = false;

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty ||
        (_searchController.text.length >= 3 &&
            _searchController.text.length <= 6)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _packsController.dispose();
    super.dispose();
  }

  void validateAndSave(String? docId, Map<String, dynamic>? data,
      String? username, int? bypass) async {
    final form = _formKey.currentState;

    if (docId == null) {
      if (form!.validate()) {
        firestoreService.addtransaction(
            nameTextController.text.toUpperCase(),
            dropdownValue,
            DateHelpers.convertStringToDateToTimestamp(dateTextController.text),
            int.parse(clothesTextController.text),
            underpantsTextController.text == ''
                ? 0
                : int.parse(underpantsTextController.text),
            brasTextController.text == ''
                ? 0
                : int.parse(brasTextController.text),
            socksTextController.text == ''
                ? 0
                : int.parse(socksTextController.text),
            othersTextController.text == ''
                ? 0
                : int.parse(othersTextController.text),
            '$username menghitung ${clothesTextController.text} baju/celana${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.form_invalid.tr())));
      }
    } else {
      if (bypass != 0) {
        switch (data?['status']) {
          case 1:
            firestoreService.forceUpdate(
                docId,
                2,
                'dry',
                int.parse(clothesTextController.text),
                underpantsTextController.text == ''
                    ? 0
                    : int.parse(underpantsTextController.text),
                brasTextController.text == ''
                    ? 0
                    : int.parse(brasTextController.text),
                socksTextController.text == ''
                    ? 0
                    : int.parse(socksTextController.text),
                othersTextController.text == ''
                    ? 0
                    : int.parse(othersTextController.text),
                '$username menghitung ${clothesTextController.text} baju/celana${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}',
                bypass ?? 0);
            Navigator.pop(context);
            break;
          case 2:
            Navigator.pop(context);
            await _showPackInfo().then((value) {
              if (value == true) {
                firestoreService.forceUpdate(
                    docId,
                    3,
                    'pack',
                    int.parse(clothesTextController.text),
                    underpantsTextController.text == ''
                        ? 0
                        : int.parse(underpantsTextController.text),
                    brasTextController.text == ''
                        ? 0
                        : int.parse(brasTextController.text),
                    socksTextController.text == ''
                        ? 0
                        : int.parse(socksTextController.text),
                    othersTextController.text == ''
                        ? 0
                        : int.parse(othersTextController.text),
                    '$username menghitung ${clothesTextController.text} baju/celana${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}',
                    bypass ?? 0,
                    packCount: int.parse(_packsController.text),
                    selectedShelf: _selectedShelf);
              }
            });
            break;
        }
      } else {
        if (form!.validate()) {
          switch (data?['status']) {
            case 1:
              firestoreService.updatetransaction(docId, 2, 'dry',
                  '$username menghitung ${clothesTextController.text} baju/celana${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');
              Navigator.pop(context);
              // getClientStream();
              break;
            case 2:
              Navigator.pop(context);
              await _showPackInfo().then((value) {
                if (value == true) {
                  firestoreService.updatetransaction(docId, 3, 'pack',
                      '$username menghitung ${clothesTextController.text} baju/celana${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}',
                      packCount: int.parse(_packsController.text),
                      selectedShelf: _selectedShelf);
                }
              });

              // getClientStream();
              break;
          }
        } else {
          attempts = attempts! - 1;
          if (attempts! == 0) {
            Navigator.pop(context);
            // getClientStream();
          }
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actionsAlignment: MainAxisAlignment.end,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text('Attempt(s) left: ' '${attempts!}/2'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(LocaleKeys.close.tr()))
                    ],
                  ));
          firestoreService.updatetransactionIncorrectInput(docId, attempts!);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.form_invalid.tr())));
        }
      }
    }

    _packsController.clear();
    _selectedShelf = null;
  }

  void openTransactionDialog(
      {String? docId, Map<String, dynamic>? data, String? username}) {
    nameTextController.clear();
    dateTextController.clear();
    clothesTextController.clear();
    underpantsTextController.clear();
    brasTextController.clear();
    socksTextController.clear();
    othersTextController.clear();
    dropdownValue = 'REG';

    attempts = data?['attempt'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, newSetState) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: data?['status'] != 3
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          data == null
                              ? DropdownButton<String>(
                                  value: dropdownValue,
                                  onChanged: (String? newValue) {
                                    newSetState(() {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    });
                                  },
                                  items: <String>['REG', 'EXP', 'S.EXP']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                              : data['type'] != null
                                  ? TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Jenis Layanan'),
                                      controller: TextEditingController()
                                        ..text = data['type'],
                                      readOnly: true,
                                    )
                                  : Container(),
                          data == null
                              ? TextFormField(
                                  decoration: InputDecoration(
                                      labelText: LocaleKeys.name.tr()),
                                  controller: nameTextController,
                                  validator: (value) => value == ''
                                      ? LocaleKeys.form_name_empty.tr()
                                      : null,
                                )
                              : TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Name'),
                                  controller: TextEditingController()
                                    ..text = data['name'],
                                  readOnly: true,
                                ),
                          data == null
                              ? TextFormField(
                                  decoration: InputDecoration(
                                      labelText: LocaleKeys.date.tr()),
                                  controller: dateTextController,
                                  onTap: () async {
                                    await showDatePicker(
                                            context: context,
                                            cancelText: 'cancel',
                                            confirmText: 'ok',
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(
                                                DateTime.now().day - 1),
                                            lastDate: DateTime.now())
                                        .then((selectedDate) {
                                      // After selecting the date, display the time picker.
                                      if (selectedDate != null) {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((selectedTime) {
                                          // Handle the selected date and time here.
                                          if (selectedTime != null) {
                                            DateTime selectedDateTime =
                                                DateTime(
                                              selectedDate.year,
                                              selectedDate.month,
                                              selectedDate.day,
                                              selectedTime.hour,
                                              selectedTime.minute,
                                            );

                                            dateTextController.text =
                                                DateFormat('dd/MM/yyyy HH:mm')
                                                    .format(selectedDateTime);
                                          }
                                        });
                                      }
                                    });
                                  },
                                  validator: (value) => value == ''
                                      ? LocaleKeys.form_date_empty.tr()
                                      : null,
                                )
                              : TextFormField(
                                  decoration: InputDecoration(
                                      labelText: LocaleKeys.date.tr()),
                                  controller: TextEditingController()
                                    ..text = DateHelpers
                                        .convertTimestampToDateToString(
                                            data['date']),
                                  readOnly: true,
                                ),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: LocaleKeys.clothes.tr()),
                              controller: clothesTextController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              validator: data == null
                                  ? (value) => value == ''
                                      ? LocaleKeys.form_clothes_empty.tr()
                                      : null
                                  : (value) {
                                      if (value !=
                                          data['clothesCount'].toString()) {
                                        return LocaleKeys.form_clothes_match
                                            .tr();
                                      }
                                      return null;
                                    }),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: LocaleKeys.underpants.tr()),
                              controller: underpantsTextController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              validator: data == null
                                  ? null
                                  : (value) {
                                      if (value == '') {
                                        value = "0";
                                      }
                                      if (value !=
                                          data['underpantsCount'].toString()) {
                                        return LocaleKeys.form_underpants_match
                                            .tr();
                                      }
                                      return null;
                                    }),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: LocaleKeys.bras.tr()),
                              controller: brasTextController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              validator: data == null
                                  ? null
                                  : (value) {
                                      if (value == '') {
                                        value = "0";
                                      }
                                      if (value !=
                                          data['brasCount'].toString()) {
                                        return LocaleKeys.form_bras_match.tr();
                                      }
                                      return null;
                                    }),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: LocaleKeys.socks.tr()),
                              controller: socksTextController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              validator: data == null
                                  ? null
                                  : (value) {
                                      if (value == '') {
                                        value = "0";
                                      }
                                      if (value !=
                                          data['socksCount'].toString()) {
                                        return LocaleKeys.form_socks_match.tr();
                                      }
                                      return null;
                                    }),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: LocaleKeys.others.tr()),
                              controller: othersTextController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              validator: data == null
                                  ? null
                                  : (value) {
                                      if (value == '') {
                                        value = "0";
                                      }
                                      if (value !=
                                          data['othersCount'].toString()) {
                                        return LocaleKeys.form_others_match
                                            .tr();
                                      }
                                      return null;
                                    })
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.history_header.tr(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent),
                                  onPressed: () {},
                                  child: Text(
                                      "\nHitung awal: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['initial']['timestamp'].toDate())} \n\n${data?['initial']['count']}\n"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          data?['dry'] != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orangeAccent),
                                        onPressed: () {},
                                        child: Text(
                                            "\nKering: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['dry']['timestamp'].toDate())} \n\n${data?['dry']['count']}\n"),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          data?['pack'] != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent),
                                        onPressed: () {},
                                        child: Text(
                                            "\nPacking: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['pack']['timestamp'].toDate())} \n\n${data?['pack']['count']}\n"),
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    docId == null
                        ? Container()
                        : admins.contains(username) && data?['status'] != 3
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              LocaleKeys
                                                                  .history_header
                                                                  .tr(),
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 30,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.blueAccent),
                                                                onPressed:
                                                                    () {},
                                                                child: Text(
                                                                    "\nHitung awal: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['initial']['timestamp'].toDate())} \n\n${data?['initial']['count']}\n"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        data?['dry'] != null
                                                            ? Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor:
                                                                              Colors.orangeAccent),
                                                                      onPressed:
                                                                          () {},
                                                                      child: Text(
                                                                          "\nKering: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['dry']['timestamp'].toDate())} \n\n${data?['dry']['count']}\n"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        data?['pack'] != null
                                                            ? Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor:
                                                                              Colors.redAccent),
                                                                      onPressed:
                                                                          () {},
                                                                      child: Text(
                                                                          "\nPacking: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['pack']['timestamp'].toDate())} \n\n${data?['pack']['count']}\n"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text(LocaleKeys
                                                              .close
                                                              .tr()))
                                                    ],
                                                  ));
                                        },
                                        child: Text(LocaleKeys.history.tr())),
                                  ),
                                ],
                              )
                            : Container(),
                    docId == null
                        ? Container()
                        : const SizedBox(
                            height: 10,
                          ),
                    data?['status'] != 3
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              docId != null && admins.contains(username)
                                  ? Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.redAccent),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Bypass"),
                                                  content: const Text(
                                                      "Perhitungannya kurang atau lebih?"),
                                                  actions: [
                                                    TextButton(
                                                      child:
                                                          const Text("Kurang"),
                                                      onPressed: () {
                                                        validateAndSave(docId,
                                                            data, username, 1);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                          const Text("Lebih"),
                                                      onPressed: () {
                                                        validateAndSave(docId,
                                                            data, username, 2);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(LocaleKeys.bypass.tr())),
                                    )
                                  : Container(),
                              admins.contains(username) &&
                                      data?['status'] != null
                                  ? const SizedBox(
                                      width: 10,
                                    )
                                  : Container(),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: data?['attempt'] == 0
                                        ? null
                                        : () {
                                            validateAndSave(
                                                docId, data, username, 0);
                                          },
                                    child: docId == null
                                        ? Text(LocaleKeys.add.tr())
                                        : docId != '' && data?['attempt'] == 0
                                            ? Text(LocaleKeys.no_attempt.tr())
                                            : Text(Helper().convertStatus(
                                                data?['status'] + 1))),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future _showPackInfo() {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing when clicking outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Segera packing sekarang\ndan isi dibawah'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Nomor Lemari'),
                value: _selectedShelf,
                items: ['A', 'B', 'C', 'D', 'E', 'F', 'LAINNYA']
                    .map((shelf) => DropdownMenuItem(
                          value: shelf,
                          child: Text(shelf),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedShelf = value;
                  });
                },
              ),
              TextField(
                controller: _packsController,
                decoration: const InputDecoration(labelText: 'Jumlah Pack'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_selectedShelf != null &&
                    _packsController.text.isNotEmpty) {
                  Navigator.of(context).pop(true); // Close dialog
                  // Handle input data here
                } else {
                  // Notify the user to fill all fields if they are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silahkan isi semua kolom')),
                  );
                }
              },
              child: const Text('Lanjut'),
            ),
          ],
        );
      },
    );
  }

  Future _showDatePicked() {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing when clicking outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kapan diambil?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: LocaleKeys.date.tr()),
                controller: datePickedTextController,
                onTap: () async {
                  await showDatePicker(
                          context: context,
                          cancelText: 'cancel',
                          confirmText: 'ok',
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().day - 1),
                          lastDate: DateTime.now())
                      .then((selectedDate) {
                    // After selecting the date, display the time picker.
                    if (selectedDate != null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((selectedTime) {
                        // Handle the selected date and time here.
                        if (selectedTime != null) {
                          DateTime selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          datePickedTextController.text =
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(selectedDateTime);
                        }
                      });
                    }
                  });
                },
                validator: (value) =>
                    value == '' ? LocaleKeys.form_date_empty.tr() : null,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (datePickedTextController.text.isNotEmpty) {
                  Navigator.of(context).pop(
                      DateHelpers.convertStringToDateToTimestamp(
                          datePickedTextController.text)); // Close dialog
                  // Handle input data here
                } else {
                  // Notify the user to fill all fields if they are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silahkan isi semua kolom')),
                  );
                }
              },
              child: const Text('Lanjut'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (vm) => vm.initialize(),
        builder: (context, vm, child) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text(LocaleKeys.home_nav.tr()),
                actions: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sembunyikan',
                        style: TextStyle(fontSize: 10),
                      ),
                      Text('Selesai', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        _appStateManager.setShowCompleted(
                            _appStateManager.hideCompleted ? false : true);
                        setState(() {});
                      },
                      icon: _appStateManager.hideCompleted
                          ? const Icon(
                              Icons.check_box,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.white,
                            )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          initialDateRange: DateTimeRange(
                              start: vm.selectedStartDate ?? DateTime.now(),
                              end: vm.selectedEndDate ?? DateTime.now()),
                          lastDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          await vm.updateDate(
                              picked.start,
                              DateTime(picked.end.year, picked.end.month,
                                  picked.end.day, 23, 59));
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              drawer: CustomDrawer(
                username:
                    vm.user?.email?.substring(0, vm.user?.email?.indexOf('@')),
                signOut: () async => authenticationService.signOut(),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'btnHome',
                onPressed: () {
                  openTransactionDialog(
                      username: vm.user?.email
                          ?.substring(0, vm.user?.email?.indexOf('@')));
                },
                child: const Icon(Icons.add),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextField(
                      onChanged: (() {
                        // validateEmail(emailController.text);
                      }),
                      controller: _searchController,
                      hintText: LocaleKeys.search.tr(),
                      obscureText: false,
                      prefixIcon: const Icon(Icons.search_outlined),
                      suffixIcon: IconButton(
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.clear_outlined),
                      ),
                    ),
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: firestoreService.getTransactionStream(
                            Timestamp.fromDate(vm.selectedStartDate!),
                            Timestamp.fromDate(vm.selectedEndDate!),
                            _appStateManager.hideCompleted),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List transactionList = snapshot.data!.docs;

                            if (_searchController.text != "") {
                              transactionList.removeWhere((element) =>
                                  !element['name'].toString().contains(
                                      _searchController.text.toUpperCase()));
                            }

                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: GroupedListView(
                                  cacheExtent: 500,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  elements: transactionList,
                                  groupBy: (element) =>
                                      DateHelpers.convertDateToString(
                                          element['date'].toDate()),
                                  groupComparator: (value1, value2) =>
                                      value1.compareTo(value2),
                                  itemComparator: (item1, item2) =>
                                      DateHelpers.convertDateToString(
                                              item1['date'].toDate())
                                          .compareTo(
                                        DateHelpers.convertDateToString(
                                            item2['date'].toDate()),
                                      ),
                                  sort: false,
                                  order: GroupedListOrder.ASC,
                                  useStickyGroupSeparators: true,
                                  groupSeparatorBuilder: (String value) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  separator: const Divider(),
                                  indexedItemBuilder:
                                      (context, dynamic element, index) {
                                    DocumentSnapshot document =
                                        transactionList[index];
                                    String docID = document.id;

                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;

                                    return Slidable(
                                      key: UniqueKey(),
                                      startActionPane: data['status'] != 3
                                          ? null
                                          : ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      _selectedShelf =
                                                          data['selectedShelf'];
                                                      _packsController.text =
                                                          data['packCount']
                                                              .toString();
                                                      _showPackInfo()
                                                          .then((value) {
                                                        if (value == true) {
                                                          firestoreService.updateShelfInfo(
                                                              docID,
                                                              _selectedShelf ??
                                                                  '',
                                                              int.parse(
                                                                  _packsController
                                                                      .text));
                                                        }
                                                      });
                                                    },
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    foregroundColor:
                                                        Colors.white,
                                                    icon: Icons.edit,
                                                    label:
                                                        'Ganti Lemari/Jumlah Pack',
                                                  ),
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      _showDatePicked()
                                                          .then((value) {
                                                        if (value != null) {
                                                          firestoreService
                                                              .updateDatePicked(
                                                                  docID, value);
                                                        }
                                                      });
                                                    },
                                                    backgroundColor:
                                                        Colors.orangeAccent,
                                                    foregroundColor:
                                                        Colors.white,
                                                    icon: Icons.edit,
                                                    label: 'Diambil',
                                                  ),
                                                ]),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              if (admins.contains(vm.user?.email
                                                  ?.substring(
                                                      0,
                                                      vm.user?.email
                                                          ?.indexOf('@')))) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "${data['name']}"),
                                                      content: const Text(
                                                          "Apakah attempt mau di refresh?"),
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              "Tidak"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child:
                                                              const Text("Ya"),
                                                          onPressed: () {
                                                            // Removes that item the list on swipwe
                                                            setState(() {
                                                              firestoreService
                                                                  .updatetransactionIncorrectInput(
                                                                      docID, 2);
                                                            });

                                                            // Then show a snackbar.
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Attempt telah di refresh')));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Tidak ada akses'),
                                                      content: const Text(
                                                          "Harap Hubungi Admin"),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text("Ok"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            icon: Icons.refresh,
                                            label: 'Refresh',
                                          ),
                                          SlidableAction(
                                            onPressed: (context) {
                                              if (admins.contains(vm.user?.email
                                                  ?.substring(
                                                      0,
                                                      vm.user?.email
                                                          ?.indexOf('@')))) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "${data['name']}"),
                                                      content: const Text(
                                                          "Apakah mau di hapus?"),
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              "Tidak"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child:
                                                              const Text("Ya"),
                                                          onPressed: () {
                                                            // Removes that item the list on swipwe
                                                            setState(() {
                                                              firestoreService
                                                                  .delete(
                                                                      docID);
                                                            });

                                                            // Then show a snackbar.
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Telah di hapus')));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Tidak ada akses'),
                                                      content: const Text(
                                                          "Harap Hubungi Admin"),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text("Ok"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Hapus',
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        color: data['attempt'] == 0
                                            ? Colors.redAccent
                                            : null,
                                        child: ListTile(
                                          minLeadingWidth: 20,
                                          onTap: () {
                                            openTransactionDialog(
                                                docId: docID,
                                                data: data,
                                                username: vm.user?.email
                                                    ?.substring(
                                                        0,
                                                        vm.user?.email
                                                            ?.indexOf('@')));
                                          },
                                          leading: data['type'] != null
                                              ? Container(
                                                  width:
                                                      15, // Set the desired width
                                                  color: data['type'] == 'REG'
                                                      ? Colors.green
                                                      : data['type'] == 'EXP'
                                                          ? Colors.red
                                                          : Colors.black,
                                                  child: Center(
                                                    child: RotatedBox(
                                                      quarterTurns:
                                                          3, // Rotate text 90 degrees counterclockwise
                                                      child: Text(
                                                        data['type'],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                          title: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  color: data['bypass'] == null
                                                      ? Colors.black
                                                      : data['bypass'] == 2
                                                          ? Colors.green
                                                          : Colors.red),
                                              children: [
                                                TextSpan(
                                                  text: data['name'],
                                                ),
                                                data['bypass'] != null
                                                    ? WidgetSpan(
                                                        child:
                                                            Transform.translate(
                                                          offset: const Offset(
                                                              0.0, -7.0),
                                                          child: Text(
                                                            data['bypass'] == 2
                                                                ? '  LEBIH'
                                                                : '  KURANG',
                                                            style: TextStyle(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: data[
                                                                            'bypass'] ==
                                                                        2
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red),
                                                          ),
                                                        ),
                                                      )
                                                    : WidgetSpan(
                                                        child: Container())
                                              ],
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateHelpers
                                                    .convertDateToStringTime(
                                                        data['date'].toDate()),
                                              ),
                                              data['datePicked'] != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Text(
                                                        'Diambil ${DateHelpers.convertDateToString(data['datePicked'].toDate())}',
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .red), // Red color for specific text
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                          trailing: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    data['status'] == 1
                                                        ? Colors.blueAccent
                                                        : data['status'] == 2
                                                            ? Colors
                                                                .orangeAccent
                                                            : Colors.redAccent),
                                            onPressed: () {
                                              openTransactionDialog(
                                                  docId: docID,
                                                  data: data,
                                                  username: vm.user?.email
                                                      ?.substring(
                                                          0,
                                                          vm.user?.email
                                                              ?.indexOf('@')));
                                            },
                                            child: data['status'] != 3
                                                ? Text(Helper().convertStatus(
                                                    data['status']))
                                                : Text(Helper().convertStatus(
                                                        data['status']) +
                                                    ': ${data['packCount']} pack, Lemari ${data['selectedShelf']}'),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return Text(LocaleKeys.no_data.tr());
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ));
        });
  }
}
