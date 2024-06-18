import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/repositories/project/project_repository_interface.dart';

part 'add_project_state.dart';

///Cubit to add projects
class AddProjectCubit extends Cubit<AddProjectState> {
  ///[AddProjectCubit] default constructor
  AddProjectCubit(this.projectRepository) : super(const AddProjectState());

  ///Implementation of [IProjectRepository] to create tasks
  final IProjectRepository projectRepository;

  ///Add a new project
  Future<void> addProject({
    required String title,
    void Function(ProjectModel?)? callback,
  }) async {
    var state = this.state;
    ProjectModel? project;
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      project = await projectRepository.addProject(title);
      state = state.copyWith(isLoading: false, error: '');
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
    callback?.call(project);
  }

  ///Project title validator
  String? validator(String? title) {
    if (title != null && title.isNotEmpty) {
      return null;
    }
    return 'Project name is required';
  }
}
