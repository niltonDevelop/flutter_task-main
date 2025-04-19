import 'package:flutter/material.dart';
import 'package:fluttertask/core/auth/repository/user_repository.dart';
import 'package:fluttertask/core/config/color/app_color_scheme.dart';
import 'package:fluttertask/core/config/color/app_colors.dart';
import 'package:fluttertask/core/database/database_helper.dart';
import 'package:fluttertask/core/network/network.dart';
import 'package:fluttertask/modules/home/controller/home_controller.dart';
import 'package:fluttertask/modules/home/view/home_view.dart';
import 'package:fluttertask/modules/home/widget/widget.dart';
import 'package:fluttertask/shared/controller/base_controller.dart';
import 'package:fluttertask/shared/repository/task_repository.dart';
import 'package:fluttertask/shared/utils/util.dart';
import 'package:fluttertask/shared/widget/app_button_icon.dart';
import 'package:fluttertask/shared/widget/app_modal.dart';
import 'package:fluttertask/shared/widget/app_scaffold.dart';
import 'package:fluttertask/shared/widget/app_switch.dart';
import 'package:fluttertask/shared/widget/app_textfield.dart';
import 'package:fluttertask/shared/widget/app_textfield_search.dart';
import 'package:fluttertask/shared/widget/spacing/spacing.dart';
import 'package:fluttertask/shared/widget/text_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  factory HomePage.routeBuilder(_, __) {
    return HomePage(key: const Key('home_page'));
  }
  Future<bool?> show(BuildContext context) async {
    return showAdaptiveDialog<bool>(context: context, builder: (context) => this);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (BuildContext context) {
        return HomeController(
          userRepository: context.read<UserRepository>(),
          taskRepository: TaskRepository(DatabaseHelper.instance, apiService: ApiService()),
        )..allTask();
      },
      child: Consumer<HomeController>(
        builder: (_, HomeController con, __) {
          return AppScaffold(
            title: AppTextFieldSearch(
              placeholder: context.loc.searchTitle,
              textController: searchController,
              onPressed: () {
                searchController.clear();
                con.allTask();
              },
              onChanged: (value) {
                con.searchTask(value);
              },
            ),
            showFloatingButton: true,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(text: context.loc.listPending),
                      ValueListenableBuilder(
                        valueListenable: con.isPending,
                        builder: (_, isPending, __) {
                          return AppSwitch(
                            value: isPending ?? false,
                            onChanged: (value) {
                              con.isPending.value = value;
                              con.searchCompleted();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(child: HomeView(con: con)),
              ],
            ),
            customDrawer: DrawerContent(con: con),
            onPressed: () async {
              onPressedSave(context, con);
            },
          );
        },
      ),
    );
  }

  Future<void> onPressedSave(BuildContext context, HomeController con) async {
    GlobalKey<FormState> formKeyNote = GlobalKey<FormState>();
    con.titleController.clear();
    con.bodyController.clear();
    final result = await AppDialog(
      titleColor: AppColorScheme.of(context).textPrimary,
      title: context.loc.addNote,
      body: Form(
        key: formKeyNote,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.title),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: AppColorScheme.of(context).textSecundary,
                child: AppTextField(
                  hintText: context.loc.insertTitle,
                  textEditingController: con.titleController,
                  validator: (p0) => con.validateEmpty(p0, context),
                ),
              ),
            ),
            AppVerticalSpace.sl,
            Text(context.loc.body),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: AppColorScheme.of(context).textSecundary,
                child: AppTextField(
                  hintText: context.loc.writeNote,
                  textEditingController: con.bodyController,
                  validator: (p0) => con.validateEmpty(p0, context),
                ),
              ),
            ),
          ],
        ),
      ),
      buttons: [
        AppButton(
          isCancel: true,
          text: context.loc.back,
          showIcon: false,
          onPressed: () {
            context.pop(false);
          },
        ),
        AppButton(
          text: context.loc.save,
          showIcon: false,
          onPressed: () {
            if (!formKeyNote.currentState!.validate()) return;
            con.insertTask();
            context.pop(true);
          },
        ),
      ],
    ).show(context);

    if (result ?? false) {
      if (!context.mounted) return;
      showCustomSnackBar(
        context: context,
        message: context.loc.messageAddNote,
        backgroundColor: context.color.success,
        foregroundColor: AppColors.white,
      );
    }
  }
}
