

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';




class MoviesProvider extends ChangeNotifier{

  String _baseUrl = 'api.themoviedb.org';
  String _apikey = 'c8f59f25c9722e762037a480f7d9e27f';
  String _language = 'es-Es';

  List<Movie>onDisplayMovies = [];
  List<Movie>popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider(){

    print('MoviesProvider inicializando');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String>_getJsonData( String endpoint, [int page = 1] ) async {
    final url = Uri.https( this._baseUrl, endpoint, {
      'api_key': _apikey,
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    
  
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage++;

    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    
  
    popularMovies = [ ...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast( int movieId ) async {

    if( moviesCast.containsKey(movieId )) return moviesCast[movieId]!;

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditResponse.fromJson(jsonData );

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( this._baseUrl, '3/search/movie', {
      'api_key': _apikey,
      'language': _language,
      'query': query,
    });

    final response = await http.get(url);
    final search_response = SearchResponse.fromJson( response.body );

    return search_response.results;
  }
}