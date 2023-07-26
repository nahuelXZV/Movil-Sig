part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent {}
class OnDeactivateManualMarkerEvent extends SearchEvent {}


class OnNewPlacesFoundEvent extends SearchEvent{
  final List<Feature> places;
  const OnNewPlacesFoundEvent(this.places);
}

class AddToHistoryEvent extends SearchEvent {
  final Feature place;
  const AddToHistoryEvent(this.place);
}

class InitAllEdificiosEvent extends SearchEvent {
  final List<Edificio> edificios;
  const InitAllEdificiosEvent(this.edificios);
}


class SetOrigenEvent extends SearchEvent {
  final PointOrigen origen;
  SetOrigenEvent(this.origen);
}

class SetDestinoEvent extends SearchEvent {
  final Edificio? destino;
  final bool? isDestinoSearched;
  SetDestinoEvent(this.destino, this.isDestinoSearched);
}


class SetRoutesEvent extends SearchEvent {
  final RouteDestination routeDriving;
  final RouteDestination routeWalking;
  SetRoutesEvent(this.routeDriving, this.routeWalking);
}
