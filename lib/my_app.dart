import 'package:asn1/bloc/control/control_bloc.dart';
import 'package:asn1/ui/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASN1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 77, 197)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => ControlBloc(),
        child: const Layout(),
      ),
    );
  }
}
