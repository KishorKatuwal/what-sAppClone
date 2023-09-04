import 'package:flutter/material.dart';
import 'package:wa_clone/colors.dart';
import 'package:wa_clone/common/utils/utils.dart';
import 'package:wa_clone/common/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  //Provider ref-> Interact provider with provider
  //widget ref -> makes widget interact with provider
  void sendPhoneNUmber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPHone(context, '+${country!.phoneCode}$phoneNumber');
    }else{
      showSnackBar(context: context, content: "Fill out all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Your Phone number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const Text("Whatsapp will need to verify your phone number"),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  pickCountry();
                },
                child: const Text("Pick Country"),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  if (country != null) Text("+${country!.phoneCode}"),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.6,
              ),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: () {
                    sendPhoneNUmber();
                  },
                  text: "Next",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
