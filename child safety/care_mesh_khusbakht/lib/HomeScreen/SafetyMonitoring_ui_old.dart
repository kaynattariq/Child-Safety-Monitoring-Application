import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Theme/App_theme.dart';
import 'Controller/SafetyMonitoring_Controller.dart';
import 'Setting.dart';

class ChildSafetyMonitoringScreen extends StatelessWidget {
  const ChildSafetyMonitoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SafetyMonitoringController controller =
    Get.put(SafetyMonitoringController());

    return Scaffold(
      body: Container(
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
            // Animated Background Elements
            _buildBackgroundElements(),

            // Main Content
            SafeArea(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.manualRefresh();
                    await controller.refreshLocation();
                  },
                  color: AppTheme.primaryAccent,
                  backgroundColor: AppTheme.primaryDark,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLocationHeader(controller),
                              const SizedBox(height: 20),
                              _buildHeaderSection(controller),
                              const SizedBox(height: 24),
                              _buildLiveStatusBar(controller),
                              const SizedBox(height: 24),
                              _buildAlertStatsGrid(controller),
                              const SizedBox(height: 28),
                              _buildProximitySection(controller),
                              const SizedBox(height: 24),
                              _buildSoundHazardSection(controller),
                              const SizedBox(height: 24),
                              _buildCryDetectionSection(controller),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Top right gradient orb
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryAccent.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom left gradient orb
        Positioned(
          bottom: -150,
          left: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accentPurple.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Grid pattern overlay
        Positioned.fill(
          child: CustomPaint(
            painter: GridPatternPainter(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading indicator
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryAccent.withOpacity(0.2),
                  AppTheme.accentCyan.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: AppTheme.primaryAccent.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: AppTheme.primaryAccent,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Connecting to IoT Sensors...',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Establishing secure connection',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationHeader(SafetyMonitoringController controller) {
    return Obx(() => ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Row - Location
              Row(
                children: [
                  // Location Icon with animated glow
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentCyan.withOpacity(0.25),
                          AppTheme.primaryAccent.withOpacity(0.15),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentCyan.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppTheme.accentCyan,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Location Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label row
                        Row(
                          children: [
                            if (controller.locationLoading.value)
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppTheme.accentCyan,
                                ),
                              )
                            else
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.successGreen,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.successGreen.withOpacity(0.6),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(width: 6),
                            Text(
                              'GPS',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.successGreen,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        // Location text
                        Text(
                          controller.locationLoading.value
                              ? 'Detecting...'
                              : controller.currentLocation.value.isEmpty
                              ? 'Unavailable'
                              : controller.currentLocation.value,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Bottom Row - Time & Date
              Row(
                children: [
                  // Time Display
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.accentCyan.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.access_time_rounded,
                            color: AppTheme.accentCyan,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.currentTime.value,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.warningRed,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.warningRed.withOpacity(0.6),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'LIVE',
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.warningRed,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Vertical Divider
                  Container(
                    width: 1,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: Colors.white.withOpacity(0.1),
                  ),

                  // Date Display
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.accentPurple.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppTheme.accentPurple,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.currentDateShort.value.isNotEmpty
                                ? controller.currentDateShort.value
                                : 'Loading...',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildHeaderSection(SafetyMonitoringController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety Monitor',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Obx(() => Text(
                controller.currentDate.value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.5),
                ),
              )),
            ],
          ),
        ),
        _buildSettingsButton(),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: () => Get.to(() => const OutroScreen()),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.settings_rounded,
          color: Colors.white70,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLiveStatusBar(SafetyMonitoringController controller) {
    return Obx(() => ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.successGreen.withOpacity(0.15),
                AppTheme.successGreen.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.successGreen.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Pulsing indicator
              _buildPulsingDot(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IoT DEVICE STATUS',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.5),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.getConnectionStatusDisplay(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sensors_rounded,
                      size: 14,
                      color: AppTheme.accentCyan,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ESP32',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildPulsingDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Container(
          width: 12 * value,
          height: 12 * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.successGreen,
            boxShadow: [
              BoxShadow(
                color: AppTheme.successGreen.withOpacity(0.5),
                blurRadius: 8 * value,
                spreadRadius: 2 * value,
              ),
            ],
          ),
        );
      },
      onEnd: () {},
    );
  }

  Widget _buildAlertStatsGrid(SafetyMonitoringController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Proximity',
                count: controller.proximityAlerts.length,
                icon: Icons.near_me_rounded,
                color: AppTheme.warningRed,
                gradient: [
                  AppTheme.warningRed.withOpacity(0.2),
                  AppTheme.warningRed.withOpacity(0.05),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Sound',
                count: controller.soundAlerts.length,
                icon: Icons.graphic_eq_rounded,
                color: AppTheme.warningOrange,
                gradient: [
                  AppTheme.warningOrange.withOpacity(0.2),
                  AppTheme.warningOrange.withOpacity(0.05),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Cry Detection',
          count: controller.cryAlerts.length,
          icon: Icons.child_care_rounded,
          color: AppTheme.accentPink,
          gradient: [
            AppTheme.accentPink.withOpacity(0.2),
            AppTheme.accentPink.withOpacity(0.05),
          ],
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required List<Color> gradient,
    bool isFullWidth = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.all(isFullWidth ? 18 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: isFullWidth
              ? Row(
            children: [
              _buildStatIcon(icon, color),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    count.toString(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildAlertBadge(count, color),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatIcon(icon, color),
                  _buildAlertBadge(count, color),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                count.toString(),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildAlertBadge(int count, Color color) {
    if (count == 0) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withOpacity(0.2),
      ),
      child: Text(
        count > 0 ? 'ACTIVE' : 'CLEAR',
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProximitySection(SafetyMonitoringController controller) {
    return _buildAlertSection(
      title: 'Proximity Alerts',
      icon: Icons.near_me_rounded,
      color: AppTheme.warningRed,
      alerts: controller.proximityAlerts,
      controller: controller,
    );
  }

  Widget _buildSoundHazardSection(SafetyMonitoringController controller) {
    return _buildAlertSection(
      title: 'Sound Hazard Alerts',
      icon: Icons.graphic_eq_rounded,
      color: AppTheme.warningOrange,
      alerts: controller.soundAlerts,
      controller: controller,
    );
  }

  Widget _buildCryDetectionSection(SafetyMonitoringController controller) {
    return _buildAlertSection(
      title: 'Cry Detection Alerts',
      icon: Icons.child_care_rounded,
      color: AppTheme.accentPink,
      alerts: controller.cryAlerts,
      controller: controller,
    );
  }

  Widget _buildAlertSection({
    required String title,
    required IconData icon,
    required Color color,
    required RxList<Map<String, dynamic>> alerts,
    required SafetyMonitoringController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color.withOpacity(0.1),
              ),
              child: Text(
                '${alerts.length}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Alerts List
        Obx(() => alerts.isEmpty
            ? _buildEmptyState(title.toLowerCase())
            : Column(
          children: alerts.map((alert) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAlertCard(
              alert: alert,
              color: color,
              icon: icon,
              controller: controller,
            ),
          )).toList(),
        )),
      ],
    );
  }

  Widget _buildAlertCard({
    required Map<String, dynamic> alert,
    required Color color,
    required IconData icon,
    required SafetyMonitoringController controller,
  }) {
    final isActive = (alert['status'] ?? '').toString().toLowerCase() == 'active';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.12),
                color.withOpacity(0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(isActive ? 0.4 : 0.2),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alert Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.2),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert['message'] ?? 'Alert',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${alert['id'] ?? 'Unknown'}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isActive
                          ? color.withOpacity(0.2)
                          : AppTheme.successGreen.withOpacity(0.15),
                      border: Border.all(
                        color: isActive
                            ? color.withOpacity(0.4)
                            : AppTheme.successGreen.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? color : AppTheme.successGreen,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isActive ? 'ACTIVE' : 'RESOLVED',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isActive ? color : AppTheme.successGreen,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Enhanced Time Information Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.08),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  border: Border.all(
                    color: color.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    // Time Icon & Value
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: color.withOpacity(0.15),
                      ),
                      child: Icon(
                        Icons.access_time_filled_rounded,
                        size: 16,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert['exactTime'] ?? '--:--:--',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.formatTimestamp(alert['timestamp'] ?? 0),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: color.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Date Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatShortDate(alert['timestamp'] ?? 0),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
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

  String _formatShortDate(int timestamp) {
    if (timestamp == 0) return 'N/A';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM d').format(date);
  }

  Widget _buildEmptyState(String type) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.successGreen.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 28,
                  color: AppTheme.successGreen.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'All Clear',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'No $type at the moment',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Grid Pattern Painter
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}