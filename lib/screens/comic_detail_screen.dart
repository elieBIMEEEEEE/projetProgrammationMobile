import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comic Detail',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF1D272E),
        scaffoldBackgroundColor: Color(0xFF1D272E),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1D272E),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: TextStyle(fontFamily: 'Nunito'), // Style pour les onglets sélectionnés
          unselectedLabelStyle: TextStyle(fontFamily: 'Nunito'), // Style pour les onglets non sélectionnés
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFFF8200), //Orange pour marqueurs
                width: 3.0,
              ),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
          bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
        ),
      ),
      home: ComicDetailPage(),
    );
  }
}

class ComicDetailPage extends StatefulWidget {
  @override
  _ComicDetailPageState createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends State<ComicDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            title: Text('The Silver Surfer', // Titre en haut à gauche
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                return Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'assets/images/silver.png', //A connecter à l'API
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 4), // Espace entre les textes
                                  Text(
                                    'In the Hands of... Mephisto!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  SizedBox(height: 16), // Espace entre les textes
                                  Text(
                                    'N°16',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  Text(
                                    'Mai 1970',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: top < 120.0 ? 35.0 : top - 80, // Positions en fonction du scrolling
                      left: 16.0,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: top < 120.0 ? 0.0 : 1.0,
                      ),
                    ),
                  ],
                );
              },
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),

            actions: <Widget>[
            ],
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Histoire'),
                  Tab(text: 'Auteurs'),
                  Tab(text: 'Personnages'),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContentTab(context, 'Histoire content here'),
                _buildContentTab(context, 'Auteurs content here'),
                _buildContentTab(context, 'Personnages content here'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab(BuildContext context, String content) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Color(0xFF1E3243), // Fond
        child: Text(
          content,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xFF1D272E), 
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

