import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/series_bloc.dart';
import '../repositories/series_repository.dart';

class SeriesListScreen extends StatelessWidget {
  const SeriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = SeriesBloc(seriesRepository: SeriesRepository());
        bloc.add(FetchSeries()); // Déclenche l'événement immédiatement après la création du bloc
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Series List")),
        body: BlocBuilder<SeriesBloc, SeriesState>(
          builder: (context, state) {
            if (state is SeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SeriesLoaded) {
              return ListView.builder(
                itemCount: state.series.length,
                itemBuilder: (context, index) {
                  final series = state.series[index];
                  return ListTile(
                    title: Text(series.name),
                    subtitle: Text("Episodes: ${series.countOfEpisodes}"),
                    // Ajoutez plus de détails ici
                  );
                },
              );
            } else if (state is SeriesError) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text("Fetch Series by dispatching FetchSeriesList Event"));
          },
        ),
      ),
    );
  }
}
