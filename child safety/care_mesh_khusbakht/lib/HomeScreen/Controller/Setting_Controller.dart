import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Services/Auth_Service.dart';
import '../../Services/Notification_service.dart';
import '../../Auth_Screens/Login/Login_Ui.dart';

class OutroController extends GetxController with GetTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // User data
  var currentUser = Rxn<User>();
  var isLoading = false.obs;
  var fullName = ''.obs;
  var phoneNumber = ''.obs;
  var email = ''.obs;
  var memberSince = ''.obs;

  // Animation controllers
  late AnimationController mainController;
  late AnimationController pulseController;
  late AnimationController swipeHintController;

  // Animations
  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;
  late Animation<double> pulseAnimation;
  late Animation<double> swipeHintAnimation;

  // Swipe state
  var swipeProgress = 0.0.obs;
  var isSwipeComplete = false.obs;
  var showSwipeHint = true.obs;
  var isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
    _loadCurrentUser();
    _loadUserData();
  }

  void _initializeAnimations() {
    mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    swipeHintController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: pulseController,
      curve: Curves.easeInOut,
    ));

    swipeHintAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: swipeHintController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    mainController.forward();
    pulseController.repeat(reverse: true);
    swipeHintController.repeat(reverse: true);
  }

  void _loadCurrentUser() {
    currentUser.value = _auth.currentUser;
    email.value = currentUser.value?.email ?? 'Not available';
  }

  Future<void> _loadUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final snapshot = await _database.ref().child('users/$userId').get();
        if (snapshot.exists) {
          final userData = Map<String, dynamic>.from(snapshot.value as Map);

          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';

          if (firstName.isNotEmpty && lastName.isNotEmpty) {
            fullName.value = '$firstName $lastName';
          } else if (firstName.isNotEmpty) {
            fullName.value = firstName;
          } else if (userData['fullName'] != null && userData['fullName'].toString().isNotEmpty) {
            fullName.value = userData['fullName'];
          } else {
            fullName.value = 'User';
          }

          phoneNumber.value = userData['phone'] ?? 'Not provided';

          if (userData['createdAt'] != null) {
            final createdAt = DateTime.fromMillisecondsSinceEpoch(userData['createdAt'] as int);
            memberSince.value = '${_getMonthName(createdAt.month)} ${createdAt.year}';
          } else {
            memberSince.value = 'Recently joined';
          }

          print('✅ User data loaded successfully');
        } else {
          print('⚠️ No user data found in database');
          fullName.value = 'User';
          phoneNumber.value = 'Not provided';
          memberSince.value = 'Recently joined';
        }
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      fullName.value = 'User';
      phoneNumber.value = 'Not provided';
      memberSince.value = 'Recently joined';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  void updateSwipeProgress(double progress) {
    swipeProgress.value = progress.clamp(0.0, 1.0);
    showSwipeHint.value = false;

    if (progress >= 0.85 && !isSwipeComplete.value) {
      isSwipeComplete.value = true;
      _performLogout();
    }
  }

  void resetSwipe() {
    if (!isSwipeComplete.value) {
      swipeProgress.value = 0.0;
      showSwipeHint.value = true;
    }
  }

  Future<void> _performLogout() async {
    try {
      isLoggingOut.value = true;
      print('🔌 Turning off IoT device and logging out...');

      Get.snackbar(
        '🔌 Turning Off IoT Device',
        'Disconnecting from ESP32 sensors...',
        backgroundColor: const Color(0xFFF59E0B).withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.sensors_off_rounded, color: Colors.white),
      );

      await Future.delayed(const Duration(seconds: 2));

      final user = _auth.currentUser;

      if (user != null) {
        print('📝 Updating user offline status...');
        await _database.ref().child('user_profiles').child(user.uid).update({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
        print('✅ User offline status updated');
      }

      print('🔐 Signing out from Firebase...');
      await _auth.signOut();
      print('✅ Firebase sign out successful');

      final authService = AuthService();
      await authService.clearUserSession();
      print('✅ User session cleared');

      await NotificationService.cancelAllNotifications();
      print('✅ Notifications cancelled');

      Get.snackbar(
        '✅ IoT Device Turned Off',
        'You have been logged out successfully',
        backgroundColor: const Color(0xFF10B981).withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      print('🔄 Navigating to login...');
      Get.offAll(
            () => const LoginScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );

      print('✅ Logout completed successfully');
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error during logout: $e');
      isSwipeComplete.value = false;
      swipeProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.message}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF43F5E).withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Unexpected error during logout: $e');
      isSwipeComplete.value = false;
      swipeProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF43F5E).withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  List<Color> getBackgroundGradientColors() {
    return [
      const Color(0xFF0A1628),
      const Color(0xFF162447),
      const Color(0xFF1F4068),
      const Color(0xFF1E3A5F),
    ];
  }

  List<Color> getCardGradient() {
    return [
      const Color(0xFF60A5FA).withOpacity(0.12),
      const Color(0xFF3B82F6).withOpacity(0.06),
    ];
  }

  List<Color> getSwipeButtonGradient() {
    return [
      const Color(0xFFF43F5E),
      const Color(0xFFFF6B8A),
    ];
  }

  Color getAccentColor() => const Color(0xFF60A5FA);
  Color getPrimaryColor() => const Color(0xFF3B82F6);
  Color getWarningColor() => const Color(0xFFF43F5E);

  // ============================================
  // TEST NOTIFICATION METHODS
  // ============================================

  Future<void> testProximityNotification() async {
    try {
      print('🧪 Testing Proximity Notification...');
      await NotificationService.showProximityAlert(
        message: '⚠️ TEST ALERT: Child is moving away from safe zone!\n📍 Distance: 15 meters\n🔔 This is a test notification.',
        alertId: 'test_proximity_${DateTime.now().millisecondsSinceEpoch}',
      );
      _showSuccessSnackbar('Proximity Alert', 'Test notification sent!');
    } catch (e) {
      print('❌ Error testing proximity notification: $e');
      _showErrorSnackbar('Failed to send test notification');
    }
  }

  Future<void> testSoundHazardNotification() async {
    try {
      print('🧪 Testing Sound Hazard Notification...');
      await NotificationService.showSoundHazardAlert(
        message: '🔊 TEST ALERT: Loud noise detected near child!\n📢 Sound Level: 95 dB\n🔔 This is a test notification.',
        alertId: 'test_sound_${DateTime.now().millisecondsSinceEpoch}',
      );
      _showSuccessSnackbar('Sound Hazard Alert', 'Test notification sent!');
    } catch (e) {
      print('❌ Error testing sound hazard notification: $e');
      _showErrorSnackbar('Failed to send test notification');
    }
  }

  Future<void> testCryDetectionNotification() async {
    try {
      print('🧪 Testing Cry Detection Notification...');
      await NotificationService.showCryDetectionAlert(
        message: '👶 TEST ALERT: Baby crying detected!\n😢 Cry Confidence: 92%\n🔔 This is a test notification.',
        alertId: 'test_cry_${DateTime.now().millisecondsSinceEpoch}',
      );
      _showSuccessSnackbar('Cry Detection Alert', 'Test notification sent!');
    } catch (e) {
      print('❌ Error testing cry detection notification: $e');
      _showErrorSnackbar('Failed to send test notification');
    }
  }

  Future<void> testAllNotifications() async {
    try {
      print('🧪 Testing All Notifications...');

      await testProximityNotification();
      await Future.delayed(const Duration(seconds: 2));

      await testSoundHazardNotification();
      await Future.delayed(const Duration(seconds: 2));

      await testCryDetectionNotification();

      print('✅ All test notifications sent');
    } catch (e) {
      print('❌ Error testing all notifications: $e');
      _showErrorSnackbar('Failed to send test notifications');
    }
  }

  // ============================================
  // DELETE ALERTS METHODS
  // ============================================

  Future<void> deleteAllAlerts() async {
    try {
      isLoading.value = true;
      print('🗑️ Deleting all alerts from Firebase...');

      // Delete Proximity Alerts
      await _database.ref().child('alarms/proximity_alert').remove();
      print('✅ Proximity alerts deleted');

      // Delete Sound Hazard Alerts
      await _database.ref().child('alarms/sound_hazard_alert').remove();
      print('✅ Sound hazard alerts deleted');

      // Delete Cry Detection Alerts
      await _database.ref().child('alarms/cry_detection').remove();
      print('✅ Cry detection alerts deleted');

      isLoading.value = false;
      _showSuccessSnackbar('Success', 'All alerts have been deleted!');

    } catch (e) {
      isLoading.value = false;
      print('❌ Error deleting alerts: $e');
      _showErrorSnackbar('Failed to delete alerts: $e');
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      print('🔕 Clearing all notifications...');
      await NotificationService.cancelAllNotifications();
      _showSuccessSnackbar('Success', 'All notifications cleared!');
    } catch (e) {
      print('❌ Error clearing notifications: $e');
      _showErrorSnackbar('Failed to clear notifications');
    }
  }

  Future<void> resetAppData() async {
    try {
      isLoading.value = true;
      print('🔄 Resetting app data...');

      // Clear notifications
      await NotificationService.cancelAllNotifications();

      // You can add more reset logic here:
      // - Clear shared preferences
      // - Clear local database
      // - Reset app state

      isLoading.value = false;
      _showSuccessSnackbar('Success', 'App data has been reset!');

    } catch (e) {
      isLoading.value = false;
      print('❌ Error resetting app data: $e');
      _showErrorSnackbar('Failed to reset app data');
    }
  }

  // ============================================
  // SNACKBAR HELPERS
  // ============================================

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981).withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFF43F5E).withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(
        Icons.error_rounded,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    mainController.dispose();
    pulseController.dispose();
    swipeHintController.dispose();
    print('🧹 OutroController disposed');
    super.onClose();
  }
}