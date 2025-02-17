part of 'undertone_cubit.dart';

@immutable
sealed class UndertoneState {}

final class UndertoneInitial extends UndertoneState {}

final class UndertoneSuccessed extends UndertoneState {}

final class UndertoneFailed extends UndertoneState {}
