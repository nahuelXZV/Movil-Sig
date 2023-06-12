import 'package:dio/dio.dart';


class PlacesInterceptor extends Interceptor {
  
  final accessToken = 'pk.eyJ1IjoiaGVpZHlvbG1vcyIsImEiOiJjbGlzemJ1M2UxYWp3M2Vud2R0YnJpend2In0.YWTndP8jdVSQtUyf0mgqeQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
    });


    super.onRequest(options, handler);
  }

}
