import 'package:dksoft_market/features/onboarding/widgets/onboarding_widget.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: _onPageChanged,
                  children: [
                    OnboardingWidget(
                      index: 0,
                      imagePath: AppAssets.onboarding_1,
                      title: 'Découvrez tout au même endroit',
                      subTitle:
                          'Découvrez une large sélection de produits et trouvez facilement ce que vous recherchez auprès de vos commerçants préférés.',
                    ),
                    OnboardingWidget(
                      index: 0,
                      imagePath: AppAssets.onboarding_2,
                      title: 'Commandez en quelques clics',
                      subTitle:
                          'Parcourez les produits, choisissez vos articles, passez votre commande et suivez son évolution en toute simplicité.',
                    ),

                    OnboardingWidget(
                      index: 0,
                      imagePath: AppAssets.onboarding_3,
                      title: 'Votre commande, directement chez vous',
                      subTitle:
                          'Plus besoin de vous déplacer. Nos livreurs prennent en charge votre commande et vous la livrent à l\'endroit de votre choix.',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < 3 - 1) {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.goNamed(AppRoute.home.name);
                    }
                  },
                  child: Text(_currentPage == 3 - 1 ? 'Commencer' : 'Suivant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
