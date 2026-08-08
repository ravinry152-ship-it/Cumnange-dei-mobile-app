import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _illustrationController;
  late AnimationController _textController;
  late Animation<double> _illustrationAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Browse thousands of\nproduct in one place',
      subtitle:
          'Browse by item, brand, category, or by your favourite eshop',
      illustrationColor: const Color(0xFFE8EAF6),
      accentColor: const Color(0xFF3949AB),
      icon: Icons.shopping_bag_outlined,
      decorIcon1: Icons.storefront_outlined,
      decorIcon2: Icons.category_outlined,
    ),
    OnboardingData(
      title: 'Choose your preferred\npayment method',
      subtitle:
          'Choose mobile online money, visa, or cash on delivery',
      illustrationColor: const Color(0xFFE8F5E9),
      accentColor: const Color(0xFF2E7D32),
      icon: Icons.payment_outlined,
      decorIcon1: Icons.credit_card_outlined,
      decorIcon2: Icons.account_balance_wallet_outlined,
    ),
    OnboardingData(
      title: 'Confirm your order and\nawait delivery',
      subtitle:
          'Choose from a wide range of delivery options — eshop, pickup point or at doorstep',
      illustrationColor: const Color(0xFFFFF3E0),
      accentColor: const Color(0xFFE65100),
      icon: Icons.local_shipping_outlined,
      decorIcon1: Icons.location_on_outlined,
      decorIcon2: Icons.check_circle_outline,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _illustrationAnim = CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _illustrationController.forward();
    _textController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _illustrationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _illustrationController.reset();
    _textController.reset();
    _illustrationController.forward();
    _textController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to main app
      Get.offNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = _pages[_currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: TextButton(
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], size, index == _currentPage);
                },
              ),
            ),

            // Bottom navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(right: 6),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? data.accentColor
                              : data.accentColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Next / Get Started button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: _currentPage == _pages.length - 1
                        ? ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: data.accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              shadowColor: data.accentColor.withOpacity(0.4),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          )
                        : TextButton(
                            onPressed: _nextPage,
                            child: Row(
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: data.accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded,
                                    color: data.accentColor, size: 20),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data, Size size, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Illustration card
          Expanded(
            flex: 5,
            child: ScaleTransition(
              scale: _illustrationAnim,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: data.accentColor.withOpacity(0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    children: [
                      // Background circle
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: size.width * 0.55,
                          height: size.width * 0.55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: data.illustrationColor,
                          ),
                        ),
                      ),

                      // Decorative sparkles
                      Positioned(
                        top: 28,
                        left: 32,
                        child: _StarWidget(
                            color: data.accentColor.withOpacity(0.5), size: 18),
                      ),
                      Positioned(
                        bottom: 40,
                        right: 40,
                        child: _DiamondWidget(
                            color: data.accentColor.withOpacity(0.4), size: 22),
                      ),
                      Positioned(
                        top: 60,
                        right: 48,
                        child: _DiamondWidget(
                            color: data.accentColor.withOpacity(0.25), size: 14),
                      ),

                      // Main illustration
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Main icon in circle
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.illustrationColor,
                                ),
                                child: Icon(
                                  data.icon,
                                  size: 64,
                                  color: data.accentColor,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Floating small icons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _FloatingIconChip(
                                    icon: data.decorIcon1,
                                    color: data.accentColor,
                                    bgColor: data.illustrationColor,
                                  ),
                                  const SizedBox(width: 12),
                                  _FloatingIconChip(
                                    icon: data.decorIcon2,
                                    color: data.accentColor,
                                    bgColor: data.illustrationColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Text content
          Expanded(
            flex: 3,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: data.accentColor,
                        height: 1.35,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Model ────────────────────────────────────────────────────────────────

class OnboardingData {
  final String title;
  final String subtitle;
  final Color illustrationColor;
  final Color accentColor;
  final IconData icon;
  final IconData decorIcon1;
  final IconData decorIcon2;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.illustrationColor,
    required this.accentColor,
    required this.icon,
    required this.decorIcon1,
    required this.decorIcon2,
  });
}

// ─── Decorative Widgets ────────────────────────────────────────────────────────

class _StarWidget extends StatelessWidget {
  final Color color;
  final double size;
  const _StarWidget({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarPainter(color: color),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;

    for (int i = 0; i < 4; i++) {
      final angle = (i * 3.14159 / 2);
      canvas.drawLine(
        Offset(cx + (cx * 0.3) * _cos(angle), cy + (cy * 0.3) * _sin(angle)),
        Offset(cx + cx * _cos(angle), cy + cy * _sin(angle)),
        paint,
      );
    }
  }

  double _cos(double a) => a == 0
      ? 1
      : a == 1.5708
          ? 0
          : a == 3.14159
              ? -1
              : 0;
  double _sin(double a) => a == 0
      ? 0
      : a == 1.5708
          ? 1
          : a == 3.14159
              ? 0
              : -1;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DiamondWidget extends StatelessWidget {
  final Color color;
  final double size;
  const _DiamondWidget({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DiamondPainter(color: color),
    );
  }
}

class _DiamondPainter extends CustomPainter {
  final Color color;
  _DiamondPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FloatingIconChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  const _FloatingIconChip(
      {required this.icon, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}