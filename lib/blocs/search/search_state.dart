part of 'search_bloc.dart';

class SearchState extends Equatable {
  
  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;

  final List<Edificio> edificios;  

  final PointOrigen? origen;
  final Edificio? destino;

  final RouteDestination? routeDriving;
  final RouteDestination? routeWalking;


  const SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.history = const [],

    this.edificios = const [],

    this.origen = null,
    this.destino = null,

    this.routeDriving,
    this.routeWalking,
  });
  

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<Feature>? history,

    List<Edificio>? edificios,

    PointOrigen? origen,
    Edificio? destino,

    RouteDestination? routeDriving,
    RouteDestination? routeWalking,
  }) 
  => SearchState(
    displayManualMarker: displayManualMarker ?? this.displayManualMarker,
    places: places ?? this.places,
    history: history ?? this.history,

    edificios: edificios ?? this.edificios,

    origen: origen ?? this.origen,
    destino: destino ?? this.destino,

    routeDriving: routeDriving ?? this.routeDriving,
    routeWalking: routeWalking ?? this.routeWalking,
  );


  @override
  List<Object?> get props => [ 
    displayManualMarker,
    places,
    history,

    edificios ,

    origen,
    destino,

    routeDriving,
    routeWalking,
  ];
}

