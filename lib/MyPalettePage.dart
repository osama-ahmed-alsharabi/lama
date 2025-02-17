import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p13/cubit/cubit/fetch_undertone_cubit.dart';
import 'Category.dart';
import 'UNDERTONE.dart';
import 'TestColorPage.dart';
import 'MyPalettePage.dart';
import 'MyWardrobePage.dart';

class TabBarItem {
  final IconData icon;
  final String label;
  final Widget page;

  TabBarItem(this.icon, this.label, this.page);
}

class PaletteScreen extends StatefulWidget {
  const PaletteScreen({super.key});

  @override
  _PaletteScreenState createState() => _PaletteScreenState();
}

class _PaletteScreenState extends State<PaletteScreen> {
  final PageController _pageController = PageController(initialPage: 3);
  int indexTap = 3;

  List<TabBarItem> tabItems = [];

  @override
  void initState() {
    super.initState();
    tabItems = [
      TabBarItem(Icons.home, "Home", const Categoryy()),
      TabBarItem(Icons.face, "Undertone", const UNDERTONE()),
      TabBarItem(Icons.check, "Test", TestColorPage()),
      TabBarItem(
          Icons.palette, "Palette", const MyPalettePage()), // الصفحة الحالية
      TabBarItem(Icons.checkroom, "Wardrobe", const Wardrobe()),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _getChildrenTabBar(),
        onPageChanged: (index) {
          setState(() {
            indexTap = index;
          });
        },
      ),
    );
  }

  List<Widget> _getChildrenTabBar() {
    return tabItems.map((item) => item.page).toList();
  }

  List<BottomNavigationBarItem> _renderTaps() {
    return List.generate(tabItems.length, (i) {
      return BottomNavigationBarItem(
        icon: Icon(
          tabItems[i].icon,
          color: indexTap == i ? Colors.pink.shade300 : Colors.black26,
        ),
        label: tabItems[i].label,
      );
    });
  }
}

class MyPalettePage extends StatelessWidget {
  const MyPalettePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              "My Palette",
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
      body: BlocBuilder<FetchUndertoneCubit, FetchUndertoneState>(
        builder: (context, state) {
          return Stack(
            children: [
              state is FetchUndertonehasData
                  ? Center(
                      child: Image.asset(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          "new_images/${BlocProvider.of<FetchUndertoneCubit>(context).value!.season}.jpg"))
                  :
                  // خلفية التدرج اللوني
                  // Container(
                  //   width: MediaQuery.sizeOf(context).width * 0.5,
                  //   height: MediaQuery.sizeOf(context).width * 0.5,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(
                  //         (MediaQuery.sizeOf(context).width * 0.5) / 2),
                  //     gradient: const LinearGradient(
                  //       colors: [
                  //         Color(0xFFD32F2F),
                  //         Color(0xFFC2185B),
                  //         Color(0xFF1976D2),
                  //         Color(0xFF64B5F6),
                  //         Color(0xFFFDD835),
                  //         Color(0xFF303F9F),
                  //         Color(0xFF455A64),
                  //         Color(0xFF212121),
                  //       ],
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //     ),
                  //   ),
                  // ),
                  const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "There Is No PALETTE Store Yet..",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
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
