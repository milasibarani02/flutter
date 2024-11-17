import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_api/auth/cubit/auth_cubit.dart';
import 'package:flutter_login_api/home/screen/home_screen.dart';
import 'package:flutter_login_api/login/screen/login_screen.dart';
import 'package:flutter_login_api/splash_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_login_api/post_list/lib/post_list/view/post_list_page.dart';
import 'package:flutter_login_api/wise_word/wise_word_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    _userRepository = UserRepository();
  }

  @override
  void dispose() {
    _authRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider(
        create: (context) => AuthCubit(
          authRepository: _authRepository,
          userRepository: _userRepository,
        ),
        child: AppScreen(),
      ),
    );
  }
}

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndex = 0; // Track which tab is selected

  // List of pages for BottomNavigationBar
  final List<Widget> _pages = [
    const PostListPage(),
    const HomeScreen(),
    const WiseWordPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      builder: (context, child) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            print('authState.status ${state.status}');
            switch (state.status) {
              case AuthStatus.authenticated:
                // Menunda navigasi untuk memastikan context sudah siap
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil<void>(
                    context,
                    "/home",
                    (route) => false,
                  );
                });
                break;
              default:
                // Menunda navigasi untuk memastikan context sudah siap
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushAndRemoveUntil<void>(
                    context,
                    LoginScreen.route(),
                    (route) => false,
                  );
                });
                break;
            }
          },
          child: child,
        );
      },
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return SplashScreen.route();
          case '/login':
            return LoginScreen.route();
          case '/home':
            return HomeScreen.route();
          case '/postlist':
            return PostListPage.route();
          case '/wiseword':
            return WiseWordPage.route();
          default:
            return MaterialPageRoute<void>(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Page not found')),
              ),
            );
        }
      },
      home: Scaffold(
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Set the currently selected tab
          onTap: _onItemTapped, // Handle tab change
          selectedItemColor: Colors.pinkAccent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Post List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_fields),
              label: 'Wise Words',
            ),
          ],
        ),
      ),
    );
  }
}
