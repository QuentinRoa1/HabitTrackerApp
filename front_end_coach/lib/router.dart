import 'package:front_end_coach/screens/error_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end_coach/screens/loading_screen.dart';
import 'package:front_end_coach/screens/auth/login_screen.dart';
import 'package:front_end_coach/screens/auth/register_screen.dart';
import 'package:front_end_coach/screens/dashboard_screen.dart';

var routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error
  )
);