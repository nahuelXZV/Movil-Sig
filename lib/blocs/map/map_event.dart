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


class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  const DisplayPolylinesEvent(this.polylines, this.markers);
}

class ChangeIsDrivingEvent extends MapEvent {
  final bool isDriving;
  const ChangeIsDrivingEvent(this.isDriving);
}

