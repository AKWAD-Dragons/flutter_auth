library fly;

import 'dart:async';

import 'dart:convert';

import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:flutter_auth/support/AppException.dart';
import 'package:flutter_auth/support/GraphQLBuilder.dart';
import 'package:flutter_auth/support/APIManager.dart';

class Fly<T> {
  Fly(this._apiURL,
      {Duration timeout = const Duration(seconds: 3),
      Function onTimeOut,
      Map headers}) {
    _apiManager = APIManager();
    _apiManager.setTimeOut(timeout, onTimeOut: onTimeOut ?? () {});
  }

  APIManager _apiManager;
  String _apiURL;
  final _listBuilder = GetIt.instance<ListBuilder>();


  // Map<String, Parser> parserMap = {};
  Map<String, String> defaultParams = {};

  Future<Map<String, dynamic>> query<W>(
    List<Node> querys, {
    Map<String, dynamic> qParams,
    Map<String, dynamic> parsers,
    String apiURL,
    Map<String, String> parameters,
  }) async {
    Node mainQuery = Node(name: 'query', cols: querys);

    Map queryMap = {
      "operationName": null,
      "variables": {},
      "query": GraphQB(mainQuery).getQueryFor(args: qParams)
    };
    Map<String, dynamic> results = await this.requestWithoutParse(
        query: queryMap, apiUrl: apiURL, parameters: parameters);
    if (parsers != null) {
      try {
        return results.map((key, value) {
          if(value == null){
            return MapEntry(key, null);
          }
          if (value is List) {
            List<dynamic> list = List<dynamic>();
            dynamic type;
            value.forEach((innerValue) {
              type = parsers[key].parse(innerValue);
              list.add(parsers[key].parse(innerValue));
            });
            list = _listBuilder.castListForRuntimeType(type, list);
            return MapEntry(key, list);
          } else {
            return MapEntry(key, parsers[key].parse(value));
          }
        });
      } catch (e) {
        print(e.toString());
        return {};
      }
    }
    return results;
  }

  void addHeaders(Map<String, String> headers) {
    _apiManager.setHeaders(headers);
  }

  Future<Map<String, dynamic>> mutation(
    List<Node> mutations, {
    Map<String, dynamic> qParams,
    Map<String, Parser<T>> parsers,
    String apiURL,
    Map<String, String> parameters,
    Map<String, String> variables,
  }) async {
    Node mainQuery = Node(name: 'mutation', cols: mutations);

    if(variables==null) {
      variables = {};
    }
    Map queryMap = {
      "operationName": null,
      "variables": variables,
      "query": GraphQB(mainQuery).getQueryFor(args: qParams)
    };
    Map<String, dynamic> results = await this.requestWithoutParse(
        query: queryMap, apiUrl: apiURL, parameters: parameters);
    if (parsers == null || parsers.length == 0 || results == null)
      return results;
    return results.map((key, value) {
      if (!parsers.containsKey(key)) return MapEntry(key, value);
      return MapEntry(key, parsers[key].parse(value));
    });
  }

  Future<Map<String, dynamic>> requestWithoutParse(
      {String apiUrl, dynamic query, Map<String, String> parameters}) async {
    if (_apiURL == null && apiUrl == null) {
      throw ("apiUrl is not set! call init or add apiUrl in request");
    }
    if (apiUrl == null) {
      apiUrl = _apiURL;
    }
    if (parameters == null) {
      parameters = defaultParams;
    }

    Response response = await _apiManager.post(
      apiUrl,
      body: jsonEncode(query),
    );
    Map<String, dynamic> myData = json.decode(response.body);

    // has error
    if (myData.containsKey("errors")) {
      String error = myData['errors'][0]['message'];
      String trace = myData['errors'][0]['trace'].toString();
      int code = myData['errors'][0]['extensions']['code'];
      throw AppException(true,
          beautifulMsg: error ?? 'Error occured',
          name: "Server Error",
          code: code,
          uglyMsg: trace);
    }

    return myData['data'];
  }

  Future<T> request({
    String apiUrl,
    dynamic query,
    Map<String, String> parameters,
    Parser<T> parser,
  }) async {
    if (_apiURL == null && apiUrl == null) {
      throw ("apiUrl is not set! call init or add apiUrl in request");
    }
    if (apiUrl == null) {
      apiUrl = _apiURL;
    }
    if (parameters == null) {
      parameters = defaultParams;
    }

    Response response = await _apiManager.post(
      apiUrl,
      body: jsonEncode(query),
    );
    Map<String, dynamic> myData = json.decode(response.body);

    // has error
    if (myData.containsKey("errors")) {
      String error = myData['errors'][0]['message'];
      String trace = myData['errors'][0]['trace'].toString();
      int code = myData['errors'][0]['extensions']['code'];

      throw AppException(true,
          beautifulMsg: error,
          name: "Server Error",
          code: code,
          uglyMsg: trace);
    }

    if (myData["data"] == null) {
      return null;
    }

    final result = parser.parse(myData['data']);

    return result;
  }
}

abstract class Parser<T> {
  List<String> querys;

  T parse(dynamic data);

  dynamic dynamicParse(dynamic data) {
    if (!(data is List)) {
      return parse(data);
    }

    List<T> dataList = [];
    data.foreach((T singleData) {
      dataList.add(parse(singleData));
    });

    return dataList;
  }
}

class Pasring<T> {
  T parsing(Parser<T> data) {
    return data.parse(data);
  }
}
