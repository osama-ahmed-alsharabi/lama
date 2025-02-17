part of 'fetch_undertone_cubit.dart';

@immutable
sealed class FetchUndertoneState {}

final class FetchUndertoneInitial extends FetchUndertoneState {}

final class FetchUndertonehasData extends FetchUndertoneState {}

final class FetchUndertoneNoData extends FetchUndertoneState {}
