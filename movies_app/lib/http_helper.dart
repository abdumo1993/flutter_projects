import 'package:http/http.dart' as http;
import 'dart:io';
import 'http_helper.dart';
import 'movie.dart';
import 'dart:convert';

class HttpHelper {
  final String urlKey = 'api_key=17abd244c318039834dbf6ab1d0b85f4';
  final String urlBase = 'https://api.themoviedb.org/3/discover/movie/?';
  // 'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc'
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie/550?api_key=[17abd244c318039834dbf6ab1d0b85f4]&query=';

  // Future<List> getUpcoming() async {
  //   final Uri upcomingUri =
  //       Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);

  //   http.Response result = await http.get(upcomingUri);
  //   print("result: ${result}");

  //   try {
  //     if (result.statusCode == HttpStatus.ok) {
  //       final jsonResponse = json.decode(result.body);
  //       final moviesMap = jsonResponse['results'];
  //       List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
  //       return movies;
  //     } else {
  //       throw Exception(
  //           'HTTP request failed with status code ${result.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error getting upcoming events: $e');
  //     return [];
  //   }
  // }
Future<List> getUpcoming() async {
  final Uri upcomingUri =
      Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);
final headers = {
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxN2FiZDI0NGMzMTgwMzk4MzRkYmY2YWIxZDBiODVmNCIsInN1YiI6IjY0NmNmYWJkNTRhMDk4MDBmZWFkMTczMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7pVvOjm0z37bWzBI2xzRKFyhpjbBXv2WdT5uMgLsRqI',

  };

  final http.Response result = await http.get(upcomingUri, headers: headers);
  if (result.statusCode == HttpStatus.ok) {
    final jsonResponse = json.decode(result.body);
    final moviesMap = jsonResponse['results'];
    
    return moviesMap.map((i) => Movie.fromJson(i)).toList();
  } else {

    throw Exception(
        'HTTP request failed with status code ${result.statusCode}');
  }
}

Future<List> findMovies(String title) async {
  const String urlKey = '17abd244c318039834dbf6ab1d0b85f4';
  const String urlBase = 'https://api.themoviedb.org/3/search/movie';
  // 'https://api.themoviedb.org/3/search/movie?query=war&include_adult=false&language=en-US&page=1' 

  try {
    final String query = '$urlBase?api_key=$urlKey&query=$title&language=en-US&page=1';
    // final String query = 'https://api.themoviedb.org/3/movie/550?api_key=17abd244c318039834dbf6ab1d0b85f4'

    final headers = {
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxN2FiZDI0NGMzMTgwMzk4MzRkYmY2YWIxZDBiODVmNCIsInN1YiI6IjY0NmNmYWJkNTRhMDk4MDBmZWFkMTczMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7pVvOjm0z37bWzBI2xzRKFyhpjbBXv2WdT5uMgLsRqI',

  };
    final http.Response result = await http.get(Uri.parse(query), headers: headers);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      print(moviesMap);
      // return moviesMap.map((i) => Movie.fromJson(i)).toList();
      var movies = [];
      for(var movie in moviesMap){
        movie=Movie.fromJson(movie);
        movies.add(movie);
        print(movie);
      }
      return movies;


    } else {
      print('exception printed: \n');
      throw Exception('HTTP request failed with status code ${result.statusCode}');
    }
  } catch (e) {
    print(e);
    return [];
  }
}



}
