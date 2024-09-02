import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/app_utils.dart';
import 'cubits/helper_data/helper_data_cubit.dart';

class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  IOSOptions _getIosOptions() => const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      );

  Future<void> writeSecureData({required String key, String? value}) async {
    await deleteSecureData(key);
    appPrint("Writing new data having key $key");
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
  }

  Future<String?> readSecureData(String key) async {
    appPrint("Reading data having key $key");
    var readData = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
    return readData;
  }

  Future<Map<String, dynamic>> readSecureData2<T>(String key) async {
    appPrint("Reading data having key $key");
    var readData = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
    final result =
        readData != null ? jsonDecode(readData) : <String, dynamic>{};
    return result;
  }

  Future<void> deleteSecureData(String key) async {
    appPrint("Deleting data having key $key");
    await _secureStorage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
  }

  Future<Map<String, String>> readAllSecureData() async {
    appPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
    return allData;
  }

  Future<void> deleteAllSecureData() async {
    appPrint("Deleting all secured data");
    await _secureStorage.deleteAll(
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
  }

  Future<bool> containsKeyInSecureData(String key) async {
    appPrint("Checking data for the key $key");
    var containsKey = await _secureStorage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
    return containsKey;
  }

  Future<void> logout(BuildContext context) async {
    context.read<HelperDataCubit>().resetData();
    await deleteAllSecureData();
    // await _secureStorage.delete(
    //   key: ssStore,
    //   aOptions: _getAndroidOptions(),
    //   iOptions: _getIosOptions(),
    // );
    // await _secureStorage.delete(
    //   key: ssDevice,
    //   aOptions: _getAndroidOptions(),
    //   iOptions: _getIosOptions(),
    // );
  }
}
