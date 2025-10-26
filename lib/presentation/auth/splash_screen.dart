import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/business/auth_bloc/auth_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/config/language/l10n/app_localization.dart';
import '../../core/constant/app_routes_names.dart';
import '../widgets/app_messenger.dart';
import 'widgets/app_icon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // check the user authentication state
    BlocProvider.of<AuthBloc>(context).add(AppStartedEvent());
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _listenToAuthStateChange,
          child: _buildSplashContent(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildSignature(context),
    );
  }

  void _listenToAuthStateChange(context, state) {
    if (state is AuthenticatedState) {
      _onAuthenticated(context);
    }
    if (state is UnauthenticatedState) {
      _onUnauthenticated(context);
    }
    if (state is AnErrorHappenState) {
      _onAnErrorHappen(state, context);
    }
  }

  void _onAuthenticated(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutesNames.homeScreen, (route) => false);
  }

  void _onUnauthenticated(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutesNames.signIn, (route) => false);
  }

  void _onAnErrorHappen(dynamic state, BuildContext context) {
    AppMessenger().showError(
      context: context,
      message:
          state.errorMessage ?? AppLocalizations.of(context)!.an_error_happen,
    );
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutesNames.signIn, (route)=>false);
  }

  Widget _buildSplashContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(iconSize: 200.r),
          SizedBox(height: 30.r),
          _buildLoadingIndicator(context),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Theme.of(context).primaryColor,
      size: 50.r,
    );
  }

  Widget _buildSignature(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      "DEV  BY  ENG.AZZAM MOHAMMAD",
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }
}
