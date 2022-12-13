import 'package:flutter/material.dart';
import 'package:kateringku_mobile/screens/dashboard/dashboard_view.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PersistentTabController _controller;

  int _selectedIndex = 0;
  List pages = [
    Container(
      child: const Center(
        child: Text('Dashboard'),
      ),
    ),
    Container(
      child: const Center(
        child: Text('Keranjang'),
      ),
    ),
    Container(
      child: const Center(
        child: Text('Pesanan'),
      ),
    ),
    Container(
      child: const Center(
        child: Text('Akun'),
      ),
    ),
  ];

  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardView(),
      Container(
        child: const Center(
          child: Text('Keranjang'),
        ),
      ),
      Container(
        child: const Center(
          child: Text('Pesanan'),
        ),
      ),
      Container(
        child: const Center(
          child: Text('Akun'),
        ),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: ("Beranda"),
        activeColorPrimary: AppTheme.primaryOrange,
        inactiveColorPrimary: AppTheme.secondaryBlack.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_cart_outlined),
        title: ("Keranjang"),
        activeColorPrimary: AppTheme.primaryOrange,
        inactiveColorPrimary: AppTheme.secondaryBlack.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.feed_outlined),
        title: ("Pesanan"),
        activeColorPrimary: AppTheme.primaryOrange,
        inactiveColorPrimary: AppTheme.secondaryBlack.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        title: ("Akun"),
        activeColorPrimary: AppTheme.primaryOrange,
        inactiveColorPrimary: AppTheme.secondaryBlack.withOpacity(0.6),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      padding: const NavBarPadding.only(bottom: 12, top: 10),
      navBarHeight: 74,
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(2.0),
        colorBehindNavBar: Colors.white,
        boxShadow: <BoxShadow>[
          const BoxShadow(
              color: Color.fromARGB(135, 158, 158, 158),
              blurRadius: 7.0,
              offset: Offset(0.0, 0.75))
        ],
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style14, // Choose the nav bar style with this property.
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: pages[_selectedIndex],
  //     bottomNavigationBar: SizedBox(
  //       height: 68,
  //       child: BottomNavigationBar(
  //           backgroundColor: Colors.white,
  //           selectedFontSize: 11,
  //           unselectedFontSize: 11,
  //           selectedLabelStyle: AppTheme.textTheme.labelSmall,
  //           unselectedItemColor: AppTheme.secondaryBlack.withOpacity(0.6),
  //           type: BottomNavigationBarType.fixed,
  //           elevation: 10,
  //           currentIndex: _selectedIndex,
  //           onTap: onTapNav,
  //           enableFeedback: true,
  //           items: const [
  //             BottomNavigationBarItem(
  //                 icon: Icon(Icons.home_outlined), label: "Beranda"),
  //             BottomNavigationBarItem(
  //                 icon: Icon(Icons.shopping_cart_outlined), label: "Keranjang"),
  //             BottomNavigationBarItem(
  //                 icon: Icon(Icons.feed_outlined), label: "Pesanan"),
  //             BottomNavigationBarItem(
  //                 icon: Icon(Icons.person_outline), label: "Akun"),
  //           ],
  //           selectedItemColor: AppTheme.primaryOrange),
  //     ),
  //   );
  // }
}
