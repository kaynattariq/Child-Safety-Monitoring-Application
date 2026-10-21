import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/App_theme.dart';
import 'Controller/Setting_Controller.dart';

class OutroScreen extends StatelessWidget {
  const OutroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutroController controller = Get.put(OutroController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.meshGradient,
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            _buildAnimatedBackground(controller),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildHeader(controller),
                      const SizedBox(height: 32),
                      _buildProfileSection(controller),
                      const SizedBox(height: 24),
                      _buildAccountInfoCard(controller),
                      const SizedBox(height: 24),
                      _buildIoTStatusCard(controller),
                      const SizedBox(height: 24),
                      _buildTestNotificationsCard(controller),
                      const SizedBox(height: 24),
                      _buildDangerZoneCard(controller),
                      const SizedBox(height: 32),
                      _buildSwipeToLogout(controller, context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return Stack(
          children: [
            // Top gradient orb
            Positioned(
              top: -150,
              right: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentPurple.withOpacity(0.12 * controller.pulseAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom gradient orb
            Positioned(
              bottom: -200,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryAccent.withOpacity(0.1 * controller.pulseAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Grid pattern
            Positioned.fill(
              child: CustomPaint(
                painter: GridPatternPainter(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, controller.slideAnimation.value),
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: AppTheme.glassGradient,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Manage your profile & device',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return Column(
          children: [
            // Profile Avatar with glow
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryAccent.withOpacity(0.5),
                    AppTheme.accentCyan.withOpacity(0.3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryAccent.withOpacity(0.3 * controller.pulseAnimation.value),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppTheme.buttonGradient,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Obx(() => Text(
                        controller.fullName.value.isNotEmpty
                            ? controller.fullName.value[0].toUpperCase()
                            : 'U',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )),
                    ),
                    // Online indicator
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.successGreen,
                          border: Border.all(
                            color: AppTheme.primaryDark,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.successGreen.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
              controller.fullName.value.isEmpty
                  ? 'Loading...'
                  : controller.fullName.value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )),
            const SizedBox(height: 4),
            Obx(() => Text(
              controller.email.value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildAccountInfoCard(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppTheme.glassGradient,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryAccent.withOpacity(0.15),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppTheme.primaryAccent,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Account Information',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      icon: Icons.badge_rounded,
                      label: 'Full Name',
                      valueWidget: Obx(() => Text(
                        controller.fullName.value.isEmpty
                            ? 'Loading...'
                            : controller.fullName.value,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )),
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.email_rounded,
                      label: 'Email Address',
                      valueWidget: Obx(() => Text(
                        controller.email.value,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.phone_rounded,
                      label: 'Phone Number',
                      valueWidget: Obx(() => Text(
                        controller.phoneNumber.value.isEmpty
                            ? 'Loading...'
                            : controller.phoneNumber.value,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )),
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Member Since',
                      valueWidget: Obx(() => Text(
                        controller.memberSince.value.isEmpty
                            ? 'Loading...'
                            : controller.memberSince.value,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.5),
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                valueWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.08),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildIoTStatusCard(OutroController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                AppTheme.successGreen.withOpacity(0.12),
                AppTheme.successGreen.withOpacity(0.04),
              ],
            ),
            border: Border.all(
              color: AppTheme.successGreen.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Animated IoT indicator
              AnimatedBuilder(
                animation: controller.pulseController,
                builder: (context, child) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.successGreen.withOpacity(0.15),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.successGreen.withOpacity(
                              0.25 * controller.pulseAnimation.value),
                          blurRadius: 15 * controller.pulseAnimation.value,
                          spreadRadius: 3 * controller.pulseAnimation.value,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sensors_rounded,
                      color: AppTheme.successGreen,
                      size: 24,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.successGreen,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.successGreen.withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'IoT Device Active',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ESP32 sensors monitoring your child\'s safety',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeToLogout(OutroController controller, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 40;
    const buttonWidth = 64.0;
    final maxSwipeDistance = screenWidth - buttonWidth - 12;

    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Column(
            children: [
              // Warning text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.warningRed.withOpacity(0.1),
                  border: Border.all(
                    color: AppTheme.warningRed.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.warningRed,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'This will disconnect your IoT device',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.warningRed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Swipe button container
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 64,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.warningRed.withOpacity(0.12),
                          AppTheme.warningRed.withOpacity(0.04),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.warningRed.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Progress fill
                        Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: (screenWidth * controller.swipeProgress.value)
                              .clamp(0.0, screenWidth),
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.warningRed.withOpacity(0.3),
                                AppTheme.warningRed.withOpacity(0.15),
                              ],
                            ),
                          ),
                        )),

                        // Center text
                        Center(
                          child: Obx(() => AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: controller.showSwipeHint.value ? 1.0 : 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.power_settings_new_rounded,
                                  color: AppTheme.warningRed.withOpacity(0.7),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Swipe to Turn Off & Logout',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.warningRed.withOpacity(0.8),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedBuilder(
                                  animation: controller.swipeHintController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                          controller.swipeHintAnimation.value * 8, 0),
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        color: AppTheme.warningRed.withOpacity(0.5),
                                        size: 22,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )),
                        ),

                        // Swipe button
                        Obx(() => Positioned(
                          left: 4 + (maxSwipeDistance * controller.swipeProgress.value),
                          top: 4,
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              if (!controller.isLoggingOut.value) {
                                final newProgress = controller.swipeProgress.value +
                                    (details.delta.dx / maxSwipeDistance);
                                controller.updateSwipeProgress(newProgress);
                              }
                            },
                            onHorizontalDragEnd: (details) {
                              if (!controller.isLoggingOut.value) {
                                controller.resetSwipe();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              width: buttonWidth - 8,
                              height: buttonWidth - 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: controller.swipeProgress.value > 0.7
                                      ? [const Color(0xFFDC2626), const Color(0xFFEF4444)]
                                      : [AppTheme.warningRed, const Color(0xFFFF8080)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.warningRed.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: controller.isLoggingOut.value
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                                  : Icon(
                                controller.swipeProgress.value > 0.7
                                    ? Icons.power_off_rounded
                                    : Icons.power_settings_new_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer text
              const SizedBox(height: 16),
              Text(
                'You can reconnect anytime by logging in again',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // Test Notifications Card
  Widget _buildTestNotificationsCard(OutroController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.accentCyan.withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppTheme.accentCyan,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Notifications',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Send test alerts to verify sound & vibration',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Test Buttons
              // _buildTestNotificationButton(
              //   icon: Icons.warning_amber_rounded,
              //   title: 'Proximity Alert',
              //   subtitle: 'Test distance warning',
              //   color: AppTheme.warningRed,
              //   onTap: () => controller.testProximityNotification(),
              // ),

              // const SizedBox(height: 12),

              // _buildTestNotificationButton(
              //   icon: Icons.volume_up_rounded,
              //   title: 'Sound Hazard Alert',
              //   subtitle: 'Test loud noise warning',
              //   color: AppTheme.warningOrange,
              //   onTap: () => controller.testSoundHazardNotification(),
              // ),

              // const SizedBox(height: 12),

              // _buildTestNotificationButton(
              //   icon: Icons.child_care_rounded,
              //   title: 'Cry Detection Alert',
              //   subtitle: 'Test baby cry warning',
              //   color: AppTheme.accentPink,
              //   onTap: () => controller.testCryDetectionNotification(),
              // ),

              // const SizedBox(height: 16),

              // Test All Button
              GestureDetector(
                onTap: () => controller.testAllNotifications(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentCyan,
                        AppTheme.primaryAccent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentCyan.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.play_circle_filled_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TEST ALL NOTIFICATIONS',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestNotificationButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Icon(
                Icons.send_rounded,
                color: color,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Danger Zone Card - Delete Alerts
  Widget _buildDangerZoneCard(OutroController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.warningRed.withOpacity(0.1),
                AppTheme.warningRed.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.warningRed.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.warningRed.withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: AppTheme.warningRed,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Danger Zone',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.warningRed,
                          ),
                        ),
                        Text(
                          'Irreversible actions',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Delete All Alerts Button
              _buildDangerButton(
                icon: Icons.delete_sweep_rounded,
                title: 'Delete All Alerts',
                subtitle: 'Remove all proximity, sound & cry alerts',
                onTap: () => _showDeleteAlertsDialog(controller),
              ),

              const SizedBox(height: 12),

              // Clear Notification History
              _buildDangerButton(
                icon: Icons.notifications_off_rounded,
                title: 'Clear Notifications',
                subtitle: 'Dismiss all pending notifications',
                onTap: () => controller.clearAllNotifications(),
              ),

              const SizedBox(height: 12),

              // Reset App Data
              _buildDangerButton(
                icon: Icons.restart_alt_rounded,
                title: 'Reset App Data',
                subtitle: 'Clear all local data & preferences',
                onTap: () => _showResetDataDialog(controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(
            color: AppTheme.warningRed.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.warningRed.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: AppTheme.warningRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.warningRed.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAlertsDialog(OutroController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppTheme.warningRed.withOpacity(0.3),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.warningRed.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: AppTheme.warningRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Delete All Alerts?',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          'This will permanently delete all proximity alerts, sound hazard alerts, and cry detection alerts from Firebase.\n\nThis action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteAllAlerts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Delete All',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDataDialog(OutroController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppTheme.warningRed.withOpacity(0.3),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.warningRed.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.restart_alt_rounded,
                color: AppTheme.warningRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Reset App Data?',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          'This will clear all local data including preferences and cached data.\n\nYou will need to reconfigure the app.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.resetAppData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Reset',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Grid Pattern Painter
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}