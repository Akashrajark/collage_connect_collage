// import 'package:collage_connect_collage/common_widget/custom_button.dart';
// import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
// import 'package:collage_connect_collage/features/home/home_screen.dart';
// import 'package:collage_connect_collage/theme/app_theme.dart';
// import 'package:collage_connect_collage/util/value_validator.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(color: secondaryColor),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Welcome Text
//                   // Login Form
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15)),
//                     width: 400,
//                     child: Padding(
//                       padding: const EdgeInsets.all(27.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           const Text(
//                             'Welcome to \nCollege Connect',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           const Text(
//                             'Sign in to continue',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 48),

//                           // Email Field
//                           CustomTextFormField(
//                               labelText: 'Email',
//                               controller: _emailController,
//                               validator: emailValidator,
//                               isLoading: false),
//                           const SizedBox(height: 16),
//                           // Password Field
//                           CustomTextFormField(
//                               labelText: 'Password',
//                               controller: _passwordController,
//                               validator: notEmptyValidator,
//                               isLoading: false),

//                           const SizedBox(height: 32),
//                           CustomButton(
//                             color: Colors.white,
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => HomeScreen(),
//                                   ));
//                             },
//                             label: 'Signin',
//                           ),
//                           const SizedBox(height: 32),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   // Sign Up Text
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/features/home/home_screen.dart';
import 'package:collage_connect_collage/theme/app_theme.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Loginscreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1568792923760-d70635a89fdc?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Center(
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  border: Border.all(color: primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Log in - Collage',
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: Colors.white.withAlpha(220),
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(
                          labelText: 'Enter email',
                          controller: _emailController,
                          validator: emailValidator,
                          isLoading: false),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                          controller: _passwordController,
                          obscureText: isObscure,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  isObscure = !isObscure;
                                  setState(() {});
                                },
                                icon: Icon(isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        inverse: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        label: 'Login',
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

// const Color.fromARGB(255, 199, 50, 225)
