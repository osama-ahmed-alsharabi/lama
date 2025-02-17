import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p13/cubit/cubit/fetch_undertone_cubit.dart';
import 'package:p13/cubit/undertone_cubit.dart';
import 'package:p13/model/undertone_model.dart';
import 'package:p13/selfie.dart';

import 'Category.dart';

class UNDERTONE extends StatefulWidget {
  final UndertoneModel? undertoneModel;
  const UNDERTONE({super.key, this.undertoneModel});

  @override
  State<UNDERTONE> createState() => _UNDERTONEState();
}

class _UNDERTONEState extends State<UNDERTONE> {
  @override
  void initState() {
    super.initState();
  }

  // Define the showAlertDialog function outside the onPressed callback
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'IF You Delete The Undertone everything will be Delete it'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                print('User clicked Cancel');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                BlocProvider.of<FetchUndertoneCubit>(context).value!.delete();
                BlocProvider.of<FetchUndertoneCubit>(context).fetch();

                Navigator.of(context).pop();
                print('User clicked OK');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UndertoneModel? undertoneModell =
        BlocProvider.of<FetchUndertoneCubit>(context).fetch();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFCCB90),
                    Color(0xFFE6A0C3),
                    Color(0xFFD57EEB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Text(
              'MY UNDERTONE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<FetchUndertoneCubit, FetchUndertoneState>(
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFFFF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              ClipPath(
                clipper: CustomBodyClipper(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state is FetchUndertonehasData
                              ? "Your Undertone is ${BlocProvider.of<FetchUndertoneCubit>(context).value!.season}"
                              : 'There Is No Undertone Store Yet..',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // ملاحظة: لا حاجة للزر هنا
                      ],
                    ),
                  ),
                ),
              ),
              // وضع الزر في أسفل الصفحة
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 50.0), // ضبط المسافة من الأسفل
                  child: ElevatedButton(
                    onPressed: () {
                      if (state is FetchUndertonehasData) {
                        // Show the alert dialog
                        _showAlertDialog(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Selfie()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6A0C3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      state is FetchUndertonehasData
                          ? "Delete Undertone"
                          : 'Detect Undertone',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height + 30, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomBodyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
 
/*Align(
  alignment: Alignment.bottomCenter,
  child: Padding(
    padding: const EdgeInsets.only(bottom: 50.0), // ضبط المسافة من الأسفل
    child: ElevatedButton(
      onPressed: () {
        if (state is FetchUndertonehasData) {
          // Show the alert dialog
          _showAlertDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Selfie()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE6A0C3),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        state is FetchUndertonehasData ? "Delete Undertone" : 'Detect Undertone',
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    ),
  ),
);

// Define the showAlertDialog function outside the onPressed callback
void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert!'),
        content: const Text('This is an alert dialog. Do you want to proceed?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              print('User clicked Cancel');
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              print('User clicked OK');
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
} */