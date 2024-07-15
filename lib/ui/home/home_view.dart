import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/components/my_text_field.dart';
import 'package:wishlaundry/constants/admins.dart';
import 'package:wishlaundry/helpers/helper.dart';
import 'package:wishlaundry/localizations/locale_keys.g.dart';
import 'package:wishlaundry/routing/app_link_location_keys.dart';
import 'package:wishlaundry/services/services.dart';
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

  // firestore
  final FirestoreServiceImpl firestoreService = FirestoreServiceImpl();

  final _formKey = GlobalKey<FormState>();

  int? attempts;

  List _allResults = [];
  List _resultList = [];
  var showResult = [];

  bool isSearched = false;

  @override
  void initState() {
    getClientStream();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResult = [];
    isSearched = true;
    if (_searchController.text != '' && _searchController.text.length >= 3) {
      for (var clientSnapShot in _allResults) {
        var name = clientSnapShot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResult.add(clientSnapShot);
        }
      }
    } else {
      showResult = List.from(_allResults);
    }

    setState(() {
      _resultList = showResult;
    });
  }

  Future<void> getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('transaction')
        .orderBy('date', descending: true)
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  void validateAndSave(String? docId, Map<String, dynamic>? data,
      String? username, int? bypass) {
    final form = _formKey.currentState;

    if (docId == null) {
      if (form!.validate()) {
        firestoreService.addNote(
            nameTextController.text.toUpperCase(),
            dateTextController.text,
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
        getClientStream();
      } else {
        Fluttertoast.showToast(
            msg: LocaleKeys.form_invalid.tr(),
            webPosition: "center",
            toastLength: Toast.LENGTH_LONG);
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
            getClientStream();
            break;
          case 2:
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
                bypass ?? 0);
            Navigator.pop(context);
            getClientStream();
            break;
        }
      } else {
        if (form!.validate()) {
          switch (data?['status']) {
            case 1:
              firestoreService.updateNote(docId, 2, 'dry',
                  '$username menghitung ${clothesTextController.text} baju/celana${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');
              Navigator.pop(context);
              getClientStream();
              break;
            case 2:
              firestoreService.updateNote(docId, 3, 'pack',
                  '$username menghitung ${clothesTextController.text} baju/celana${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');
              Navigator.pop(context);
              getClientStream();
              break;
          }
        } else {
          attempts = attempts! - 1;
          if (attempts! == 0) {
            Navigator.pop(context);
            getClientStream();
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
          firestoreService.updateNoteIncorrectInput(docId, attempts!);

          Fluttertoast.showToast(
              msg: LocaleKeys.form_invalid.tr(),
              webPosition: "center",
              toastLength: Toast.LENGTH_LONG);
        }
      }
    }
  }

  void openNoteBox(
      {String? docId, Map<String, dynamic>? data, String? username}) {
    nameTextController.clear();
    dateTextController.clear();
    clothesTextController.clear();
    underpantsTextController.clear();
    brasTextController.clear();
    socksTextController.clear();
    othersTextController.clear();

    attempts = data?['attempt'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: data?['status'] != 3
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                                final DateTime? picked = await showDatePicker(
                                        context: context,
                                        cancelText: 'cancel',
                                        confirmText: 'ok',
                                        initialDate: DateTime.now(),
                                        firstDate:
                                            DateTime(DateTime.now().day - 1),
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
                                ..text = data['date'],
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
                                    return LocaleKeys.form_clothes_match.tr();
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
                          decoration:
                              InputDecoration(labelText: LocaleKeys.bras.tr()),
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
                                  if (value != data['brasCount'].toString() &&
                                      data['brasCount'] != 0) {
                                    return LocaleKeys.form_bras_match.tr();
                                  }
                                  return null;
                                }),
                      TextFormField(
                          decoration:
                              InputDecoration(labelText: LocaleKeys.socks.tr()),
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
                                  if (value != data['socksCount'].toString() &&
                                      data['socksCount'] != 0) {
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
                                  if (value != data['othersCount'].toString() &&
                                      data['othersCount'] != 0) {
                                    return LocaleKeys.form_others_match.tr();
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
                                        backgroundColor: Colors.orangeAccent),
                                    onPressed: () {},
                                    child: Text(
                                        "\nDry: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['dry']['timestamp'].toDate())} \n\n${data?['dry']['count']}\n"),
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
                                                      CrossAxisAlignment.start,
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
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blueAccent),
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
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .orangeAccent),
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                      "\nDry: ${DateFormat('dd/MM/yyyy – kk:mm').format(data?['dry']['timestamp'].toDate())} \n\n${data?['dry']['count']}\n"),
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
                                                                          Colors
                                                                              .redAccent),
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
                        height: 15,
                      ),
                data?['status'] != 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          docId != null && admins.contains(username)
                              ? Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Bypass"),
                                              content: const Text(
                                                  "Perhitungannya kurang atau lebih?"),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Kurang"),
                                                  onPressed: () {
                                                    validateAndSave(docId, data,
                                                        username, 1);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text("Lebih"),
                                                  onPressed: () {
                                                    validateAndSave(docId, data,
                                                        username, 2);
                                                    Navigator.pop(context);
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
                          const SizedBox(
                            width: 10,
                          ),
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
          // data?['status'] == 3
          //     ? TextButton(
          //         onPressed: () => Navigator.pop(context),
          //         child: Text(LocaleKeys.close.tr()))
          //     : Container()
        ],
      ),
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
              ),
              drawer: Drawer(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                            '${LocaleKeys.welcome.tr()} ${vm.user?.email?.substring(0, vm.user?.email?.indexOf('@'))}'),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Text(LocaleKeys.signout.tr()),
                                onPressed: () async {
                                  vm.signOut();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  openNoteBox(
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
                    ),
                  ),
                  Expanded(
                      //display as a list
                      child: RefreshIndicator(
                    onRefresh: getClientStream,
                    child: GroupedListView(
                        elements: _resultList,
                        groupBy: (element) => DateFormat('dd/MM/yyyy').format(
                            DateFormat("dd/MM/yyyy").parse(element['date'])),
                        groupComparator: (value1, value2) =>
                            value2.compareTo(value1),
                        itemComparator: (item1, item2) =>
                            DateFormat('dd/MM/yyyy')
                                .parse(item1['date'])
                                .toString()
                                .compareTo(
                                  DateFormat('dd/MM/yyyy')
                                      .parse(item2['date'])
                                      .toString(),
                                ),
                        order: GroupedListOrder.ASC,
                        useStickyGroupSeparators: true,
                        groupSeparatorBuilder: (String value) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                        separator: const Divider(),
                        indexedItemBuilder: (context, dynamic element, index) {
                          DocumentSnapshot document = _resultList[index];
                          String docID = document.id;

                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          return Container(
                            color:
                                data['attempt'] == 0 ? Colors.redAccent : null,
                            child: ListTile(
                              onTap: () {
                                openNoteBox(
                                    docId: docID,
                                    data: data,
                                    username: vm.user?.email?.substring(
                                        0, vm.user?.email?.indexOf('@')));
                              },
                              title: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: data['bypass'] == null
                                          ? Colors.black
                                          : Colors.red),
                                  children: [
                                    TextSpan(
                                      text: data['name'],
                                    ),
                                    data['bypass'] != null
                                        ? WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(0.0, -7.0),
                                              child: Text(
                                                data['bypass'] == 2
                                                    ? '  LEBIH'
                                                    : '  KURANG',
                                                style: const TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          )
                                        : WidgetSpan(child: Container())
                                  ],
                                ),
                              ),
                              subtitle: Text(DateFormat('HH:mm').format(
                                  DateFormat("dd/MM/yyyy HH:mm")
                                      .parse(data['date']))),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: data['status'] == 1
                                        ? Colors.blueAccent
                                        : data['status'] == 2
                                            ? Colors.orangeAccent
                                            : Colors.redAccent),
                                onPressed: () {
                                  openNoteBox(
                                      docId: docID,
                                      data: data,
                                      username: vm.user?.email?.substring(
                                          0, vm.user?.email?.indexOf('@')));
                                },
                                child: Text(
                                    Helper().convertStatus(data['status'])),
                              ),
                            ),
                          );
                        }),
                  )),
                ],
              ));
        });
  }
}
