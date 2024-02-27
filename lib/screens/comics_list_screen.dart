import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/comic_bloc.dart';
import '../repositories/comic_repository.dart';

class ComicsListScreen extends StatelessWidget {
  const ComicsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComicBloc(comicRepository: ComicRepository())..add(FetchComics()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Comics List")),
        body: BlocBuilder<ComicBloc, ComicState>(
          builder: (context, state) {
            if (state is ComicLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComicsLoaded) {
              return ListView.builder(
                itemCount: state.comics.length,
                itemBuilder: (context, index) {
                  final comic = state.comics[index];
                  return ListTile(
                    title: Text(comic.name),
                    subtitle: Text("Issue Number: ${comic.issueNumber}"),
                    leading: comic.imageUrl.isNotEmpty ? Image.network(comic.imageUrl) : null,
                  );
                },
              );
            } else if (state is ComicError) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text("Fetch Comics by dispatching FetchComics Event"));
          },
        ),
      ),
    );
  }
}
