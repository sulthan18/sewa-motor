import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sewa_motor/common/info.dart';
import 'package:sewa_motor/sources/auth_source.dart';
import 'package:sewa_motor/widgets/button_primary.dart';
import 'package:sewa_motor/widgets/button_secondary.dart';
import 'package:sewa_motor/widgets/input.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();

  signIn() {
    if (edtEmail.text == '') return Info.error('Email must be filled.');
    if (edtPassword.text == '') return Info.error('Password must be filled.');

    Info.netral('Loading...');
    AuthSource.signIn(
      edtEmail.text,
      edtPassword.text,
    ).then((message) {
      if (message != 'success') return Info.error(message);

      // success
      Info.success('Success Sign In');
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/discover');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 0,
        ),
        children: [
          const Gap(100),
          Image.asset(
            'assets/logo_text.png',
            height: 38,
            width: 171,
          ),
          const Gap(70),
          const Text(
            'Sign In Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xff070623),
            ),
          ),
          const Gap(30),
          const Text(
            'Email Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
          const Gap(12),
          Input(
              icon: 'assets/ic_email.png',
              hint: 'Write your email',
              editingController: edtEmail),
          const Gap(20),
          const Text(
            'Password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
          const Gap(12),
          Input(
            icon: 'assets/ic_key.png',
            hint: 'Write your password',
            editingController: edtPassword,
            obsecure: true,
          ),
          const Gap(30),
          ButtonPrimary(
            text: 'Sign In',
            onTap: signIn,
          ),
          const Gap(30),
          const DottedLine(
            dashLength: 6,
            dashGapLength: 6,
            dashColor: Color(0xffCECED5),
          ),
          const Gap(30),
          ButtonSecondary(
            text: 'Create New Account',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
