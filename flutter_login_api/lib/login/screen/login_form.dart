import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_api/login/cubit/login_cubit.dart';
import 'package:flutter_login_api/login/models/models.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Authentication Failed"),
                  backgroundColor: Colors.redAccent,
                ),
              );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Align(
              alignment: const Alignment(0, -1 / 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 40),
                  InputUsername(),
                  SizedBox(height: 20),
                  InputPassword(),
                  SizedBox(height: 20),
                  ButtonSubmit(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputUsername extends StatelessWidget {
  const InputUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // Lebar input diperpendek
      child: TextField(
        key: const Key('loginForm_usernameInput_textField'),
        onChanged: (value) =>
            context.read<LoginCubit>().usernameChanged(value),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.pink[100],
          labelText: 'Username',
          labelStyle: const TextStyle(color: Colors.pinkAccent),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.pinkAccent.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.pinkAccent.shade200),
          ),
          errorText:
              context.read<LoginCubit>().state.username.displayError == UsernameValidationError.empty
                  ? 'Invalid username'
                  : null,
        ),
      ),
    );
  }
}

class InputPassword extends StatelessWidget {
  const InputPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // Lebar input diperpendek
      child: TextField(
        key: const Key('loginForm_passwordInput_textField'),
        onChanged: (value) =>
            context.read<LoginCubit>().passwordChanged(value),
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.pink[100],
          labelText: "Password",
          labelStyle: const TextStyle(color: Colors.pinkAccent),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.pinkAccent.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.pinkAccent.shade200),
          ),
          errorText: (() {
            final error = context.read<LoginCubit>().state.password.displayError;
            if (error == PasswordValidationError.minimumLength) {
              return 'Password minimum 6 characters';
            } else if (error == PasswordValidationError.empty) {
              return 'Password cannot be empty';
            }
            return null;
          })(),
        ),
      ),
    );
  }
}

class ButtonSubmit extends StatelessWidget {
  const ButtonSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
              )
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: () {
                  context.read<LoginCubit>().loginSubmitted();
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
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),
              );
      },
    );
  }
}
