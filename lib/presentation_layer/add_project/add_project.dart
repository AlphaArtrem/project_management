import 'package:flutter/material.dart';
import 'package:task_manager/business_layer/add_project/add_project_cubit.dart';
import 'package:task_manager/business_layer/home_screen/home_screen_bloc.dart';
import 'package:task_manager/data_layer/models/route/route_details.dart';
import 'package:task_manager/presentation_layer/common/views/base_view.dart';
import 'package:task_manager/presentation_layer/common/widgets/custom_form_field.dart';
import 'package:task_manager/presentation_layer/common/widgets/form_field_container.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Screen to add new projects
class AddProjectScreen extends StatelessWidget {
  ///Default constructor for [AddProjectScreen]
  AddProjectScreen({super.key});

  ///[RouteDetails]  for [AddProjectScreen]
  static final RouteDetails route = RouteDetails(
    'addProjectScreen',
    '/addProjectScreen',
  );

  final _formKey = GlobalKey<FormState>();
  final _cubit = serviceLocator<AddProjectCubit>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseStreamableView<AddProjectCubit, AddProjectState>(
      bloc: _cubit,
      builder: (context, themeState, state) {
        return Scaffold(
          backgroundColor: themeService.state.secondaryColor,
          appBar: AppBar(
            elevation: 4,
            shadowColor: themeState.primaryColor,
            backgroundColor: themeState.primaryColor,
            title: Text('Add Project', style: themeState.appBarTitleStyle),
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
          await _cubit.addProject(
            title: _controller.text,
            callback: (project) {
              if (project == null) {
                navigationService.showSnackBar(_cubit.state.error);
              } else {
                serviceLocator
                    .get<HomeScreenBloc>()
                    .add(AddProjectEvent(project));
                navigationService.pop();
              }
            },
          );
        }
      },
      icon: const Icon(Icons.save),
    );
  }

  Widget _body() {
    if (_cubit.state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: themeService.state.primaryColor,
        ),
      );
    } else {
      return FormFieldContainer(
        child: Form(
          key: _formKey,
          child: CustomFormField(
            controller: _controller,
            hintText: 'Project Name',
            minLines: 1,
            validator: _cubit.validator,
          ),
        ),
      );
    }
  }
}
