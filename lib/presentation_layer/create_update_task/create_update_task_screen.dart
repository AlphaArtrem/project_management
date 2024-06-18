import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/business_layer/comments/comments_cubit.dart';
import 'package:task_manager/business_layer/create_update_task/create_update_task_cubit.dart';
import 'package:task_manager/business_layer/project_overview/project_overview_bloc.dart';
import 'package:task_manager/data_layer/enums/task_status.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/route/route_details.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/presentation_layer/common/views/base_view.dart';
import 'package:task_manager/presentation_layer/common/widgets/task_form.dart';
import 'package:task_manager/presentation_layer/create_update_task/comments_list.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Screen to create or update  tasks
class CreateUpdateTaskScreen extends StatelessWidget {
  ///Default constructor for [CreateUpdateTaskScreen]
  CreateUpdateTaskScreen({
    this.projectModel,
    this.taskModel,
    super.key,
  });

  ///Project to add this new task to
  final ProjectModel? projectModel;

  ///Task that needs to be updated
  final TaskModel? taskModel;

  ///[RouteDetails]  for [CreateUpdateTaskScreen]
  static final RouteDetails route = RouteDetails(
    'createTaskScreen',
    '/createTaskScreen',
  );

  final _formKey = GlobalKey<FormState>();
  final _taskCubit = serviceLocator<CreateUpdateTaskCubit>();

  final _commentCubit = serviceLocator<CommentsCubit>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseStreamableView<CreateUpdateTaskCubit, CreateUpdateTaskState>(
      bloc: _taskCubit..init(projectModel, taskModel),
      builder: (context, themeState, state) {
        return Scaffold(
          backgroundColor: themeService.state.secondaryColor,
          appBar: AppBar(
            elevation: 4,
            shadowColor: themeState.primaryColor,
            backgroundColor: themeState.primaryColor,
            title: Text(
              _taskCubit.state is UpdateTaskState
                  ? 'Update Task'
                  : 'Create Task',
              style: themeState.appBarTitleStyle,
            ),
            iconTheme: IconThemeData(
              color: themeService.state.secondaryColor,
            ),
            actions: [
              _saveButton(),
            ],
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _saveButton() {
    return IconButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          final task = await _taskCubit.addOrUpdateTask();
          if (task == null) {
            navigationService.showSnackBar(_taskCubit.state.error);
          } else {
            if (taskModel == null) {
              serviceLocator
                  .get<ProjectOverviewBloc>()
                  .add(AddTaskProjectOverviewEvent(task));
            } else {
              serviceLocator.get<ProjectOverviewBloc>().add(
                    UpdateTaskProjectOverviewEvent(
                      taskModel: task,
                    ),
                  );
            }
            navigationService.pop();
          }
        }
      },
      icon: const Icon(Icons.save),
    );
  }

  Widget _body() {
    if (_taskCubit.state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: themeService.state.primaryColor,
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: TaskForm(
              formKey: _formKey,
              taskModel: _taskCubit.state is UpdateTaskState
                  ? (_taskCubit.state as UpdateTaskState).taskModel
                  : null,
              taskTimeTacking: _taskCubit.state is UpdateTaskState
                  ? (_taskCubit.state as UpdateTaskState).taskTimeTacking
                  : null,
              contentValidator: (val) => _taskCubit.validateInput(val, 'Title'),
              onContentChanged: _taskCubit.updateTitle,
              descriptionValidator: (val) =>
                  _taskCubit.validateInput(val, 'Description'),
              onDescriptionChanged: _taskCubit.updateDescription,
              onStatusChanged: (TaskStatus? status) {
                if (status != null) {
                  _taskCubit.updateStatus(status);
                }
              },
              toggleTimeTracking: _taskCubit.toggleTimeTracking,
              extraFormFields: [
                _moveToHistory(),
              ],
              childBelowForm: _commentList(),
            ),
          ),
          _commentField(),
        ],
      );
    }
  }

  Widget _commentField() {
    if (_taskCubit.state is UpdateTaskState) {
      return Column(
        children: [
          Divider(thickness: 2.h),
          BlocBuilder<CommentsCubit, CommentsState>(
            bloc: _commentCubit,
            buildWhen: (a, b) => a.isLoading != b.isLoading,
            builder: (context, state) {
              return TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  fillColor: themeService.state.secondaryColor,
                  filled: true,
                  hintText: 'Add a comment',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: state.isLoading
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: CircularProgressIndicator(
                              color: themeService.state.primaryColor,
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: themeService.state.primaryColor,
                          ),
                    onPressed: () async {
                      if (!state.isLoading) {
                        final comment = await _commentCubit.addComment(
                          _controller.text,
                        );
                        if (comment != null) {
                          _controller.clear();
                          _taskCubit.incrementCommentCount();
                          serviceLocator.get<ProjectOverviewBloc>().add(
                                UpdateTaskProjectOverviewEvent(
                                  taskModel:
                                      (_taskCubit.state as UpdateTaskState)
                                          .taskModel,
                                ),
                              );
                        } else {
                          navigationService.showSnackBar(state.error);
                        }
                      }
                    },
                  ),
                ),
                maxLines: null,
                minLines: 1,
              );
            },
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget? _commentList() {
    if (_taskCubit.state is UpdateTaskState) {
      return CommentsList(
        taskModel: (_taskCubit.state as UpdateTaskState).taskModel,
        cubit: _commentCubit,
      );
    }
    return null;
  }

  Widget _moveToHistory() {
    return BlocBuilder<CommentsCubit, CommentsState>(
      bloc: _commentCubit,
      buildWhen: (a, b) => a.runtimeType != b.runtimeType,
      builder: (context, state) {
        if (_taskCubit.state is UpdateTaskState &&
            (_taskCubit.state as UpdateTaskState).taskModel.status ==
                TaskStatus.done &&
            state is LoadedCommentsState &&
            (_taskCubit.state as UpdateTaskState)
                    .taskTimeTacking
                    .millisecondSinceEpochSinceLastTimeTrackingStarted ==
                null) {
          return Column(
            children: [
              const Divider(),
              Row(
                children: [
                  Text(
                    'Archive to History',
                    style: themeService.state.primaryTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final result =
                          await _taskCubit.archiveToHistory(state.comments);
                      if (result != null) {
                        serviceLocator.get<ProjectOverviewBloc>().add(
                              UpdateTaskProjectOverviewEvent(
                                taskModel: (_taskCubit.state as UpdateTaskState)
                                    .taskModel,
                              ),
                            );
                        navigationService.pop();
                      } else {
                        navigationService.showSnackBar(_taskCubit.state.error);
                      }
                    },
                    icon: const Icon(Icons.archive),
                    color: themeService.state.primaryColor,
                  ),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
