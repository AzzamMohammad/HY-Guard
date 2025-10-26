import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/presentation/widgets/app_messenger.dart';
import '../../business/auth_bloc/auth_bloc.dart';
import '../../core/config/language/l10n/app_localization.dart';
import '../../core/constant/app_routes_names.dart';
import '../../core/constant/assets_names.dart';
import '../widgets/app_loading.dart';
import 'widgets/app_icon.dart';
import 'widgets/auth_method_icon.dart';
import 'widgets/email_field.dart';
import 'widgets/password_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailFieldController;
  late final TextEditingController _passwordFieldController;
  late final GlobalKey<FormState> _formKay;

  @override
  void initState() {
    super.initState();
    _emailFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();
    _formKay = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _listenToAuthStateChange,
          child: _buildSignInContent(),
        ),
      ),
    );
  }

  void _listenToAuthStateChange(BuildContext context, AuthState state) {
    if (state is UserLoginSuccessState) {
      _onUserLoginSuccess(state);
    }
    if (state is AnErrorHappenState) {
      _onAnErrorHappen(state);
    }
  }

  void _onUserLoginSuccess(dynamic state) {
    AppLoading().hide(context);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutesNames.homeScreen, (route) => false);
  }

  void _onAnErrorHappen(dynamic state) {
    AppLoading().hide(context);
    AppMessenger().showError(
      context: context,
      message:
          state.errorMessage ?? AppLocalizations.of(context)!.an_error_happen,
    );
  }

  Widget _buildSignInContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            AppIcon(iconSize: 200.r),
            SizedBox(height: 20.h),
            _buildSignInTitle(),
            SizedBox(height: 20.h),
            _buildSignupFields(),
            SizedBox(height: 7.h),
            _forgotPassword(),
            SizedBox(height: 7.h),
            _buildSignupButton(),
            SizedBox(height: 7.h),
            _buildContinueAsAGuest(),
            SizedBox(height: 10.h),
            const Divider(),
            _buildORText(),
            SizedBox(height: 10.h),
            _buildSignupMethods(),
            SizedBox(height: 15.h),
            _buildCreateAnAccountText(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInTitle() {
    return Text(
      AppLocalizations.of(context)!.sign_in,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildSignupFields() {
    return Form(
      key: _formKay,
      child: Column(
        children: [
          _buildEmailField(),
          SizedBox(height: 15.h),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return EmailField(controller: _emailFieldController);
  }

  Widget _buildPasswordField() {
    return PasswordField(controller: _passwordFieldController);
  }

  Widget _forgotPassword() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: _onForgotPassword,
        child: Text(AppLocalizations.of(context)!.forgot_password),
      ),
    );
  }

  Widget _buildSignupButton() {
    return FilledButton(
      onPressed: () {
        if (_formKay.currentState!.validate()) {
          _submitUserInfoToLogin();
        }
      },
      child: Text(AppLocalizations.of(context)!.sign_in),
    );
  }

  Widget _buildORText() {
    return Text(AppLocalizations.of(context)!.or_continue_with);
  }

  Widget _buildSignupMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_googleIcon(), _facebookIcon()],
    );
  }

  Widget _googleIcon() {
    return AuthMethodIcon(
      iconPath: AssetsNames.googleIcon,
      onPressed: _signInWithGoogle,
    );
  }

  Widget _facebookIcon() {
    return AuthMethodIcon(iconPath: AssetsNames.facebookIcon, onPressed: () {});
  }

  Widget _buildCreateAnAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.create_new_account),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutesNames.signup);
          },
          child: Text(AppLocalizations.of(context)!.sign_up),
        ),
      ],
    );
  }

  Widget _buildContinueAsAGuest() {
    return OutlinedButton(
      onPressed: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutesNames.homeScreen, (route) => false);
      },
      child: Text(AppLocalizations.of(context)!.continue_as_guest),
    );
  }

  void _submitUserInfoToLogin() {
    BlocProvider.of<AuthBloc>(context).add(
      LoginWithEmailEvent(
        email: _emailFieldController.text.trim(),
        password: _passwordFieldController.text.trim(),
      ),
    );
    AppLoading().show(context);
  }

  void _signInWithGoogle() {
    AppLoading().show(context);
    BlocProvider.of<AuthBloc>(context).add(SignInWithGoogleEvent());
  }

  void _onForgotPassword() {
    Navigator.of(context).pushNamed(AppRoutesNames.forgotPassword);
  }
}
