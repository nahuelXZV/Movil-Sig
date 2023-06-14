import 'package:dio/dio.dart';
import 'package:sig_app/services/api_end_points.dart';


class TrafficInterceptor extends Interceptor {

  final accessToken = mapboxAccessToken;
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accessToken
    });


    super.onRequest(options, handler);
  }


}
