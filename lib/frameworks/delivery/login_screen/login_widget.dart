import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../common/error_codes/error_codes.dart';
import '../../../../generated/l10n.dart';
import '../../../../modules/sms_login/sms_login.dart';
import '../../../../widgets/common/edit_product_info_widget.dart';
import '../../../common/config.dart';
import '../config/app_config.dart';
import '../models/authentication_model.dart';

class LoginWidget extends StatefulWidget {
  final Function callBack;
  final Function({ErrorType? type, String? errMessage}) onMessage;
  const LoginWidget({Key? key, required this.callBack, required this.onMessage})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _isObscure = true;

  List<Widget> _buildLoginButtons(model, Function({ErrorType? type, String? errMessage}) showMessage) {
    return [
      if (kLoginSetting.showAppleLogin && isIos) ...[
        InkWell(
          onTap: () => model.appleLogin(showMessage),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.black87,
            ),
            child: Image.asset(
              'assets/icons/logins/apple.png',
              width: 26,
              height: 26,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
      if (kLoginSetting.showGoogleLogin) ...[
        InkWell(
          onTap: () => model.googleLogin(showMessage),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.grey.shade300,
            ),
            child: Image.asset(
              'assets/icons/logins/google.png',
              width: 28,
              height: 28,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
      if (kLoginSetting.showFacebook) ...[
        InkWell(
          onTap: () => model.facebookLogin(showMessage),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFF4267B2),
            ),
            child: const Icon(
              Icons.facebook_rounded,
              color: Colors.white,
              size: 34.0,
            ),
          ),
        ),
      ],
      const SizedBox(width: 10),
      if (kLoginSetting.showSMSLogin) ...[
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SMSLoginScreen(
                      onSuccess: (user) async {
                        await model.logSMSUser(user, widget.onMessage);
                        Navigator.of(context).pop();
                      },
                    )));
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.lightBlue.shade50,
            ),
            child: Image.asset(
              'assets/icons/logins/sms.png',
              width: 28,
              height: 28,
            ),
          ),
        ),
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model =
        Provider.of<DeliveryAuthenticationModel>(context, listen: false);
    return Container(
      width: size.width,
      height: size.height,
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image.asset(
              kAppLogo,
              fit: BoxFit.fill,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 10),
            Text(
              kAppName,
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            EditProductInfoWidget(
              key: const Key('vendorAdminLoginUsername'),
              label: S.of(context).username,
              fontSize: 12.0,
              controller: model.usernameController,
            ),
            const SizedBox(height: 25),
            EditProductInfoWidget(
              key: const Key('vendorAdminLoginPassword'),
              label: S.of(context).password,
              fontSize: 12.0,
              controller: model.passwordController,
              isObscure: _isObscure,
              suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }),
            ),
            const SizedBox(height: 50.0),
            InkWell(
              onTap: () => model.login(widget.onMessage),
              key: const Key('vendorAdminLoginButton'),
              child: Container(
                height: 44,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blueAccent,
                ),
                child: model.state == DeliveryAuthenticationModelState.loading
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          S.of(context).login.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(S.of(context).orLoginWith),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildLoginButtons(model, widget.onMessage),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => widget.callBack(),
              child: Text(
                S.of(context).createAnAccount,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
