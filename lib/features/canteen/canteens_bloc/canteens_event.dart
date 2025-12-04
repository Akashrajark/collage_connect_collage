part of 'canteens_bloc.dart';

@immutable
sealed class CanteensEvent {}

class GetAllCanteensEvent extends CanteensEvent {
  final Map<String, dynamic> params;

  GetAllCanteensEvent({required this.params});
}

class AddCanteenEvent extends CanteensEvent {
  final Map<String, dynamic> canteenDetails;

  AddCanteenEvent({required this.canteenDetails});
}

class EditCanteenEvent extends CanteensEvent {
  final Map<String, dynamic> canteenDetails;
  final int canteenId;

  EditCanteenEvent({
    required this.canteenDetails,
    required this.canteenId,
  });
}

class DeleteCanteenEvent extends CanteensEvent {
  final String userId;

  DeleteCanteenEvent({required this.userId});
}
