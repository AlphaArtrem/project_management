import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/business_layer/comments/comments_cubit.dart';
import 'package:task_manager/data_layer/models/comment/comment_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Screen to create or update  tasks
class CommentsList extends StatelessWidget {
  ///Default constructor for [CommentsList]
  CommentsList({
    this.taskModel,
    this.cubit,
    this.comments,
    super.key,
  }) : assert(
          (taskModel != null && cubit != null && comments == null) ||
              (taskModel == null && cubit == null && comments != null),
          'taskModel and cubit must not be null when comments is null and '
          'comments must not be null when taskModel and cubit are null',
        );

  final TaskModel? taskModel;
  final CommentsCubit? cubit;
  final List<CommentModel>? comments;

  @override
  Widget build(BuildContext context) {
    if (taskModel != null && cubit != null) {
      return BlocBuilder<CommentsCubit, CommentsState>(
        bloc: cubit!..init(taskModel!.id),
        buildWhen: (a, b) => a.isLoading != b.isLoading,
        builder: (context, state) {
          return _cubitBody(state);
        },
      );
    } else {
      return _comments(comments!);
    }
  }

  Widget _title(int commentCount) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              Text(
                'Comments',
                style: themeService.state.primaryTextStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              const Spacer(),
              Text(
                commentCount.toString(),
                style: themeService.state.primaryTextStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _cubitBody(CommentsState state) {
    if (state is InitialCommentsState) {
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            _title(taskModel!.commentCount),
            SizedBox(height: 50.h),
            if (state.isLoading)
              const SizedBox.shrink()
            else
              Text(state.error, style: themeService.state.errorTextStyle),
          ],
        ),
      );
    } else {
      return _comments((state as LoadedCommentsState).comments);
    }
  }

  Widget _comments(List<CommentModel> comments) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _title(comments.length);
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _comment(comments[index - 1]),
        );
      },
      itemCount: comments.length + 1,
    );
  }

  Widget _comment(CommentModel comment) {
    return Column(
      children: [
        ListTile(
          title: Text(
            comment.content,
            style: themeService.state.primaryTextStyle.copyWith(
              fontSize: 18.sp,
            ),
          ),
          subtitle: Text(
            comment.postedAt?.toString().split('.').first ?? '',
          ),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
