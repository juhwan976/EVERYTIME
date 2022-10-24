import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/component/time_table_page/show_grade_mini.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/grade_calculator_page.dart';
import 'package:flutter/material.dart';

class GradeCalculatorTimeTablePage extends StatelessWidget {
  const GradeCalculatorTimeTablePage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: appHeight * 0.15,
      child: Column(
        children: [
          CustomContainerTitle(
            title: '학점계산기',
            type: CustomContainerTitleType.button,
            buttonIcon: Icons.create_outlined,
            onPressed: () => _routeGradeCalculatorPage(context),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: appWidth * 0.05,
                left: appWidth * 0.05,
              ),
              child: Row(
                children: [
                  _buildCreditAve(),
                  SizedBox(
                    width: appWidth * 0.065,
                  ),
                  _buildCurrentCredit(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _routeGradeCalculatorPage(BuildContext context) {
    // 참고 페이지 : https://flutter-ko.dev/docs/cookbook/animation/page-route-animation
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) =>
                GradeCalculatorPage(
                  userBloc: userBloc,
                )),
            transitionsBuilder:
                ((context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            }),
          ),
        )
        .whenComplete(() => userBloc.updateIsShowingKeyboard(false));
  }

  Widget _buildCreditAve() {
    return StreamBuilder(
      stream: userBloc.totalGradeAve,
      builder: (totalGradeAveContext, totalGradeAveSnapshot) {
        if (totalGradeAveSnapshot.hasData) {
          return StreamBuilder(
            stream: userBloc.maxAve,
            builder: (maxAveContext, maxAveSnapshot) {
              if (maxAveSnapshot.hasData) {
                return ShowGradeMini(
                  title: '평균 학점',
                  current: totalGradeAveSnapshot.data.toString(),
                  max: maxAveSnapshot.data.toString(),
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCurrentCredit() {
    return StreamBuilder(
      stream: userBloc.currentCredit,
      builder: (currentCreditContext, currentCreditSnapshot) {
        if (currentCreditSnapshot.hasData) {
          return StreamBuilder(
            stream: userBloc.targetCredit,
            builder: (targetCreditContext, targetCreditSnapshot) {
              if (targetCreditSnapshot.hasData) {
                return ShowGradeMini(
                  title: '취득 학점',
                  current: currentCreditSnapshot.data.toString(),
                  max: targetCreditSnapshot.data.toString(),
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
