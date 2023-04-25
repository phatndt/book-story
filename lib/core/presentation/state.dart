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

class UIStateWarning extends UIState {
  final String message;

  const UIStateWarning(this.message);

  @override
  List<Object?> get props => [message];
}

@immutable
abstract class NetworkResponse extends Equatable {
  const NetworkResponse();

  @override
  List<Object?> get props => [];
}
