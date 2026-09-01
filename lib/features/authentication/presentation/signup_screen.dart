import 'package:dksoft_market/core/data/kinshasa_communes.dart';
import 'package:dksoft_market/features/authentication/domain/account_type.dart';
import 'package:dksoft_market/features/authentication/presentation/auth_controller.dart';
import 'package:dksoft_market/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Inscription : les champs demandés reprennent le §5.1 du cahier des
/// charges (nom, téléphone, mot de passe, type de compte, commune, adresse).
/// L'e-mail reste optionnel comme prévu ("si disponible").
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  AccountType _accountType = AccountType.client;
  String? _commune;
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (_commune == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisissez votre commune.')),
      );
      return;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous devez accepter les conditions d'utilisation."),
        ),
      );
      return;
    }
    if (!isValid) return;

    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authControllerProvider.notifier)
        .signUp(
          fullName: _nameController.text.trim(),
          phone: '+243${_phoneController.text.replaceAll(' ', '')}',
          password: _passwordController.text,
          accountType: _accountType,
          commune: _commune!,
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      if (_accountType.requiresAdminValidation) {
        // §3.2/§3.3/§3.4 : commerçant, dealer et motard doivent d'abord
        // être validés par l'administration avant de pouvoir opérer.
        await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Compte créé'),
            content: Text(
              'Votre profil ${_accountType.label} a été soumis. '
              "L'administration doit valider votre compte avant que vous "
              'puissiez commencer.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      if (mounted) context.goNamed(AppRoute.home.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Créer un compte',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rejoignez MarketKin',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quelques informations pour créer votre profil.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                _SectionLabel('Vos informations'),
                const SizedBox(height: 10),

                AuthTextField(
                  label: 'NOM COMPLET',
                  controller: _nameController,
                  prefix: Icon(Icons.person_outline, color: Colors.grey[500]),
                  hintText: 'Jean Kabila',
                  validator: (value) => (value ?? '').trim().length < 2
                      ? 'Entrez votre nom complet'
                      : null,
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'TÉLÉPHONE',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: '81 234 56 78',
                  prefix: const _CountryPrefix(),
                  validator: (value) {
                    final digits = (value ?? '').replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );
                    return digits.length < 9 ? 'Numéro invalide' : null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'E-MAIL (OPTIONNEL)',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'vous@exemple.com',
                  prefix: Icon(Icons.mail_outline, color: Colors.grey[500]),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final valid = RegExp(r'^.+@.+\..+$').hasMatch(value);
                    return valid ? null : 'E-mail invalide';
                  },
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  initialValue: _commune,
                  decoration: const InputDecoration(labelText: 'COMMUNE'),
                  items: kKinshasaCommunes
                      .map(
                        (commune) => DropdownMenuItem(
                          value: commune,
                          child: Text(commune),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _commune = value),
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'ADRESSE (OPTIONNEL)',
                  controller: _addressController,
                  prefix: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey[500],
                  ),
                  hintText: 'Avenue, référence...',
                ),
                const SizedBox(height: 22),

                _SectionLabel('Sécurité'),
                const SizedBox(height: 10),

                AuthTextField(
                  label: 'MOT DE PASSE',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefix: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.grey[500],
                  ),
                  suffix: TextButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Text(_obscurePassword ? 'Afficher' : 'Masquer'),
                  ),
                  validator: (value) =>
                      (value ?? '').length < 6 ? 'Au moins 6 caractères' : null,
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'CONFIRMER LE MOT DE PASSE',
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  prefix: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.grey[500],
                  ),
                  validator: (value) => value != _passwordController.text
                      ? 'Les mots de passe ne correspondent pas'
                      : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) =>
                            setState(() => _acceptedTerms = value ?? false),
                        activeColor: AppColors.primary,
                      ),
                      Expanded(
                        child: Text(
                          "J'accepte les conditions d'utilisation de MarketKin",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Créer mon compte',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Déjà un compte ? Se connecter'),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🇨🇩', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 6),
        Text(
          '+243',
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 10),
        Container(width: 1, height: 22, color: Colors.grey.shade300),
      ],
    );
  }
}
