part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool followUser; //creo que no se ocupa
  final Map<String, Marker> markers;

  final bool isMarkerSearched;
  final Marker? markerSearched;

  const MapState({
    this.isMapInitialized = false,
    this.followUser = false,
    Map<String, Marker>? markers,
    this.isMarkerSearched = false,
    this.markerSearched,
  })
  : markers = markers ?? const{};

  MapState copyWith({
    bool? isMapInitialized,
    bool? followUser, //creo que no se ocupa
    Map<String, Marker>? markers,
    bool? isMarkerSearched,
    Marker? markerSearched,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    followUser: followUser ?? this.followUser, //creo que no se ocupa
    markers: markers ?? this.markers,
    isMarkerSearched: isMarkerSearched ?? this.isMarkerSearched,
    markerSearched: markerSearched ?? this.markerSearched,
  );

  
  @override
  List<Object> get props => [
    isMapInitialized,
    followUser,
    markers,
    isMarkerSearched,
  ];
}

