// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:task_manager/core/network_info.dart';
import 'package:task_manager/features/task/data/task_repository.dart';
import 'package:task_manager/features/task/domain/cubit/task_cubit.dart';
import 'package:task_manager/services/api_client.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  final String deviceId;
  final String token;

  const AppProviders({
    super.key,
    required this.child,
    required this.deviceId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<String>.value(value: deviceId),
        Provider<ApiClient>(
          create: (_) => ApiClient(
            dio: Dio(
              BaseOptions(baseUrl: 'https://beta.mrdekk.ru/todo', headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              }),
            ),
          ),
        ),
        Provider<TaskRepository>(create: (_) => TaskRepository()),
        Provider<NetworkInfo>(create: (_) => NetworkInfo(Connectivity())),
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(
            context.read<ApiClient>(),
            context.read<TaskRepository>(),
            context.read<NetworkInfo>(),
            context.read<String>(),
          )..fetchTasks(),
        ),
      ],
      child: child,
    );
  }
}
