import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UIState extends Equatable {
  const UIState();

  @override
  List<Object?> get props => [];
}

class UIInitialState extends UIState {}

class UILoadingState extends UIState {
  final bool loading;

  const UILoadingState(this.loading);

  @override
  List<Object?> get props => [loading];
}

class UISuccessState<T> extends UIState {
  final T data;

  const UISuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UIErrorState extends UIState {
  final Exception error;

  const UIErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class UIWarningState extends UIState {
  final String message;

  const UIWarningState(this.message);

  @override
  List<Object?> get props => [message];
}

@immutable
abstract class NetworkResponse extends Equatable {
  const NetworkResponse();

  @override
  List<Object?> get props => [];
}
