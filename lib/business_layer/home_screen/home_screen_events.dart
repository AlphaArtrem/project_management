part of 'home_screen_bloc.dart';

///Events for [HomeScreenBloc]
abstract class HomeScreenEvents extends Equatable {
  const HomeScreenEvents();
}

class LoadHomeScreenEvent extends HomeScreenEvents {
  const LoadHomeScreenEvent();
  @override
  List<Object?> get props => [];
}

class AddProjectEvent extends HomeScreenEvents {
  const AddProjectEvent(this.projectModel);

  final ProjectModel projectModel;
  @override
  List<Object?> get props => [
        projectModel,
      ];
}
