import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tool_upload_community/module/component/const.dart';
import 'package:tool_upload_community/module/component/custom_appbar.dart';
import 'package:tool_upload_community/module/component/custom_background.dart';
import 'package:tool_upload_community/module/providers/upload_community_provider.dart';
import 'package:tool_upload_community/module/screen/detail.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var provider = Provider.of<UploadCommunityProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return CustomBackground(
      appBar: const CustomAppBar(
        title: "Tool Upload Community",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildHeaderWidget(),
            _buildBodyWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("List File Data:"),
          Container(),
          Expanded(
            child: ListView.separated(
              itemCount: context.watch<UploadCommunityProvider>().listAddonExtracted.length,
              itemBuilder: (context, index) {
                var element = context.watch<UploadCommunityProvider>().listAddonExtracted[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailItemScreen(item: element)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: kGradientItem,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text("${index + 1}: ${element.addonName}"),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 40,
            decoration: BoxDecoration(
              gradient: kGradientButton,
            ),
            alignment: Alignment.center,
            child: const Text("Pick Addon"),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 40,
            decoration: BoxDecoration(
              gradient: kGradientButton,
            ),
            alignment: Alignment.center,
            child: const Text("Clear Data"),
          ),
        )
      ],
    );
  }
}
