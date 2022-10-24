import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_button_modal_bottom_sheet.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/empty_content.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendTimeTableAtTimeTablePage extends StatelessWidget {
  const FriendTimeTableAtTimeTablePage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: appHeight * 0.4,
      child: Column(
        children: [
          CustomContainerTitle(
            title: '친구 시간표',
            type: CustomContainerTitleType.button,
            buttonIcon: Icons.add_box_outlined,
            onPressed: () {
              _buildAddFriendBottomSheet(context);
            },
          ),
          const Expanded(
            child: EmptyContent(
              icon: Icons.people_outline,
              title: '등록된 친구가 없습니다',
              contentIsString: true,
              contentString:
                  '친구를 추가하면 시간표를 확인할 수 있어요!\n(커뮤니티 활동 내역은 공개되지 않아요.)',
            ),
          ),
        ],
      ),
    );
  }

  void _buildAddFriendBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return CustomButtonModalBottomSheet(
          buttonList: [
            CustomButtonModalBottomSheetButton(
              icon: Icons.add_box_outlined,
              title: '아이디로 친구 추가',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                _buildAddFriendUseIdDialog(context);
              },
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.chat_outlined,
              title: '카카오톡으로 친구 초대',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                _buildAddFriendUseKakaoDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _buildAddFriendUseIdDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '추가할 친구의 아이디 또는 이메일 주소를 입력해주세요.',
          hasTextField: true,
          autoFocus: true,
          cursorColorType: CursorColorType.blackNWhite,
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void _buildAddFriendUseKakaoDialog(BuildContext context) async {
    late BuildContext indicatorContext;

    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulContext, _) {
            indicatorContext = statefulContext;

            return StreamBuilder(
              stream: userBloc.isDark,
              builder: (streamBuilderContext, snapshot) {
                if (snapshot.hasData) {
                  return Theme(
                    data: snapshot.data! ? ThemeData.dark() : ThemeData.light(),
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(streamBuilderContext)
                              .dialogBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const CupertinoActivityIndicator(),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            );
          },
        );
      },
    );

    //TODO: 스키마를 이용해서 카카오톡 공유하기 열기.
    await Future.delayed(const Duration(seconds: 1)).whenComplete(
      () {
        Navigator.pop(indicatorContext);
      },
    );
  }
}
