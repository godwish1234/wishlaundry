import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/components/my_button.dart';
import 'package:wishlaundry/components/my_text_field.dart';
import 'package:wishlaundry/localizations/locale_keys.g.dart';
import 'package:wishlaundry/routing/app_link_location_keys.dart';
import 'package:wishlaundry/ui/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static MaterialPage page() {
    return const MaterialPage(
      name: AppLinkLocationKeys.login,
      key: ValueKey(AppLinkLocationKeys.login),
      child: LoginView(),
    );
  }

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      // Validasi jika email kosong
      setState(() {
        _errorMessage = "Email tidak boleh kosong";
      });
      // } else if (!EmailValidator.validate(val, true)) {
      //   // Validasi jika email tidak valid
      //   setState(() {
      //     _errorMessage = "Alamat Email tidak valid";
      //   });
      // } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(this),
        onViewModelReady: (vm) => vm.initialize(),
        builder: (context, vm, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.blue,
              body: ListView(
                padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
                shrinkWrap: true,
                reverse: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 535,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("#ffffff"),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.signin.tr(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#4f4f4f"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys.email_address.tr(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: HexColor("#8d8d8d"),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MyTextField(
                                          onChanged: (() {
                                            // validateEmail(emailController.text);
                                          }),
                                          controller: emailController,
                                          hintText: LocaleKeys.input_email.tr(),
                                          obscureText: false,
                                          prefixIcon:
                                              const Icon(Icons.mail_outline),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Text(
                                            _errorMessage,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          LocaleKeys.password.tr(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: HexColor("#8d8d8d"),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MyTextField(
                                          controller: passwordController,
                                          hintText: "**************",
                                          obscureText: true,
                                          prefixIcon:
                                              const Icon(Icons.lock_outline),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MyButton(
                                              onPressed: () {
                                                vm.signIn(emailController.text,
                                                    passwordController.text);
                                              },
                                              // onPressed: signUserIn,
                                              buttonText:
                                                  LocaleKeys.submit.tr(),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
