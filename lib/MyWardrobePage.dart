import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p13/cubit/cubit/fetch_undertone_cubit.dart';

import 'Category.dart';
import 'main.dart';

class MyWardrobePage extends StatelessWidget {
  const MyWardrobePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchUndertoneCubit, FetchUndertoneState>(
      builder: (context, state) {
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
                  'MY WARDROBE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
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
                  child: state is FetchUndertonehasData ?  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.memory(
                          height: MediaQuery.sizeOf(context).height * 0.4,
                          BlocProvider.of<FetchUndertoneCubit>(context).value!.image!),
                      const Text(
                        'Your Wardrobe',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )):
                   Center(
                    child: Text(
                      'There Is No Wardrobe Store Yet..',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); //
    path.lineTo(0, size.height - 30); //
    path.quadraticBezierTo(size.width / 2, size.height + 30, size.width,
        size.height - 30); // إنشاء الانحناء للأسفل
    path.lineTo(size.width, 0); //
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //
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

class TabBarItem {
  final IconData icon;
  final String label;
  final Widget page;

  TabBarItem(this.icon, this.label, this.page);
}

class Wardrobe extends StatefulWidget {
  const Wardrobe({super.key});

  @override
  _WardrobeState createState() => _WardrobeState();
}

class _WardrobeState extends State<Wardrobe> {
  final PageController _pageController = PageController(initialPage: 2);

  int indexTap = 0;

  List<TabBarItem> tabItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabItems = [];
    tabItems.add(TabBarItem(Icons.home, "", const Categoryy()));
    tabItems.add(TabBarItem(Icons.camera_alt, "", const TestColorNew()));
    tabItems.add(TabBarItem(Icons.checkroom, "", const MyWardrobePage()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabItems.length,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _getChildrenTabBar(),
          onPageChanged: (index) {
            setState(() {
              indexTap = index;
            });
          },
        ),
      ),
    );
  }

  List<Widget> _getChildrenTabBar() {
    List<Widget> items = [];
    for (var item in tabItems) {
      items.add(item.page);
    }
    return items;
  }

  List<BottomNavigationBarItem> _renderTaps() {
    List<BottomNavigationBarItem> items = [];

    for (var i = 0; i < tabItems.length; i++) {
      BottomNavigationBarItem obj = BottomNavigationBarItem(
          icon: Icon(
            tabItems[i].icon,
            color:
                indexTap == i ? Theme.of(context).primaryColor : Colors.black26,
          ),
          label: tabItems[i].label);
      items.add(obj);
    }
    return items;
  }
}
