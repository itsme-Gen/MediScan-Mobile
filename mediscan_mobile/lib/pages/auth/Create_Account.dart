// lib/pages/auth/create_account.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAccountPage extends StatefulWidget {
  static const routeName = '/create';
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _controllers = {
    'firstName': TextEditingController(),
    'middleName': TextEditingController(),
    'lastName': TextEditingController(),
    'department': TextEditingController(),
    'license': TextEditingController(),
    'hospitalId': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  final _roles = ['Doctor', 'Nurse', 'Admin', 'Lab Technician', 'Pharmacist', 'Other'];
  String? _selectedRole;
  bool _obscurePassword = true, _obscureConfirm = true, _submitting = false, _submitted = false;
  final _touched = <String, bool>{};

  String? _validateField(String key, String? value) {
    switch (key) {
      case 'firstName':
      case 'middleName':
      case 'lastName':
        if (value == null || value.isEmpty) return '${key.replaceAll('Name', ' name')} is required';
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) return 'Invalid character';
        break;
      case 'department':
      case 'license':
      case 'hospitalId':
        if (value != null && value.isNotEmpty) {
          if (value.trim().isEmpty || value != value.trim() || value.contains(RegExp(r'\s{2,}'))) return 'Invalid character';
          if (!RegExp(r'^[a-zA-Z0-9]+(\s[a-zA-Z0-9]+)*$').hasMatch(value)) return 'Invalid character';
        }
        break;
      case 'email':
        if (value == null || value.trim().isEmpty) return 'Email is required';
        if (!RegExp(r"^[a-zA-Z0-9]+@gmail\.com$").hasMatch(value.trim())) return 'Enter a valid email';
        break;
      case 'password':
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Password must be at least 8 characters';
        if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) return 'Password can only contain letters and numbers';
        break;
      case 'confirmPassword':
        if (_controllers['password']!.text.isNotEmpty) {
          if (value == null || value.isEmpty) return 'Please confirm password';
          if (value != _controllers['password']!.text) return 'Passwords do not match';
        }
        break;
    }
    return null;
  }

  Widget _buildField(String key, String label, {String? hint, bool isPassword = false, bool hasIcon = false, List<TextInputFormatter>? formatters, bool showLabel = true}) {
    final controller = _controllers[key]!;
    final touched = _touched[key] ?? false;
    final error = _validateField(key, controller.text);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
        ],
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: isPassword ? _buildPasswordField(key, hint ?? label) : _buildTextFormField(controller, hint ?? label, hasIcon, formatters),
        ),
        SizedBox(
          height: 22,
          child: Visibility(
            visible: touched || _submitted,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Text(error ?? '', style: TextStyle(color: error != null ? Colors.red : Colors.transparent, fontSize: 9)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String hint, bool hasIcon, List<TextInputFormatter>? formatters) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.only(left: hasIcon ? 32 : 8, top: 6, bottom: 6, right: 8),
        prefixIcon: hasIcon ? const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.email_outlined, size: 18)) : null,
        prefixIconConstraints: hasIcon ? const BoxConstraints(minWidth: 32, minHeight: 18) : null,
      ),
      onChanged: (_) => setState(() => _touched[_getKeyFromController(controller)] = true),
      style: const TextStyle(fontSize: 12),
      inputFormatters: formatters,
    );
  }

  Widget _buildPasswordField(String key, String hint) {
    final obscure = key == 'password' ? _obscurePassword : _obscureConfirm;
    return Stack(
      children: [
        TextFormField(
          controller: _controllers[key]!,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.only(left: 32, top: 6, bottom: 6, right: 48),
            prefixIcon: const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.lock_outline, size: 18)),
            prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 18),
          ),
          onChanged: (_) => setState(() => _touched[key] = true),
          obscureText: obscure,
          style: const TextStyle(fontSize: 12),
          inputFormatters: [
            LengthLimitingTextInputFormatter(20),
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
        ),
        Positioned(
          right: 2, 
          top: 0, 
          bottom: 0,
          child: SizedBox(
            width: 40,
            child: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 16, color: Colors.grey[600]),
              onPressed: () => setState(() => key == 'password' ? _obscurePassword = !_obscurePassword : _obscureConfirm = !_obscureConfirm),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 32),
            ),
          ),
        ),
      ],
    );
  }

  String _getKeyFromController(TextEditingController controller) {
    return _controllers.entries.firstWhere((entry) => entry.value == controller).key;
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      for (var key in _controllers.keys) {
        _touched[key] = true;
      }
    });

    final errors = [
      ..._controllers.entries.map((e) => _validateField(e.key, e.value.text)),
      (_selectedRole == null || _selectedRole!.isEmpty) ? 'Role is required' : null,
    ];

    if (errors.any((error) => error != null)) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully')));
    Navigator.of(context).pop();
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final horizontalPadding = screenWidth < 350 ? 12.0 : 16.0;
    final formPadding = isSmallScreen ? 16.0 : 20.0;
    final maxWidth = screenWidth > 500 ? 400.0 : screenWidth * 0.9;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF1E88FF)),
                          SizedBox(width: 4),
                          Text('Back', style: TextStyle(color: Color(0xFF1E88FF), fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'CREATE ACCOUNT', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)
                    )
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
            // Form
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Container(
                    width: maxWidth,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(formPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name fields - Stack vertically on small screens
                        if (isSmallScreen) ...[
                          _buildField('firstName', 'First Name', 
                            formatters: [
                              LengthLimitingTextInputFormatter(15), 
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                            ]
                          ),
                          _buildField('middleName', 'Middle Name', 
                            formatters: [
                              LengthLimitingTextInputFormatter(15), 
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                            ]
                          ),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildField('firstName', 'First Name', 
                                  formatters: [
                                    LengthLimitingTextInputFormatter(15), 
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                                  ]
                                )
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildField('middleName', 'Middle Name', 
                                  formatters: [
                                    LengthLimitingTextInputFormatter(15), 
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                                  ]
                                )
                              ),
                            ],
                          ),
                        ],
                        
                        _buildField('lastName', 'Last Name', 
                          formatters: [
                            LengthLimitingTextInputFormatter(15), 
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                          ]
                        ),
                        
                        const SizedBox(height: 6),
                        
                        // Role and Department
                        if (isSmallScreen) ...[
                          // Stack vertically on small screens
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedRole,
                                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
                                  hint: const Text('Select your Role', style: TextStyle(fontSize: 11)),
                                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 11)))).toList(),
                                  onChanged: (v) => setState(() => _selectedRole = v),
                                  isExpanded: true,
                                  style: const TextStyle(fontSize: 11, color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 22,
                                child: Visibility(
                                  visible: _submitted,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8, top: 2),
                                    child: Text(
                                      (_selectedRole == null || _selectedRole!.isEmpty) ? 'Role is required' : '',
                                      style: TextStyle(color: (_selectedRole == null || _selectedRole!.isEmpty) ? Colors.red : Colors.transparent, fontSize: 9),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _buildField('department', 'Department', 
                            formatters: [
                              LengthLimitingTextInputFormatter(20), 
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))
                            ]
                          ),
                        ] else ...[
                          // Side by side layout for larger screens
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(child: Text('Role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                                  const SizedBox(width: 10),
                                  const Expanded(child: Text('Department', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          child: DropdownButtonFormField<String>(
                                            value: _selectedRole,
                                            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
                                            hint: const Text('Select your Role', style: TextStyle(fontSize: 11)),
                                            items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 11)))).toList(),
                                            onChanged: (v) => setState(() => _selectedRole = v),
                                            isExpanded: true,
                                            style: const TextStyle(fontSize: 11, color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 22,
                                          child: Visibility(
                                            visible: _submitted,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8, top: 2),
                                              child: Text(
                                                (_selectedRole == null || _selectedRole!.isEmpty) ? 'Role is required' : '',
                                                style: TextStyle(color: (_selectedRole == null || _selectedRole!.isEmpty) ? Colors.red : Colors.transparent, fontSize: 9),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildField('department', 'Department', showLabel: false, 
                                      formatters: [
                                        LengthLimitingTextInputFormatter(20), 
                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))
                                      ]
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                        
                        const SizedBox(height: 6),
                        
                        // License and Hospital ID
                        if (isSmallScreen) ...[
                          _buildField('license', 'License Number', hint: 'Professional license number', 
                            formatters: [
                              LengthLimitingTextInputFormatter(20), 
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))
                            ]
                          ),
                          _buildField('hospitalId', 'Hospital ID', hint: 'Employee/Hospital ID', 
                            formatters: [
                              LengthLimitingTextInputFormatter(20), 
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))
                            ]
                          ),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildField('license', 'License Number', hint: 'Professional license number', 
                                  formatters: [
                                    LengthLimitingTextInputFormatter(20), 
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))
                                  ]
                                )
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildField('hospitalId', 'Hospital ID', hint: 'Employee/Hospital ID', 
                                  formatters: [
                                    LengthLimitingTextInputFormatter(20), 
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))
                                  ]
                                )
                              ),
                            ],
                          ),
                        ],
                        
                        const SizedBox(height: 6),
                        _buildField('email', 'Email', hint: 'Professional email', hasIcon: true, 
                          formatters: [
                            LengthLimitingTextInputFormatter(30), 
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ]
                        ),
                        const SizedBox(height: 4),
                        _buildField('password', 'Password', hint: 'Create password', isPassword: true),
                        const SizedBox(height: 4),
                        _buildField('confirmPassword', 'Confirm password', hint: 'Confirm password', isPassword: true),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _submitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B79FF), 
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), 
                              padding: EdgeInsets.zero,
                              elevation: 2,
                            ),
                            child: _submitting 
                              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) 
                              : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}