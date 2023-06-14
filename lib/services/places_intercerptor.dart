import 'package:dio/dio.dart';
import 'package:sig_app/services/api_end_points.dart';


class PlacesInterceptor extends Interceptor {
  
  final accessToken = mapboxAccessToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
    });


    super.onRequest(options, handler);
  }

}
