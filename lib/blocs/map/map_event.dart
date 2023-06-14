part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitializedEvent(this.controller);
}


class InitMarkersEvent extends MapEvent {
  final Map<String, Marker> markers;
  const InitMarkersEvent(this.markers);
}

class SetMarkerEvent extends MapEvent {
  final Edificio edificio;
  const SetMarkerEvent(this.edificio);
}

class DeleteSearchedMarkerEvent extends MapEvent {
  // final Edificio edificio;
  // const DeleteMarkerEvent(this.edificio);
}

