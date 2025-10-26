import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/business/auth_bloc/auth_bloc.dart';
import 'package:hy_guard/presentation/auth/widgets/app_icon.dart';
import 'package:hy_guard/presentation/auth/widgets/email_field.dart';
import 'package:hy_guard/presentation/widgets/app_loading.dart';
import 'package:hy_guard/presentation/widgets/app_messenger.dart';

import '../../core/config/language/l10n/app_localization.dart';
import '../../core/constant/app_routes_names.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final GlobalKey<FormState> _formKay;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKay = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _listenToAuthStateChange,
          child: _buildForgotPasswordContent(),
        ),
      ),
    );
  }

  void _listenToAuthStateChange(context, state) {
    if (state is PasswordResetEmailSentState) {
      _onPasswordResetEmailSent(state);
    } else if (state is AnErrorHappenState) {
      _onAnErrorHappen(state);
    }
  }

  void _onPasswordResetEmailSent(dynamic state) {
    AppLoading().hide(context);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutesNames.signIn, (route) => false);
    AppMessenger().showSuccess(
      context: context,
      message: AppLocalizations.of(
        context,
      )!.the_email_has_been_sent_successfully_to_the_entered_address,
    );
  }

  void _onAnErrorHappen(dynamic state) {
    AppLoading().hide(context);
    AppMessenger().showError(
      context: context,
      message:
          state.errorMessage ?? AppLocalizations.of(context)!.an_error_happen,
    );
  }

  Widget _buildForgotPasswordContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(iconSize: 200.r),
            SizedBox(height: 20.h),
            _buildForgotTitle(),
            SizedBox(height: 20.h),
            _buildForgotPasswordFields(),
            SizedBox(height: 20.h),
            _buildDescriptionText(),
            SizedBox(height: 10.h),
            _buildSendEmailButton(),
            SizedBox(height: 20.h),
            const Divider(),
            SizedBox(height: 20.h),
            _buildHaveAnAccountText(),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotTitle() {
    return Text(
      AppLocalizations.of(context)!.forgot_password,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildForgotPasswordFields() {
    return Form(
      key: _formKay,
      child: EmailField(controller: _emailController),
    );
  }

  Widget _buildDescriptionText() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        AppLocalizations.of(
          context,
        )!.we_will_send_an_email_with_a_reset_link_to_the_entered_address,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSendEmailButton() {
    return FilledButton(
      onPressed: () {
        _onSendEmail();
      },
      child: Text(AppLocalizations.of(context)!.reset_password),
    );
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

  void _onSendEmail() {
    AppLoading().show(context);
    BlocProvider.of<AuthBloc>(context).add(
      RequestPasswordResetEmailEvent(
        recoveryEmail: _emailController.text.trim(),
      ),
    );
  }
}
