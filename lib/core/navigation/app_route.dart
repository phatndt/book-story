import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/features/my%20_book/presentation/book_detail.dart';
import 'package:book_story/features/my%20_book/presentation/edit_book,.dart';
import 'package:book_story/features/my%20_book/presentation/read_book_%20file.dart';
import 'package:book_story/features/profile/presentation/profile_screen.dart';
import 'package:book_story/presentation/main_screen.dart';
import 'package:book_story/features/my%20_book/presentation/add_book.dart';
import 'package:book_story/features/my%20_book/presentation/collection.dart';
import 'package:book_story/presentation/views/screens/home/library/share.dart';
import 'package:book_story/presentation/views/screens/map/chat_message_screen.dart';
import 'package:book_story/presentation/views/screens/post/add_post_screen.dart';
import 'package:book_story/presentation/views/screens/post/main_post_screen.dart';
import 'package:book_story/presentation/views/screens/post/post_detail.dart';
import 'package:book_story/features/authentication/presentation/login.dart';
import 'package:book_story/features/authentication/presentation/signup.dart';
import 'package:book_story/features/onboarding/splash_screen.dart';
import 'package:book_story/features/onboarding/welcome.dart';
import 'package:book_story/presentation/views/screens/profile/change_information.dart';
import 'package:book_story/presentation/views/screens/profile/change_password_screen.dart';
import 'package:book_story/presentation/views/screens/profile/edit_post_screen.dart';
import 'package:book_story/presentation/views/screens/profile/my_post.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/forgot_password.dart';

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
      case RoutePaths.changePassword:
        return MaterialPageRoute(
          builder: (_) => const ChangePasswordScreen(),
          settings: settings,
        );
      case RoutePaths.addBook:
        return MaterialPageRoute(
          builder: (_) => const AddBookScreen(),
          settings: settings,
        );
      case RoutePaths.changeInformation:
        return MaterialPageRoute(
          builder: (_) => const ChangeInformationScreen(),
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
      case RoutePaths.share:
        return MaterialPageRoute(
          builder: (_) => const ShareScreen(),
          settings: settings,
        );
      case RoutePaths.post:
        return MaterialPageRoute(
          builder: (_) => const MainPostScreen(),
          settings: settings,
        );
      case RoutePaths.postDetail:
        return MaterialPageRoute(
          builder: (_) => const PostDetail(),
          settings: settings,
        );
      case RoutePaths.addPost:
        return MaterialPageRoute(
          builder: (_) => const AddPostScreen(),
          settings: settings,
        );
      case RoutePaths.myPost:
        return MaterialPageRoute(
          builder: (_) => const MyPost(),
          settings: settings,
        );
      case RoutePaths.editPost:
        return MaterialPageRoute(
          builder: (_) => const EditPostScreen(),
          settings: settings,
        );
      case RoutePaths.chatMessage:
        return MaterialPageRoute(
          builder: (_) => const ChattingMessageScreen(),
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
