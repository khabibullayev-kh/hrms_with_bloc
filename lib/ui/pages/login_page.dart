import 'package:flutter/material.dart';
import 'package:hrms/blocs/auth_bloc/auth_bloc.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:provider/provider.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _keyboardVisible =
        context.select((AuthViewModel m) => m.keyboardVisible);
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;

    _loginWidth = windowWidth;
    _loginOpacity = 1;

    _loginYOffset = _keyboardVisible ? 40 : 270;
    _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

    _loginXOffset = 0;
    return Scaffold(
      body: Stack(
        children: [
          const LogoWidget(),
          LoginFieldsBody(
            loginWidth: _loginWidth,
            loginHeight: _loginHeight,
            loginXOffset: _loginXOffset,
            loginYOffset: _loginYOffset,
            loginOpacity: _loginOpacity,
          ),
        ],
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(right: 64, left: 64, top: 120),
        child: Image.asset(
          HRMSIcons.hrmsLogo,
          width: double.infinity,
          height: 80,
        ),
      ),
    );
  }
}

class LoginFieldsBody extends StatefulWidget {
  const LoginFieldsBody({
    Key? key,
    required double loginWidth,
    required double loginHeight,
    required double loginXOffset,
    required double loginYOffset,
    required double loginOpacity,
  })  : _loginWidth = loginWidth,
        _loginHeight = loginHeight,
        _loginXOffset = loginXOffset,
        _loginYOffset = loginYOffset,
        _loginOpacity = loginOpacity,
        super(key: key);

  final double _loginWidth;
  final double _loginHeight;
  final double _loginXOffset;
  final double _loginYOffset;
  final double _loginOpacity;

  @override
  State<LoginFieldsBody> createState() => _LoginFieldsBodyState();
}

class _LoginFieldsBodyState extends State<LoginFieldsBody> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthViewModel>();
    final fn1 = model.loginFocusNode;
    final fn2 = model.passwordFocusNode;
    final usernameController = model.loginTextController;
    final passwordController = model.passwordTextController;
    final obscureText = model.obscureText;
    //final showPassword = model.showPassword();
    return AnimatedContainer(
      padding: const EdgeInsets.all(32),
      width: widget._loginWidth,
      height: widget._loginHeight,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(
        widget._loginXOffset,
        widget._loginYOffset,
        1,
      ),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(widget._loginOpacity),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  "Авторизоваться",
                  style: HRMSStyles.loginText,
                ),
              ),
              LoginFieldWidget(
                controller: usernameController,
                obscureText: false,
                fn: fn1,
                icon: Icons.email,
                hint: "Логин",
              ),
              const SizedBox(height: 20),
              LoginFieldWidget(
                controller: passwordController,
                obscureText: obscureText,
                fn: fn2,
                icon: Icons.vpn_key,
                hint: "Пароль",
                iconButton: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: HRMSColors.green,
                  ),
                  onPressed: () => model.showPassword(),
                ),
              ),
              const SizedBox(height: 16),
              const _ErrorMessageWidget(),
            ],
          ),
          Column(
            children: const <Widget>[
              LoginButtonWidget(),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final FocusNode fn;
  final bool obscureText;
  final IconButton? iconButton;

  const LoginFieldWidget({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hint,
    required this.fn,
    required this.obscureText,
    this.iconButton,
  }) : super(key: key);

  @override
  _LoginFieldWidgetState createState() => _LoginFieldWidgetState();
}

class _LoginFieldWidgetState extends State<LoginFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: HRMSColors.green, width: 1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 60,
            child: Icon(widget.icon, size: 20, color: HRMSColors.green),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.fn,
              cursorColor: HRMSColors.green,
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: InputBorder.none,
                hintText: widget.hint,
                suffixIcon: widget.iconButton,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthViewModel>();
    final onPressed = model.canStartAuth ? () => model.auth(context) : null;
    final child = model.isAuthProgress
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          )
        : const Text(
            'Войти',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          );
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: HRMSColors.green, borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewModel m) => m.errorMessage);
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.red,
        ),
      ),
    );
  }
}
