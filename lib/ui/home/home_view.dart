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

  @override
  void initState() {
    getClientStream();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);

    searchResultList();
  }

  searchResultList() {
    var showResult = [];
    if (_searchController.text != '') {
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

  getClientStream() async {
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
      String? username, bool? forced) {
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
            '$username menghitung ${clothesTextController.text} baju/celana ${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');

        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: LocaleKeys.form_invalid.tr(),
            webPosition: "center",
            toastLength: Toast.LENGTH_LONG);
      }
    } else {
      if (forced == true) {
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
                '$username menghitung ${clothesTextController.text} baju/celana ${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');
            Navigator.pop(context);
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
                '$username menghitung ${clothesTextController.text} baju/celana ${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');
            Navigator.pop(context);
            break;
        }
      } else {
        if (form!.validate()) {
          switch (data?['status']) {
            case 1:
              firestoreService.updateNote(docId, 2, 'dry',
                  '$username menghitung ${clothesTextController.text} baju/celana ${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');
              Navigator.pop(context);
              break;
            case 2:
              firestoreService.updateNote(docId, 3, 'pack',
                  '$username menghitung ${clothesTextController.text} baju/celana ${underpantsTextController.text != '' ? ',${underpantsTextController.text} CD' : ''} ${brasTextController.text != '' ? ', ${brasTextController.text} BH' : ''} ${socksTextController.text != '' ? ', ${socksTextController.text} KK' : ''} ${othersTextController.text != '' ? ', ${othersTextController.text} lainnya' : ''}');
              Navigator.pop(context);
              break;
          }
        } else {
          attempts = attempts! - 1;
          if (attempts! == 0) {
            Navigator.pop(context);
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
        content: Form(
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
                                  cancelText: 'cancel',
                                  confirmText: 'ok',
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().day - 1),
                                  lastDate: DateTime.now());

                              if (picked != null) {
                                dateTextController.text =
                                    DateFormat('dd/MM/yyyy').format(picked);
                              }
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
                        decoration:
                            InputDecoration(labelText: LocaleKeys.clothes.tr()),
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
                                if (value != data['clothesCount'].toString()) {
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
                                if (value !=
                                        data['underpantsCount'].toString() &&
                                    data['underpantsCount'] != 0) {
                                  return LocaleKeys.form_underpants_match.tr();
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
                                if (value != data['socksCount'].toString() &&
                                    data['socksCount'] != 0) {
                                  return LocaleKeys.form_socks_match.tr();
                                }
                                return null;
                              }),
                    TextFormField(
                        decoration:
                            InputDecoration(labelText: LocaleKeys.others.tr()),
                        controller: othersTextController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        validator: data == null
                            ? null
                            : (value) {
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
                                        validateAndSave(
                                            docId, data, username, true);
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
                                            docId, data, username, false);
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestoreService.getNotesStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          getClientStream();

                          //display as a list
                          return GroupedListView(
                              elements: _resultList,
                              groupBy: (element) => element['date'],
                              groupComparator: (value1, value2) =>
                                  value2.compareTo(value1),
                              itemComparator: (item1, item2) =>
                                  item1['date'].compareTo(item2['date']),
                              order: GroupedListOrder.ASC,
                              useStickyGroupSeparators: true,
                              groupSeparatorBuilder: (String value) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              indexedItemBuilder:
                                  (context, dynamic element, index) {
                                DocumentSnapshot document = _resultList[index];
                                String docID = document.id;

                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;

                                return Container(
                                  color: element['attempt'] == 0
                                      ? Colors.redAccent
                                      : null,
                                  child: ListTile(
                                    onTap: () {
                                      openNoteBox(
                                          docId: docID,
                                          data: data,
                                          username: vm.user?.email?.substring(
                                              0, vm.user?.email?.indexOf('@')));
                                    },
                                    title: Text(element['name']),
                                    subtitle: Text(element['date']),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              element['status'] == 1
                                                  ? Colors.blueAccent
                                                  : element['status'] == 2
                                                      ? Colors.orangeAccent
                                                      : Colors.redAccent),
                                      onPressed: () {
                                        openNoteBox(
                                            docId: docID,
                                            data: data,
                                            username: vm.user?.email?.substring(
                                                0,
                                                vm.user?.email?.indexOf('@')));
                                      },
                                      child: Text(Helper()
                                          .convertStatus(element['status'])),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Text(LocaleKeys.no_data.tr());
                        }
                      },
                    ),
                  ),
                ],
              ));
        });
  }
}
