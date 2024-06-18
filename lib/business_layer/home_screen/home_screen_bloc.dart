import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/presentation_layer/home/home_screen.dart';
import 'package:task_manager/repositories/project/project_repository_interface.dart';

part 'home_screen_events.dart';
part 'home_screen_state.dart';

///[Bloc] for [HomeScreen]
class HomeScreenBloc extends Bloc<HomeScreenEvents, HomeScreenState> {
  ///[HomeScreenBloc] default constructor which takes in [HomeScreenState]
  ///as a required parameter
  HomeScreenBloc(this.projectRepository)
      : super(const InitialHomeScreenState()) {
    on<LoadHomeScreenEvent>(_init);
    on<AddProjectEvent>(_addProject);
  }

  ///Implementation of [IProjectRepository] to fetch and create projects
  final IProjectRepository projectRepository;

  Future<void> _init(
    LoadHomeScreenEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    try {
      final projects = await projectRepository.getProjects();
      emit(LoadedHomeScreenState(projects: projects));
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _addProject(
    AddProjectEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is LoadedHomeScreenState) {
      final projects = [
        event.projectModel,
        ...(state as LoadedHomeScreenState).projects,
      ];
      emit(LoadedHomeScreenState(projects: projects));
    }
  }
}
