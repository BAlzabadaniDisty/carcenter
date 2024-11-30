import 'package:carcenter/provider/AreaProvider.dart';
import 'package:carcenter/provider/AskForExpertProvider.dart';
import 'package:carcenter/provider/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'home.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
return MultiProvider(
providers: [
ChangeNotifierProvider<ReservationProvider>(create: (_) => ReservationProvider()), // AreaProvider
  ChangeNotifierProvider<AreaProvider>(create: (_) => AreaProvider()), //AskForExpertProvider
  ChangeNotifierProvider<AskForExpertProvider>(create: (_) => AskForExpertProvider()), //
],
child: GetMaterialApp(
title: 'Car Center',
debugShowCheckedModeBanner: false,
home:HomePage(),
),
);
  }
}


