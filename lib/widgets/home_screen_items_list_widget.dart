import 'package:flutter/material.dart';
import 'home_screen_item_widget.dart'; // Assurez-vous que le chemin d'importation est correct

class ItemsListWidget<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Function(int) onViewMorePressed;
  final bool hasVoirPlus;

  const ItemsListWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onViewMorePressed,
    this.hasVoirPlus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E3243), // Couleur de l'arrière-plan des cartes
        borderRadius: BorderRadius.circular(20), // Bords arrondis
      ),
      margin: const EdgeInsets.all(8.0),
      // Marge extérieure pour séparer les éléments
      padding: const EdgeInsets.all(8.0),
      // Padding intérieur
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 4),
            child: Row(
              children: [
                Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF8100),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildVoirPlusButton(),
              ],
            ),
          ),
          SizedBox(
            height: 255,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemWidget(item: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoirPlusButton() {
    if (hasVoirPlus) {
      return InkWell(
        onTap: () => onViewMorePressed(0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: const Color(0xFF0f1921),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Text(
            "Voir plus",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Nunito',
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
