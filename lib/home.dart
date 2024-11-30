import 'dart:async';
import 'package:carcenter/screens/ReservationFormPage.dart';
import 'package:carcenter/screens/ask_for_expert_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant/color.dart';
import 'constant/images.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation1;
  late Animation<Offset> _animation2;
  late Timer _timer;
  int _currentColorIndex = 0;
  final List<Color> _buttonColors = [
    bottomDarkBack,
    secondaryColor,
    filedcolor,
    basketadd,
    loginGradientStart,
    butnnav,
    notverifiedtextcolors,
    scaffoldDarkBack2,
    successGreen,
    Thintextcolor
  ];
  @override
  void initState() {
    super.initState();
    // بدء المؤقت لتغيير الألوان كل ثانيتين
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentColorIndex = (_currentColorIndex + 1) % _buttonColors.length;
      });
    });
    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Slide animations
    _animation1 = Tween<Offset>(
      begin: const Offset(-1, 0), // Slide in from left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _animation2 = Tween<Offset>(
      begin: const Offset(1, 0), // Slide in from right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية' ,
          style: GoogleFonts.amiri(fontSize: 28,
            fontWeight: FontWeight.bold,
            color: white
        ),),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // لون شريط التطبيق
      ),
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _animation1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for "حجز موعد"
                      Navigator.push(context,
    MaterialPageRoute(builder: (context) => ReservationFormPage(),));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColors[(_currentColorIndex + 1) % _buttonColors.length],
                      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'حجز موعد',
                      style: GoogleFonts.amiri(fontSize: 24,
                       fontWeight: FontWeight.bold,
                        color: white
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Spacing between buttons
                SlideTransition(
                  position: _animation2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AskForExpertFormPage(),));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 22),
                      backgroundColor: _buttonColors[_currentColorIndex],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'اطلب خبير',
                      style: GoogleFonts.amiri(fontSize: 24,
                          fontWeight: FontWeight.bold,
                        color: white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}