import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/business_layer/project_overview/project_overview_bloc.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/route/route_details.dart';
import 'package:task_manager/presentation_layer/common/views/base_view.dart';
import 'package:task_manager/presentation_layer/create_update_task/create_update_task_screen.dart';
import 'package:task_manager/presentation_layer/project_overview/tasks_list.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Screen to show and move tasks for a project
class ProjectOverviewScreen extends StatelessWidget {
  ///Default constructor for [ProjectOverviewScreen]
  ProjectOverviewScreen({
    required this.projectModel,
    super.key,
  });

  ///Project for which tasks are to be displayed
  final ProjectModel projectModel;

  ///[RouteDetails]  for [ProjectOverviewScreen]
  static final RouteDetails route = RouteDetails(
    'projectOverviewScreen',
    '/projectOverviewScreen',
  );

  final _horizontalScrollController = ScrollController();
  final _bloc = serviceLocator.get<ProjectOverviewBloc>();

  @override
  Widget build(BuildContext context) {
    return BaseStreamableView<ProjectOverviewBloc, ProjectOverviewState>(
      bloc: _bloc
        ..add(
          LoadProjectOverviewEvent(
            projectModel.id,
          ),
        ),
      builder: (context, themeState, state) {
        return Scaffold(
          backgroundColor: themeService.state.secondaryColor,
          appBar: AppBar(
            elevation: 4,
            shadowColor: themeState.primaryColor,
            backgroundColor: themeState.primaryColor,
            title: Text(
              'Tasks',
              style: themeState.appBarTitleStyle,
            ),
            iconTheme: IconThemeData(
              color: themeService.state.secondaryColor,
            ),
            actions: [
              IconButton(
                onPressed: () => navigationService.pushScreen(
                  CreateUpdateTaskScreen.route,
                  extra: projectModel,
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: _body(state),
        );
      },
    );
  }

  Widget _body(ProjectOverviewState state) {
    if (state is InitialProjectOverviewState) {
      return Center(
        child: state.isLoading
            ? CircularProgressIndicator(
                color: themeService.state.primaryColor,
              )
            : Text(
                state.error,
                style: themeService.state.errorTextStyle,
              ),
      );
    } else if (state is LoadedProjectOverviewState) {
      return _taskList(state);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _taskList(LoadedProjectOverviewState state) {
    if (state.tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks found, add a task',
          style: themeService.state.primaryTextStyle,
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 30.h,
          horizontal: 20.w,
        ),
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: TasksList(
          horizontalScrollController: _horizontalScrollController,
          bloc: _bloc,
        ),
      );
    }
  }
}
