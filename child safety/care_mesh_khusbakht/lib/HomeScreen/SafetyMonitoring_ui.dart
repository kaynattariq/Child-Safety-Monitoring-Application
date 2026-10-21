import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// ============================================================================
// INTEGRATED APP THEME (Extracted from your original App_theme.dart)
// ============================================================================
class LocalAppTheme {
  static const Color primaryDark = Color(0xFF0A1628);
  static const Color primaryMedium = Color(0xFF162447);
  static const Color primaryLight = Color(0xFF1F4068);
  static const Color primaryAccent = Color(0xFF3B82F6);
  static const Color secondaryAccent = Color(0xFF60A5FA);
  static const Color accentCyan = Color(0xFF22D3EE);
  
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningRed = Color(0xFFF43F5E);
  static const Color warningOrange = Color(0xFFF59E0B);

  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Re-implemented decorations matching your original theme look
  static BoxDecoration get containerDecoration => BoxDecoration(
    color: primaryMedium,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: glassBorder,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChildSafetyMonitoringScreen(),
  ));
}

class ChildSafetyMonitoringScreen extends StatefulWidget {
  const ChildSafetyMonitoringScreen({Key? key}) : super(key: key);

  @override
  State<ChildSafetyMonitoringScreen> createState() => _ChildSafetyMonitoringScreenState();
}

class _ChildSafetyMonitoringScreenState extends State<ChildSafetyMonitoringScreen> {
  bool _isMonitoring = true; 

  void _toggleMonitoring(bool value) {
    setState(() {
      _isMonitoring = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uses your premium background colors
      backgroundColor: LocalAppTheme.primaryDark,

      appBar: AppBar(
        title: Text(
          "Child Safety Monitoring",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w600, 
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: LocalAppTheme.primaryMedium,
        centerTitle: true,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: LocalAppTheme.glassBorder, width: 1),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 1. Monitoring Status Card (Styled with premium theme properties)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: LocalAppTheme.containerDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Monitoring Status",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    value: _isMonitoring,
                    activeColor: LocalAppTheme.accentCyan,
                    activeTrackColor: LocalAppTheme.primaryAccent.withOpacity(0.4),
                    inactiveThumbColor: Colors.white60,
                    inactiveTrackColor: Colors.white12,
                    onChanged: (value) {
                      _toggleMonitoring(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Last Updated Section
            Text(
              "Last Update",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: LocalAppTheme.containerDecoration,
              child: Text(
                DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Real-time Device Data Section (Targeting Firestore care_mesh)
            Text(
              "Real-time Device Data",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('care_mesh')
                  .doc('real_time_data')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Something went wrong', 
                      style: GoogleFonts.inter(color: LocalAppTheme.warningRed),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(color: LocalAppTheme.primaryAccent),
                    ),
                  );
                }

                var data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                
                String systemStatus = data['system_status'] ?? 'Normal';
                bool isMotion = data['motion_detected'] ?? false;
                bool isSound = data['sound_detected'] ?? false;
                bool isWet = data['baby_wet'] ?? false;
                bool lightState = data['Light'] ?? false;
                bool warningLightState = data['warning_light'] ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Premium Sensor Status Dashboard Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: LocalAppTheme.containerDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusRow(
                            "System Status", 
                            systemStatus, 
                            textColor: systemStatus == 'Normal' 
                                ? LocalAppTheme.successGreen 
                                : LocalAppTheme.warningRed,
                            isBold: true
                          ),
                          Divider(height: 24, color: LocalAppTheme.glassBorder.withOpacity(0.1)),
                          _buildStatusRow(
                            "Motion Detected", 
                            isMotion ? "YES" : "NO", 
                            textColor: isMotion ? LocalAppTheme.warningOrange : Colors.white60
                          ),
                          Divider(height: 24, color: LocalAppTheme.glassBorder.withOpacity(0.1)),
                          _buildStatusRow(
                            "Sound Detected", 
                            isSound ? "YES" : "NO", 
                            textColor: isSound ? LocalAppTheme.secondaryAccent : Colors.white60
                          ),
                          Divider(height: 24, color: LocalAppTheme.glassBorder.withOpacity(0.1)),
                          _buildStatusRow(
                            "Baby Diaper Wet", 
                            isWet ? "WET ALERT" : "DRY", 
                            textColor: isWet ? LocalAppTheme.warningRed : Colors.white60
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    
                    Text(
                      "Manual Hardware Controls",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Manual Interactive Control Card Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: LocalAppTheme.containerDecoration,
                      child: Column(
                        children: [
                          SwitchListTile(
                            activeColor: LocalAppTheme.accentCyan,
                            activeTrackColor: LocalAppTheme.primaryAccent.withOpacity(0.4),
                            inactiveThumbColor: Colors.white60,
                            inactiveTrackColor: Colors.white12,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Manual Room Light (Light)", 
                              style: GoogleFonts.inter(
                                fontSize: 14, 
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )
                            ),
                            value: lightState,
                            onChanged: (bool val) {
                              FirebaseFirestore.instance
                                  .collection('care_mesh')
                                  .doc('real_time_data')
                                  .update({'Light': val});
                            },
                          ),
                          Divider(color: LocalAppTheme.glassBorder.withOpacity(0.1), height: 1),
                          SwitchListTile(
                            activeColor: LocalAppTheme.warningRed,
                            activeTrackColor: LocalAppTheme.warningRed.withOpacity(0.3),
                            inactiveThumbColor: Colors.white60,
                            inactiveTrackColor: Colors.white12,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Stair Warning Alert (warning_light)", 
                              style: GoogleFonts.inter(
                                fontSize: 14, 
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )
                            ),
                            value: warningLightState,
                            onChanged: (bool val) {
                              FirebaseFirestore.instance
                                  .collection('care_mesh')
                                  .doc('real_time_data')
                                  .update({'warning_light': val});
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: LocalAppTheme.primaryMedium,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              title: Text(
                "Settings", 
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              content: Text(
                "System configurations can be managed here.", 
                style: GoogleFonts.inter(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Close", 
                    style: GoogleFonts.inter(color: LocalAppTheme.accentCyan, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          );
        },
        backgroundColor: LocalAppTheme.primaryAccent,
        child: const Icon(Icons.settings, color: Colors.white),
      ),
    );
  }

  // Row structural layout helper matching exact premium typography guidelines
  Widget _buildStatusRow(String label, String value, {Color textColor = Colors.black, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14, 
            fontWeight: FontWeight.w500, 
            color: Colors.white.withOpacity(0.85),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600, 
            color: textColor,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

// Local wrapper configuration replacement class
class Setting {
  const Setting();
}