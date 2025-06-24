// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      eventTitle: fields[1] as String,
      eventDescription: fields[2] as String,
      eventImage: fields[3] as String,
      eventName: fields[4] as String,
      eventDate: fields[5] as DateTime,
      eventTime: fields[6] as String,
      eventLocation: fields[8] as String,
      isFavorite: fields[7] as bool,
      availableTickets: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventTitle)
      ..writeByte(2)
      ..write(obj.eventDescription)
      ..writeByte(3)
      ..write(obj.eventImage)
      ..writeByte(4)
      ..write(obj.eventName)
      ..writeByte(5)
      ..write(obj.eventDate)
      ..writeByte(6)
      ..write(obj.eventTime)
      ..writeByte(7)
      ..write(obj.isFavorite)
      ..writeByte(8)
      ..write(obj.eventLocation)
      ..writeByte(9)
      ..write(obj.availableTickets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
