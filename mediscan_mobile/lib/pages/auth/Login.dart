// lib/pages/auth/Login.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'Create_Account.dart';
import '../dashboard/Dashboard.dart';

class Login extends StatefulWidget {
  static const routeName = '/';

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with RouteAware {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _submitting = false;
  bool _obscurePassword = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _clearFields();
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _emailTouched = false;
      _passwordTouched = false;
    });
  }

  void _goToCreateAccount() {
    _clearFields();
    Navigator.of(context).pushNamed(CreateAccountPage.routeName);
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final email = v.trim();
    if (!RegExp(r"^[a-zA-Z0-9]+@gmail\.com$").hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _pwdValidator(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(v)) {
      return 'Password can only contain letters and numbers';
    }
    return null;
  }

  void _signIn() {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });

    final emailError = _emailValidator(_emailController.text);
    final passwordError = _pwdValidator(_passwordController.text);

    if (emailError != null || passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your input fields'),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    setState(() => _submitting = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _submitting = false);
      // Navigate to Dashboard on demo success
      Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E88FF),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF1E88FF),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/images/mediscanapp_logo.png',
                              color: Colors.white,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        'MediScan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Medical Record Verification System',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 28),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 13.5),
                          onChanged: (_) {
                            setState(() {
                              _emailTouched = true;
                            });
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                              child: Icon(Icons.email_outlined, size: 20, color: Colors.grey[700]),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                            border: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12.5, fontWeight: FontWeight.w600, letterSpacing: 0.6),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Visibility(
                          visible: _emailTouched,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4, top: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _emailValidator(_emailController.text) ?? '',
                                style: TextStyle(
                                  color: _emailValidator(_emailController.text) != null
                                      ? Colors.red
                                      : Colors.transparent,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(fontSize: 13.5),
                              onChanged: (_) {
                                setState(() {
                                  _passwordTouched = true;
                                });
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 48, top: 14, bottom: 14, right: 50),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                                  child: Icon(Icons.lock_outline, size: 20, color: Colors.grey[700]),
                                ),
                                prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12.5, fontWeight: FontWeight.w600, letterSpacing: 0.6),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Visibility(
                          visible: _passwordTouched,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4, top: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _pwdValidator(_passwordController.text) ?? '',
                                style: TextStyle(
                                  color: _pwdValidator(_passwordController.text) != null
                                      ? Colors.red
                                      : Colors.transparent,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8, bottom: 6),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(40, 28),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Forgot password',
                              style: TextStyle(
                                color: Color(0xFF1E88FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _submitting
                              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'or Continue with',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(color: Colors.grey[300]!),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/google_logo.png', width: 20, height: 20),
                                    const SizedBox(width: 8),
                                    const Text('Google', style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(color: Colors.grey[300]!),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/apple_logo.png', width: 20, height: 20),
                                    const SizedBox(width: 8),
                                    const Text('Apple', style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: _goToCreateAccount,
                            child: const Text(
                              'Create one',
                              style: TextStyle(
                                color: Color(0xFF1E88FF),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}