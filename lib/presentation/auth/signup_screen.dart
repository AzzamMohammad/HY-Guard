import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/business/auth_bloc/auth_bloc.dart';
import '../../core/config/language/l10n/app_localization.dart';
import '../../core/constant/app_routes_names.dart';
import '../../core/constant/assets_names.dart';
import '../widgets/app_loading.dart';
import '../widgets/app_messenger.dart';
import 'widgets/app_icon.dart';
import 'widgets/auth_method_icon.dart';
import 'widgets/email_field.dart';
import 'widgets/password_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _userNameFieldController;
  late final TextEditingController _emailFieldController;
  late final TextEditingController _passwordFieldController;
  late final GlobalKey<FormState> _formKay;

  @override
  void initState() {
    super.initState();
    _userNameFieldController = TextEditingController();
    _emailFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();
    _formKay = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _userNameFieldController.dispose();
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _listenToAuthStateChange,
          child: _buildSignupContent(context),
        ),
      ),
    );
  }

  void _listenToAuthStateChange(BuildContext context, AuthState state) {
    if (state is CreateUserSuccessState) {
      _onCreateUserSuccess(state);
    }
    // an error happened
    if (state is AnErrorHappenState) {
      _onAnErrorHappen(state);
    }
  }

  void _onCreateUserSuccess(dynamic state) {
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

  Widget _buildSignupContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            AppIcon(iconSize: 200.r),
            SizedBox(height: 20.h),
            _buildSignupTitle(),
            SizedBox(height: 20.h),
            _buildSignupFields(),
            SizedBox(height: 15.h),
            _buildSignupButton(),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 10.h),
            _buildORText(),
            SizedBox(height: 10.h),
            _buildSignupMethods(),
            SizedBox(height: 15.h),
            _buildHaveAnAccountText(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupTitle() {
    return Text(
      AppLocalizations.of(context)!.sign_up,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildSignupFields() {
    return Form(
      key: _formKay,
      child: Column(
        children: [
          _buildUserNameField(),
          SizedBox(height: 15.h),
          _buildEmailField(),
          SizedBox(height: 15.h),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildUserNameField() {
    return TextFormField(
      controller: _userNameFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.user_name),
      ),
      validator: _buildUserNameValidator,
    );
  }

  String? _buildUserNameValidator(final String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_your_username;
    }
    return null;
  }

  Widget _buildEmailField() {
    return EmailField(controller: _emailFieldController);
  }

  Widget _buildPasswordField() {
    return PasswordField(controller: _passwordFieldController);
  }

  Widget _buildSignupButton() {
    return FilledButton(
      onPressed: () {
        // validate form
        if (_formKay.currentState!.validate()) {
          _signUpUserWithEmail();
        }
      },
      child: Text(AppLocalizations.of(context)!.sign_up),
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
      onPressed: _signUpWithGoogleAccount,
    );
  }

  Widget _facebookIcon() {
    return AuthMethodIcon(iconPath: AssetsNames.facebookIcon, onPressed: () {});
  }

  Widget _buildHaveAnAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.already_have_an_account),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutesNames.signIn);
          },
          child: Text(AppLocalizations.of(context)!.sign_in),
        ),
      ],
    );
  }

  void _signUpUserWithEmail() {
    BlocProvider.of<AuthBloc>(context).add(
      SignUpWithEmailEvent(
        email: _emailFieldController.text.trim(),
        password: _passwordFieldController.text.trim(),
        userName: _userNameFieldController.text,
      ),
    );
    AppLoading().show(context);
  }

  void _signUpWithGoogleAccount() {
    AppLoading().show(context);
    BlocProvider.of<AuthBloc>(context).add(SignUpWithGoogleEvent());
  }
}
