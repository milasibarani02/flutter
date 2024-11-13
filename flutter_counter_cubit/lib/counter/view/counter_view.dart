import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter_cubit/counter/counter.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            // Menampilkan Snackbar untuk kelipatan 5
            if (state % 5 == 0 && state != 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You got $state! 🎉"),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.fixed,
                    backgroundColor: Colors.pinkAccent,
                    // margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              });
            }

            // Tampilan berubah jika nilai counter kelipatan 5
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: (state % 5 == 0 && state != 0) ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
              child: (state % 5 == 0 && state != 0) 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                      children: [
                        Image.asset(
                          'assets/images/surprise.png',
                          width: 300,
                        ),
                        const SizedBox(height: 50),
                        Text(
                          '$state',
                          style: textTheme.displayMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '$state',
                      style: textTheme.displayMedium,
                    ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'increment',
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'reset',
            onPressed: () => context.read<CounterCubit>().reset(),
            child: DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make it bold
                fontSize: 18, // Adjust size (increase it to make the text bigger)
              ),
              child: const Text('C'),
            ),
            
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'multiply',
            child: const Icon(Icons.close),
            onPressed: () => context.read<CounterCubit>().multiplyByTwo(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decreaseByTwo',
            child: const Icon(Icons.exposure_minus_2),
            onPressed: () => context.read<CounterCubit>().decreaseByTwo(),
          ),
        ],
      ),
    );
  }
}
