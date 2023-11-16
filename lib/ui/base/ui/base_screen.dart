import 'package:flutter/material.dart';
import 'package:flutterbase/ui/base/controller/base_controller.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Base"),
      ),
      body: GetBuilder<BaseController>(builder: (logic) {
        if (logic.isLoadingPosts.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            itemCount: logic.posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(logic.posts[index].title!),
              );
            });
      }),
    );
  }
}
