import 'package:flutter/material.dart';
import 'package:peliculas/providers/movie_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
 
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon: Icon( Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView( // para agregar mas widgets sin tener problemas
        child: Column(
        children: [
          // Tarjetas principales
          CardSwiper( movies: moviesProvider.onDisplayMovies ),

          // Slider de peliculas
          MovieSlider(
            movies:moviesProvider.popularMovies,
            title: 'Populares',
            onNextPage: () => moviesProvider.getPopularMovies(),
          ),
        ],
      ),
      )
    );
  }
}