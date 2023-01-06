import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncers.dart';
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '6f2d426db78ae9a81fb5c13b5f7986fa';
  final String _lenguage = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  MoviesProvider() {
    // print('MoviesProvider inciializado');
    getOnNowPlayingMovies();
    getPopularMovies();
  }
  Future<String> getJsonData(String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endPoint,
        {'api_key': _apiKey, 'language': _lenguage, 'page': '$page'});
    final response = await http.get(url);
    return response.body;
  }

  getOnNowPlayingMovies() async {
    //print('getOnDisplaymovies');
    // var url = Uri.https(_baseUrl, '/3/movie/now_playing',{'api_key': _apiKey, 'languague': _lenguage, 'page': '1'});

    // Await the http get response, then decode the json-formatted response.
    // var response = await http.get(url);
    // final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
    // final Map<String, dynamic> decodeData = json.decode(response.body);
    // print(nowPlayingResponse.results[1].title);
    _popularPage++;
    final jsonData = await getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;

    // print(onDisplayMovies[0].fullPosterImg);
    notifyListeners();
  }

  getPopularMovies() async {
    // var url = Uri.https(_baseUrl, '/3/movie/popular',
    //     {'api_key': _apiKey, 'languague': _lenguage, 'page': '1'});
    // var response = await http.get(url);
    // final popularResponse = PopularResponse.fromJson(response.body);
    // popularMovies = [...popularMovies, ...popularResponse.results];
    // // print(popularMovies[0]);
    // notifyListeners();
    // print(popularMovies[0]);

    final jsonData = await getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    // print('pidineod info al servidor - cast');
    final jsonData = await getJsonData('/3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _lenguage, 'query': query});
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
