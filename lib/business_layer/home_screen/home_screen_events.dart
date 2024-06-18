part of 'home_screen_bloc.dart';

///Events for [HomeScreenBloc]
abstract class HomeScreenEvents extends Equatable {
  ///Constructor for [HomeScreenEvents]
  const HomeScreenEvents();
}

///Load data for home screen
class LoadHomeScreenEvent extends HomeScreenEvents {
  ///Constructor for [LoadHomeScreenEvent]
  const LoadHomeScreenEvent();
  @override
  List<Object?> get props => [];
}

///Add a new project to home screen
class AddProjectEvent extends HomeScreenEvents {
  ///Constructor for [AddProjectEvent]
  const AddProjectEvent(this.projectModel);

  ///Project to add
  final ProjectModel projectModel;

  @override
  List<Object?> get props => [
        projectModel,
      ];
}
