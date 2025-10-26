import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hy_guard/business/local_storage_bloc/local_storage_bloc.dart';
import 'package:hy_guard/business/recent_files_bloc/recent_files_bloc.dart';
import 'package:hy_guard/business/search_bloc/search_bloc.dart';
import 'package:hy_guard/presentation/auth/sign_in_screen.dart';
import 'package:hy_guard/presentation/auth/signup_screen.dart';
import 'package:hy_guard/presentation/auth/splash_screen.dart';
import 'package:hy_guard/presentation/auth/forgot_password_screen.dart';
import 'package:hy_guard/presentation/home/home_screen.dart';
import 'package:hy_guard/presentation/local_storage/local_storage_screen.dart';
import 'package:hy_guard/presentation/recent_files/recent_files_screen.dart';
import 'package:hy_guard/presentation/search/search_screen.dart';

import '../../business/auth_bloc/auth_bloc.dart';
import '../constant/app_routes_names.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesNames.splash:
        {
          return _goToSplashScreen(settings);
        }
      case AppRoutesNames.signup:
        {
          return _goToSignUpScreen(settings);
        }
      case AppRoutesNames.signIn:
        {
          return _goToSignInScreen(settings);
        }
      case AppRoutesNames.forgotPassword:
        {
          return _goToForgotPasswordScreen(settings);
        }
      case AppRoutesNames.homeScreen:
        {
          return _goToHomeScreen(settings);
        }
      case AppRoutesNames.localStorage:
        {
          return _goToLocalStorageScreen(settings);
        }
      case AppRoutesNames.search:
        {
          return _goToSearchScreen(settings);
        }
      case AppRoutesNames.recentFiles:
        {
          return _goToRecentFilesScreen(settings);
        }
      default:
        {
          /// TODO : create default screen for error routing
          return null;
        }
    }
  }

  Route _goToSplashScreen(RouteSettings settings) {
    Widget builder(BuildContext _) => BlocProvider(
      create: (BuildContext context) => AuthBloc(),
      child: const SplashScreen(),
    );
    return _buildRoute(settings, builder);
  }

  Route _goToSignUpScreen(RouteSettings settings) {
    Widget builder(BuildContext _) => BlocProvider(
      create: (BuildContext context) => AuthBloc(),
      child: const SignupScreen(),
    );
    return _buildRoute(settings, builder);
  }

  Route _goToSignInScreen(RouteSettings settings) {
    Widget builder(BuildContext _) => BlocProvider(
      create: (BuildContext context) => AuthBloc(),
      child: const SignInScreen(),
    );
    return _buildRoute(settings, builder);
  }

  Route _goToForgotPasswordScreen(RouteSettings settings) {
    Widget builder(BuildContext _) => BlocProvider(
      create: (BuildContext context) => AuthBloc(),
      child: const ForgotPasswordScreen(),
    );
    return _buildRoute(settings, builder);
  }

  Route _goToHomeScreen(RouteSettings settings) {
    Widget builder(BuildContext _) => const HomeScreen();
    return _buildRoute(settings, builder);
  }

  Route _goToLocalStorageScreen(RouteSettings settings) {
    Widget builder(BuildContext _) => BlocProvider(
      create: (BuildContext context) => LocalStorageBloc(),
      child: const LocalStorageScreen(),
    );
    return _buildRoute(settings, builder);
  }

  Route _goToSearchScreen(RouteSettings settings) {
    var info = settings.arguments as Map?;
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (BuildContext context) => SearchBloc(),
        child: SearchScreen(filter: info?["type"]),
      ),
      transitionsBuilder: _pageSliderTransitionBuilder,
    );
  }

  Route _goToRecentFilesScreen(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (BuildContext context) => RecentFilesBloc(),
        child: const RecentFilesScreen(),
      ),
      transitionsBuilder: _pageSliderTransitionBuilder,
    );
  }

  Widget _pageSliderTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  }

  MaterialPageRoute _buildRoute(
    RouteSettings settings,
    Widget Function(BuildContext) builder,
  ) {
    return MaterialPageRoute(settings: settings, builder: builder);
  }
}
