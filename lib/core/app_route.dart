import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/main_screen.dart';
import 'package:book_exchange/presentation/views/screens/home/library/add_book.dart';
import 'package:book_exchange/presentation/views/screens/home/library/collection.dart';
import 'package:book_exchange/presentation/views/screens/home/library/share.dart';
import 'package:book_exchange/presentation/views/screens/map/chat_message_screen.dart';
import 'package:book_exchange/presentation/views/screens/post/add_post_screen.dart';
import 'package:book_exchange/presentation/views/screens/post/main_post_screen.dart';
import 'package:book_exchange/presentation/views/screens/post/post_detail.dart';
import 'package:book_exchange/presentation/views/screens/pre_home/forgot_password.dart';
import 'package:book_exchange/presentation/views/screens/pre_home/login.dart';
import 'package:book_exchange/presentation/views/screens/pre_home/signup.dart';
import 'package:book_exchange/presentation/views/screens/pre_home/splash_screen.dart';
import 'package:book_exchange/presentation/views/screens/pre_home/verification_screen.dart';
import 'package:book_exchange/presentation/views/screens/pre_home/welcome.dart';
import 'package:book_exchange/presentation/views/screens/profile/change_information.dart';
import 'package:book_exchange/presentation/views/screens/profile/change_password_screen.dart';
import 'package:book_exchange/presentation/views/screens/profile/edit_post_screen.dart';
import 'package:book_exchange/presentation/views/screens/profile/my_post.dart';
import 'package:book_exchange/presentation/views/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

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
      case RoutePaths.verifyEmail:
        return MaterialPageRoute(
          builder: (_) => const VerificationScreen(),
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
      // case RoutePaths.contribueBook:
      //   return MaterialPageRoute(
      //     builder: (_) => const AddContributionBookScreen(
      //         bookId: 'bookId',
      //         bookName: 'bookName',
      //         bookAuthor: 'bookAuthor',
      //         bookDescription: 'bookDescription',
      //         imageUrl: 'imageUrl'),
      //     settings: settings,
      //   );
      case RoutePaths.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      case RoutePaths.home:
        return MaterialPageRoute(
          builder: (_) => const CollectionScreen(),
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
