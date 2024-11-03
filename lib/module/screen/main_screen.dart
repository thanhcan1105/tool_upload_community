import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tool_upload_community/module/component/const.dart';
import 'package:tool_upload_community/module/component/custom_appbar.dart';
import 'package:tool_upload_community/module/component/custom_background.dart';
import 'package:tool_upload_community/module/providers/upload_community_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  late BuildContext context;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<UploadCommunityProvider>(context, listen: false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var provider = Provider.of<UploadCommunityProvider>(context, listen: false);
    var watchProvider = context.watch<UploadCommunityProvider>();
    var size = MediaQuery.of(context).size;
    return CustomBackground(
      appBar: const CustomAppBar(
        title: "Công cụ tách Addon",
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.pickAddon();
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: kGradientButton,
                            ),
                            alignment: Alignment.center,
                            child: const Text("Chọn Addon"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: kGradientButton,
                          ),
                          alignment: Alignment.center,
                          child: const Text("Xóa toàn bộ"),
                        ),
                      ],
                    ),
                    const Text("Danh such file đã chọn: "),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...watchProvider.filesPicked.map(
                              (e) => Container(
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: kGradientItem,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e.name,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await provider.extractAddon();
                        if (watchProvider.errorFileName.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.black.withOpacity(.8),
                                title: const Text(
                                  "Something went wrong:",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...watchProvider.errorFileName.map(
                                      (e) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.name ?? ""),
                                          Text("  ${e.data}"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text("-" * 40),
                                    const Text("Ôi không, những addon trên đã gặp sự cố.\nLiên hệ CầnCần để được xử lý."),
                                  ],
                                ),
                              );
                            },
                          ).then(
                            (value) => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Đã xử lý xong :D",
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: kGradientButton,
                        ),
                        alignment: Alignment.center,
                        child: const Text("Bắt đầu thôi"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
              animation: provider.isLoading,
              builder: (context, child) {
                ValueNotifier<bool> isHideButton = ValueNotifier(false);
                if (provider.isLoading.value == false) return const SizedBox.shrink();
                return Container(
                  color: Colors.black.withOpacity(.3),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      height: 200,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(.5), borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              "assets/animations/cute_loading.gif",
                            ),
                          ),
                          const Text("Em đang xử lý!! Chờ xíu nhaaaa...."),
                          const SizedBox(height: 8),
                          AnimatedBuilder(
                            animation: isHideButton,
                            builder: (context, child) {
                              Timer(const Duration(seconds: 5), () {
                                isHideButton.value = true;
                              });
                              return Visibility(
                                visible: isHideButton.value,
                                child: MaterialButton(
                                  onPressed: () {
                                    provider.isLoading.value = false;
                                  },
                                  color: Colors.grey,
                                  child: const Text(
                                    "Hủy",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
