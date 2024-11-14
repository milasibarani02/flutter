import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_api/auth/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
      ),
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) {
                    final user = context.select(
                      (AuthCubit auth) => auth.state.user,
                    );
                    return Column(
                      children: [
                        const Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'User ID: ${user?.id ?? "Unknown"}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pinkAccent.shade200,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Name: ${user?.name ?? "No Name"}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pinkAccent.shade200,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Balance: ${user?.balance ?? 0} IDR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent.shade400,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent.shade100,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
