import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projet/screens/movies_list_screen.dart';
import 'package:projet/screens/search_screen.dart';
import 'package:projet/screens/series_list_screen.dart';
import 'package:projet/screens/comics_list_screen.dart';
import 'package:projet/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onViewMorePressed: onItemTapped),
      const SeriesListScreen(),
      const ComicsListScreen(),
      const MoviesListScreen(),
      const SearchScreen(),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0F1E2B),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/navbar_home.svg',
                  color: const Color(0xFF778BA8)),
              activeIcon: SvgPicture.asset('assets/icons/navbar_home.svg',
                  color: const Color(0xFF3284e7)),
              label: 'Accueil',
              backgroundColor: const Color(0xFF0F1E2B),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/navbar_series.svg',
                  color: const Color(0xFF778BA8)),
              activeIcon: SvgPicture.asset('assets/icons/navbar_series.svg',
                  color: const Color(0xFF3284e7)),
              label: 'Séries',
              backgroundColor: const Color(0xFF0F1E2B),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/navbar_comics.svg',
                  color: const Color(0xFF778BA8)),
              activeIcon: SvgPicture.asset('assets/icons/navbar_comics.svg',
                  color: const Color(0xFF3284e7)),
              label: 'Comics',
              backgroundColor: const Color(0xFF0F1E2B),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/navbar_movies.svg',
                  color: const Color(0xFF778BA8)),
              activeIcon: SvgPicture.asset('assets/icons/navbar_movies.svg',
                  color: const Color(0xFF3284e7)),
              label: 'Films',
              backgroundColor: const Color(0xFF0F1E2B),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/navbar_search.svg',
                  color: const Color(0xFF778BA8)),
              activeIcon: SvgPicture.asset('assets/icons/navbar_search.svg',
                  color: const Color(0xFF3284e7)),
              label: 'Recherche',
              backgroundColor: const Color(0xFF0F1E2B),
            ),
          ],
          selectedItemColor: const Color(0xFF3284e7),
          unselectedItemColor: const Color(0xFF778BA8),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Nunito'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Nunito'),
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
        ),
      ),

    );
  }
}
