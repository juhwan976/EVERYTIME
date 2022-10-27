import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/bloc/grade_calculator_bloc.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class SummeryOfTermAtGradeCalculatorPage extends StatelessWidget {
  const SummeryOfTermAtGradeCalculatorPage({
    Key? key,
    required this.userBloc,
    required this.gradeCalculatorBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final GradeCalculatorBloc gradeCalculatorBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: appHeight * 0.025,
              left: appWidth * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: gradeCalculatorBloc.currentTerm,
                  builder: (streamBuilderContext, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        userBloc.getTerm(snapshot.data!).term,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(
                  height: appHeight * 0.0075,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '평점',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    StreamBuilder(
                      stream: gradeCalculatorBloc.currentTerm,
                      builder:
                          (currentTermIndexContext, currentTermIndexSnapshot) {
                        if (currentTermIndexSnapshot.hasData) {
                          return StreamBuilder(
                            stream: userBloc.getTotalGradeAve(
                                currentTermIndexSnapshot.data!),
                            builder:
                                (totalGradeAveContext, totalGradeAveSnapshot) {
                              if (totalGradeAveSnapshot.hasData) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                    bottom: 2,
                                  ),
                                  margin: EdgeInsets.only(
                                    left: appWidth * 0.005,
                                    right: appWidth * 0.02,
                                  ),
                                  child: Text(
                                    '${totalGradeAveSnapshot.data!}',
                                    style: TextStyle(
                                      color: Theme.of(context).focusColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    const Text(
                      '전공',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    StreamBuilder(
                      stream: gradeCalculatorBloc.currentTerm,
                      builder:
                          (currentTermIndexContext, currentTermIndexSnapshot) {
                        if (currentTermIndexSnapshot.hasData) {
                          return StreamBuilder(
                            stream: userBloc.getMajorGradeAve(
                                currentTermIndexSnapshot.data!),
                            builder:
                                (majorGradeAveContext, majorGradeAveSnapshot) {
                              if (majorGradeAveSnapshot.hasData) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                    bottom: 2,
                                  ),
                                  margin: EdgeInsets.only(
                                    left: appWidth * 0.005,
                                    right: appWidth * 0.02,
                                  ),
                                  child: Text(
                                    '${majorGradeAveSnapshot.data!}',
                                    style: TextStyle(
                                      color: Theme.of(context).focusColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    const Text(
                      '취득',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    StreamBuilder(
                      stream: gradeCalculatorBloc.currentTerm,
                      builder:
                          (currentTermIndexContext, currentTermIndexSnapshot) {
                        if (currentTermIndexSnapshot.hasData) {
                          return StreamBuilder(
                            stream: userBloc.getCreditAmount(
                                currentTermIndexSnapshot.data!),
                            builder:
                                (creditAmountContext, creditAmountSnapshot) {
                              if (creditAmountSnapshot.hasData) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                    bottom: 2,
                                  ),
                                  margin: EdgeInsets.only(
                                    left: appWidth * 0.005,
                                  ),
                                  child: Text(
                                    '${creditAmountSnapshot.data!}',
                                    style: TextStyle(
                                      color: Theme.of(context).focusColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          //TODO: 시간표 불러오기 기능 만들기
          Container(
            margin: EdgeInsets.only(
              right: appWidth * 0.05,
            ),
          ),
        ],
      ),
    );
  }
}
