import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/business_layer/home_screen/home_screen_bloc.dart';
import 'package:task_manager/data_layer/models/route/route_details.dart';
import 'package:task_manager/presentation_layer/common/views/base_view.dart';
import 'package:task_manager/presentation_layer/history/history_screen.dart';
import 'package:task_manager/presentation_layer/project_overview/project_overview_screen.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Add Project screen of the app
class AddProjectScreen extends StatelessWidget {
  ///Default constructor for [AddProjectScreen]
  const AddProjectScreen({super.key});

  ///[RouteDetails]  for [AddProjectScreen]
  static final RouteDetails route =
      RouteDetails('addProjectScreen', '/addProjectScreen');

  @override
  Widget build(BuildContext context) {
    return BaseStreamableView<HomeScreenBloc, HomeScreenState>(
      bloc: serviceLocator.get<HomeScreenBloc>(),
      builder: (context, themeState, state) {
        return Scaffold(
          backgroundColor: themeState.secondaryColor,
          drawer: _drawer(),
          appBar: AppBar(
            elevation: 4,
            shadowColor: themeState.primaryColor,
            backgroundColor: themeState.primaryColor,
            title: Text(
              'Projects',
              style: themeState.appBarTitleStyle,
            ),
            iconTheme: IconThemeData(color: themeState.secondaryColor),
          ),
          body: _body(state),
        );
      },
    );
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: themeService.state.secondaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 60.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => navigationService.popAndPushScreen(
                      HistoryScreen.route,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'History',
                        style: themeService.state.primaryTitleStyle,
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.history,
                  color: themeService.state.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(HomeScreenState state) {
    if (state is InitialHomeScreenState) {
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
    } else if (state is LoadedHomeScreenState) {
      return _projectList(state);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _projectList(LoadedHomeScreenState state) {
    if (state.projects.isEmpty) {
      return Center(
        child: Text(
          'No projects found, add a project',
          style: themeService.state.primaryTextStyle,
        ),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => navigationService.pushScreen(
              ProjectOverviewScreen.route,
              extra: state.projects[index],
            ),
            leading: CircleAvatar(
              backgroundColor: themeService.state.primaryColor,
              child: Text(
                '${index + 1}',
                style: themeService.state.appBarTitleStyle.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            title: Text(
              state.projects[index].name,
              style: themeService.state.primaryTextStyle.copyWith(
                fontSize: 18.sp,
              ),
            ),
            subtitle: Text(
              'ID: ${state.projects[index].id}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notes,
                  color: themeService.state.primaryColor,
                ),
                Text(
                  ' ${state.projects[index].commentCount}',
                  style: themeService.state.primaryTextStyle.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: state.projects.length,
      );
    }
  }
}
