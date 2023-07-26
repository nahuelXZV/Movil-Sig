part of 'search_bloc.dart';

class SearchState extends Equatable {
  
  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;

  final List<Edificio> edificios;  

  final PointOrigen? origen;
  final Edificio? destino;
  final bool isDestinoSearched;

  final RouteDestination? routeDriving;
  final RouteDestination? routeWalking;


  const SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.history = const [],

    this.edificios = const [],

    this.origen = null,
    this.destino = null,
    this.isDestinoSearched = false,

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
    bool? isDestinoSearched,

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
    isDestinoSearched: isDestinoSearched ?? this.isDestinoSearched,

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
    isDestinoSearched,

    routeDriving,
    routeWalking,
  ];
}

