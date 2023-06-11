part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool followUser; //creo que no se ocupa

  const MapState({
    this.isMapInitialized = false,
    this.followUser = false
  });

  MapState copiWith({
    bool? isMapInitialized,
    bool? followUser, //creo que no se ocupa
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    followUser: followUser ?? this.followUser, //creo que no se ocupa
  );
  
  @override
  List<Object> get props => [isMapInitialized, followUser];
}

