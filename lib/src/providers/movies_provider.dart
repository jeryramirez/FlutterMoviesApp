import 'dart:async';
import 'dart:convert';

import 'package:movies/src/models/actor_model.dart';
import 'package:movies/src/models/movie_model.dart';

import 'package:http/http.dart' as http;



class MoviesProvider {

  String _apikey  = '668f6a9c5378c044a903f499d51e6ce8';
  String _url     = 'api.themoviedb.org';
  String _language = 'en';
  int    _popularPage = 5;

  bool _loading = false;


  //stream definition

  List<Movie> _popular = new List();

  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Movie>> get popularStream => _popularStreamController .stream;

  void disposeStream(){
    _popularStreamController?.close();
  }

  // end stream definition


  Future<List<Movie>> _response(Uri url) async{
    final resp = await http.get( url );

    final decodedData = json.decode(resp.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }
  

  Future<List<Movie>> getNowPlaying() async {


    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apikey,
      'language'  : _language
    });

    return await _response(url);



  }

  Future<List<Movie>> getMorePopular() async {

    if(_loading) return [];

    _loading = true;

    _popularPage++;




    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apikey,
      'language'  : _language,
      'page'      : _popularPage.toString(),
    });

    final resp = await _response(url);

    _popular.addAll(resp);

    popularSink( _popular );


    _loading = false;

    return resp;

  }


  Future<List<Actor>> getCast(String movieId) async {


    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key'   : _apikey,
      'language'  : _language,
    });

    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actors;

  }

  Future<List<Movie>> getSearchMovie(String query) async {


    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   : _apikey,
      'language'  : _language,
      'query'     : query
    });

    return await _response(url);

  }

}