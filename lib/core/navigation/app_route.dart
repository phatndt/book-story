import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/features/my%20_book/presentation/book_detail.dart';
import 'package:book_story/features/my%20_book/presentation/edit_book,.dart';
import 'package:book_story/features/my%20_book/presentation/read_book_%20file.dart';
import 'package:book_story/features/my_book_shelf/presentation/add_book_shelf.dart';
import 'package:book_story/features/my_book_shelf/presentation/book_shelf_detail.dart';
import 'package:book_story/features/my_book_shelf/presentation/search_book_shelf.dart';
import 'package:book_story/features/profile/presentation/profile_screen.dart';
import 'package:book_story/main_screen.dart';
import 'package:book_story/features/my%20_book/presentation/add_book.dart';
import 'package:book_story/features/my%20_book/presentation/collection.dart';
import 'package:book_story/features/authentication/presentation/login.dart';
import 'package:book_story/features/authentication/presentation/signup.dart';
import 'package:book_story/features/onboarding/presentation/welcome.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/forgot_password.dart';
import '../../features/onboarding/presentation/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case RoutePaths.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case RoutePaths.logIn:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case RoutePaths.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
      case RoutePaths.forgot:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );
      case RoutePaths.main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
      case RoutePaths.addBook:
        return MaterialPageRoute(
          builder: (_) => const AddBookScreen(),
          settings: settings,
        );
      case RoutePaths.bookDetail:
        return MaterialPageRoute(
          builder: (_) => const BookDetailScreen(),
          settings: settings,
        );
      case RoutePaths.readBookFile :
        return MaterialPageRoute(
          builder: (_) => const ReadBookFile(),
          settings: settings,
        );
      case RoutePaths.editBook :
        return MaterialPageRoute(
          builder: (_) => const EditBookScreen(),
          settings: settings,
        );
      case RoutePaths.addBookShelf :
        return MaterialPageRoute(
          builder: (_) => const AddBookShelfScreen(),
          settings: settings,
        );
      case RoutePaths.searchBookShelf :
        return MaterialPageRoute(
          builder: (_) => const SearchBookShelfScreen(),
          settings: settings,
        );
      case RoutePaths.bookShelfDetail :
        return MaterialPageRoute(
          builder: (_) => const BookShelfDetail(),
          settings: settings,
        );

      case RoutePaths.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      case RoutePaths.home:
        return MaterialPageRoute(
          builder: (_) => const MyBookScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
