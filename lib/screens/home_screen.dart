import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/home_screen_items_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF152630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF152630),
        elevation: 0,
        title: const Text(
          'Bienvenue !',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 26,
        // Aligner le titre à gauche
        centerTitle: false,
      ),
      body: const SafeArea(
        // Utilisation de SafeArea ici
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ItemsListWidget(
                title: 'Séries populaires',
                items: ['Titans', 'Young Justice: Outsiders'],
                color: Color(0xFFFF8100), // Couleur orange pour le carré
              ),
              ItemsListWidget(
                title: 'Comics populaires',
                items: ['The Silver Surfer', 'Wonder Woman'],
                color: Color(0xFFFF8100), // Couleur orange pour le carré
              ),
              ItemsListWidget(
                title: 'Films populaires',
                items: ['Iron Man', 'X-Men'],
                color: Color(0xFFFF8100), // Couleur orange pour le carré
              ),
              // Ajoutez ici d'autres sections selon votre maquette
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0F1E2B),
          // Couleur de fond de la barre
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
              icon: SvgPicture.asset('assets/icons/navbar_comics.svg',
                  color: const Color(0xFF778BA8)),
              activeIcon: SvgPicture.asset('assets/icons/navbar_comics.svg',
                  color: const Color(0xFF3284e7)),
              label: 'Comics',
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
          // Couleur des éléments sélectionnés mise à jour
          unselectedItemColor: const Color(0xFF778BA8),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Nunito'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Nunito'),
        ),
      ),
    );
  }
}
