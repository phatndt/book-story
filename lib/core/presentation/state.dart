import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UIState extends Equatable {
  const UIState();

  @override
  List<Object?> get props => [];
}

class UIInitialState extends UIState {}

class UIStateLoading extends UIState {
  final bool loading;

  const UIStateLoading(this.loading);

  @override
  List<Object?> get props => [loading];
}

class UIStateSuccess<T> extends UIState {
  final T data;

  const UIStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class UIStateError extends UIState {
  final Exception error;

  const UIStateError(this.error);

  @override
  List<Object?> get props => [error];
}

@immutable
abstract class NetworkResponse extends Equatable {
  const NetworkResponse();

  @override
  List<Object?> get props => [];
}

class NetworkResponseLoading extends NetworkResponse {}

class NetworkResponseSuccess extends NetworkResponse {
  final bool loading;

  const NetworkResponseSuccess(this.loading);

  @override
  List<Object?> get props => [loading];
}

class NetworkResponseError<T> extends NetworkResponse {
  final T data;

  const NetworkResponseError(this.data);

  @override
  List<Object?> get props => [data];
}