import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/components/my_text_field.dart';
import 'package:wishlaundry/constants/admins.dart';
import 'package:wishlaundry/localizations/locale_keys.g.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/services/services.dart';
import 'package:wishlaundry/ui/components/drawer.dart';
import 'package:wishlaundry/ui/membership/membership_detail_view.dart';
import 'package:wishlaundry/ui/membership/membership_view_model.dart';

class MembershipView extends StatefulWidget {
  const MembershipView({super.key});

  @override
  State<MembershipView> createState() => _MembershipViewState();
}

class _MembershipViewState extends State<MembershipView> {
  static final authenticationService =
      GetIt.instance.get<AuthenticationService>();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // getClientStream();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    if (_searchController.text == '' ||
        (_searchController.text.length >= 3 &&
            _searchController.text.length <= 6)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void validateAndSave(MembershipViewModel vm, String dropDownValue) {
    final form = _formKey.currentState;
    if (form!.validate()) {
      vm.addMember(
          nameTextController.text.toUpperCase(),
          dropDownValue.toUpperCase() == 'SILVER' ? 200000 : 500000,
          dropDownValue.toUpperCase() == 'SILVER' ? 1 : 2);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(LocaleKeys.form_invalid.tr())));
    }
  }

  void openDialog(MembershipViewModel vm) {
    nameTextController.clear();
    String dropdownValue = 'Silver';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, newSetState) {
          return AlertDialog(
            title: Text(LocaleKeys.add_member.tr()),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: LocaleKeys.name.tr()),
                      controller: nameTextController,
                      validator: (value) =>
                          value == '' ? LocaleKeys.form_name_empty.tr() : null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.member_type.tr()),
                        DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            newSetState(() {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            });
                          },
                          items: <String>['Silver', 'Gold']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            validateAndSave(vm, dropdownValue);
                          },
                          child: Text(LocaleKeys.add.tr())),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MembershipViewModel>.reactive(
        viewModelBuilder: () => MembershipViewModel(),
        onViewModelReady: (vm) => vm.initialize(),
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(LocaleKeys.data_membership.tr()),
              centerTitle: false,
            ),
            drawer: CustomDrawer(
                username:
                    vm.user?.email?.substring(0, vm.user?.email?.indexOf('@')),
                signOut: () async => authenticationService.signOut()),
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
                      stream: (_searchController.text != "")
                          ? vm.membershipService.searchStream(
                              _searchController.text.toUpperCase(),
                            )
                          : vm.membershipService.getTransactionStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List membershipList = snapshot.data!.docs;
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                                itemCount: membershipList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                      membershipList[index];
                                  String docID = document.id;

                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  return Slidable(
                                    key: UniqueKey(),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        // SlidableAction(
                                        //   onPressed: (context) {
                                        //     if (admins.contains(vm.user?.email
                                        //         ?.substring(
                                        //             0,
                                        //             vm.user?.email
                                        //                 ?.indexOf('@')))) {
                                        //       showDialog(
                                        //         context: context,
                                        //         builder: (BuildContext context) {
                                        //           return AlertDialog(
                                        //             title:
                                        //                 Text("${data['name']}"),
                                        //             content: const Text(
                                        //                 "Apakah attempt mau di refresh?"),
                                        //             actions: [
                                        //               TextButton(
                                        //                 child:
                                        //                     const Text("Tidak"),
                                        //                 onPressed: () {
                                        //                   Navigator.pop(context);
                                        //                 },
                                        //               ),
                                        //               TextButton(
                                        //                 child: const Text("Ya"),
                                        //                 onPressed: () {
                                        //                   // Removes that item the list on swipwe
                                        //                   setState(() {
                                        //                     firestoreService
                                        //                         .updatetransactionIncorrectInput(
                                        //                             docID, 2);
                                        //                   });

                                        //                   // Then show a snackbar.
                                        //                   ScaffoldMessenger.of(
                                        //                           context)
                                        //                       .showSnackBar(
                                        //                           const SnackBar(
                                        //                               content: Text(
                                        //                                   'Attempt telah di refresh')));
                                        //                   Navigator.pop(context);
                                        //                 },
                                        //               ),
                                        //             ],
                                        //           );
                                        //         },
                                        //       );
                                        //     } else {
                                        //       showDialog(
                                        //         context: context,
                                        //         builder: (BuildContext context) {
                                        //           return AlertDialog(
                                        //             title: const Text(
                                        //                 'Tidak ada akses'),
                                        //             content: const Text(
                                        //                 "Harap Hubungi Admin"),
                                        //             actions: [
                                        //               TextButton(
                                        //                 child: const Text("Ok"),
                                        //                 onPressed: () {
                                        //                   Navigator.pop(context);
                                        //                 },
                                        //               ),
                                        //             ],
                                        //           );
                                        //         },
                                        //       );
                                        //     }
                                        //   },
                                        //   backgroundColor: Colors.green,
                                        //   foregroundColor: Colors.white,
                                        //   icon: Icons.refresh,
                                        //   label: 'Refresh',
                                        // ),
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
                                                    title:
                                                        Text("${data['name']}"),
                                                    content: const Text(
                                                        "Apakah mau di hapus?"),
                                                    actions: [
                                                      TextButton(
                                                        child:
                                                            const Text("Tidak"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text("Ya"),
                                                        onPressed: () {
                                                          // Removes that item the list on swipwe
                                                          setState(() {
                                                            vm.deleteMember(
                                                                docID);
                                                          });

                                                          // Then show a snackbar.
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Telah di hapus')));
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
                                                        child: const Text("Ok"),
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
                                    child: InkWell(
                                      onTap: () {
                                        vm.onListClicked(docID);
                                      },
                                      child: Container(
                                        child: ListTile(
                                          // onTap: () {
                                          //   opentransactionBox(
                                          //       docId: docID,
                                          //       data: data,
                                          //       username: vm.user?.email?.substring(
                                          //           0,
                                          //           vm.user?.email?.indexOf('@')));
                                          // },
                                          title: Text(data['name']),
                                          subtitle: Text(
                                              '${LocaleKeys.balance.tr()}: Rp. ${NumberFormat.decimalPatternDigits(
                                            locale: 'en_us',
                                            decimalDigits: 0,
                                          ).format(data['balance'])}'),
                                          trailing: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      data['type'] == 1
                                                          ? Colors.grey
                                                          : Colors
                                                              .orangeAccent),
                                              onPressed: () async {
                                                vm.onListClicked(docID);
                                                // await vm.updateMemberData(
                                                //   docID,
                                                //   data['balance'] - 10000,
                                                //   10000,
                                                //   'cuci setrika',
                                                //   data['transaction'] ?? [],
                                                // );
                                              },
                                              child: Text(data['type'] == 1
                                                  ? "SILVER"
                                                  : 'GOLD')),
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
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'btnMembership',
              onPressed: () {
                openDialog(vm);
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
