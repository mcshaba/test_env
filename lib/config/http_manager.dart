import 'package:dio/dio.dart';
import 'package:envision_test/ocr/data/model/error_response.dart';
import 'package:envision_test/util/constant.dart';

enum Error { NOT_AUTHORIZED }

String dioErrorHandle(DioError error) {
  String errorDescription = "";

  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.cancel:
        errorDescription =
            "Request to API server was cancelled \n Kindly check your internet connection and try again";
        return errorDescription;
      case DioErrorType.connectTimeout:
        errorDescription =
            "Connection timeout with API server \n Kindly check your internet connection and try again";
        return errorDescription;

      case DioErrorType.sendTimeout:
        errorDescription =
            "Send timeout in connection with API server \n Kindly check your internet connection and try again";
        return errorDescription;
      case DioErrorType.receiveTimeout:
        errorDescription =
            "Sorry, there are No Buses available on this route \n Kindly check your internet connection and try again";

        return errorDescription;
      case DioErrorType.response:
        ErrorResponse errors = errorResponseFromJson(error.response.data);

        if (error.response?.statusCode == 401) {
          errorDescription = "Your Session expired. Kindly login again.";
          return errorDescription;
        }
        if (error.response?.statusCode == 400) {
          errorDescription = errors.message;
          return errorDescription;
        } else {
          errorDescription = "Sorry, there are No Data available at this time";
          return errorDescription;
        }
        break;
      case DioErrorType.other:
        errorDescription =
            "Slow or no internet connection. Please check your internet settings and try again.";
        return errorDescription;

      default:
        return "Unexpected error occurred";
    }
  } else {
    errorDescription = "Unexpected error occurred";
    return errorDescription;
  }
}

class HTTPManager {
  BaseOptions baseOptions = BaseOptions(
    baseUrl: Constant.BASE_URL,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    headers: {},
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );

  ///Post method
  Future<dynamic> post({
    String url,
    data,
    Options options,
  }) async {
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.post(
        url,
        data: data,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }


  ///Get method
  Future<dynamic> get({
    String url,
    Map<String, dynamic> params,
    Options options,
  }) async {
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.get(
        url,
        queryParameters: params,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }

  factory HTTPManager() {
    return HTTPManager._internal();
  }

  HTTPManager._internal();
}

HTTPManager httpManager = HTTPManager();
