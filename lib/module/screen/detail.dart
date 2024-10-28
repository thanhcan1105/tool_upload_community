import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tool_upload_community/module/providers/upload_community_provider.dart';
import 'package:tool_upload_community/module/screen/webview_blockbench.dart';
import '../component/const.dart';
import '../component/custom_appbar.dart';
import '../component/custom_background.dart';
import '../models/addon_model.dart';
import 'in_app_web_view.dart';

class DetailItemScreen extends StatefulWidget {
  final AddonModels item;

  const DetailItemScreen({
    super.key,
    required this.item,
  });

  @override
  State<DetailItemScreen> createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  ValueNotifier<String> imgData = ValueNotifier("");

  TextEditingController controllerAuthorSocialNetwork = TextEditingController();
  TextEditingController controllerAddonName = TextEditingController();
  TextEditingController controllerAuthorName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    controllerAddonName.text = widget.item.addonName!;
    controllerAuthorName.text = "N/A";
    controllerDescription.text = "Item of vehicle";
  }

  addHashTag(controller, provider) {
    var trimInput = controller.text.trim();
    // Chia chuỗi thành các từ
    List<String> words = trimInput.split(' ');

    // Chuyển đổi chữ cái đầu tiên của mỗi từ thành in hoa và loại bỏ dấu cách
    List<String> capitalizedWords = words.map((word) {
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    }).toList();

    // Ghép các từ đã sửa đổi lại với nhau và thêm ký tự "#"
    String hashtag = capitalizedWords.join('');

    if (controller.text.isNotEmpty) {
      provider.updateHashTags(
        "add",
        hashtag,
      );
      controller.clear();
      Navigator.pop(context);
    }
  }

  dialogFilter(toolProviderW) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: Row(
            children: [
              const Text(
                "Options",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              )
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width <= 1000 ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * .5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    toolProviderW.isPublicAddon = !toolProviderW.isPublicAddon;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Checkbox.adaptive(
                        value: toolProviderW.isPublicAddon,
                        onChanged: (value) {
                          toolProviderW.isPublicAddon = value!;
                          setState(() {});
                        },
                      ),
                      const Text(
                        'Public addon',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UploadCommunityProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return CustomBackground(
      appBar: CustomAppBar(
        title: 'Detail Item',
        isShowLeading: true,
        onBack: () {
          Navigator.pop(context);
        },
        actionsTabBar: [
          IconButton(
            onPressed: () {
              dialogFilter(provider);
            },
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            screenViewModel(context, size),
          ],
        ),
      ),
      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: ValueListenableBuilder<bool>(
      //       valueListenable: provider.isLoading,
      //       builder: (context, value, child) {
      //         return Stack(
      //           children: [
      //             size.width > 1000
      //                 ? Row(
      //                     children: [
      //                       Expanded(
      //                         child: Column(
      //                           children: [
      //                             Expanded(
      //                                 child: screenViewModel(context, size)),
      //                             const SizedBox(height: 10),
      //
      //                             ///information
      //                             areaInformation(context, size),
      //                           ],
      //                         ),
      //                       ),
      //                       const SizedBox(width: 8),
      //                       Expanded(
      //                         child: Column(
      //                           children: [
      //                             Expanded(
      //                               child: SingleChildScrollView(
      //                                 child: Column(
      //                                   children: [
      //                                     ///behavior
      //                                     areaBehavior(),
      //                                     const SizedBox(height: 10),
      //
      //                                     ///resource
      //                                     areaResource(),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ),
      //                             const SizedBox(height: 10),
      //                             buttonUpload(),
      //                           ],
      //                         ),
      //                       )
      //                     ],
      //                   )
      //                 : Container(
      //                     constraints: BoxConstraints(
      //                       maxHeight: size.height,
      //                       maxWidth: 700,
      //                     ),
      //                     width: size.width,
      //                     child: Column(
      //                       children: [
      //                         screenViewModel(context, size),
      //                         Expanded(
      //                           child: Padding(
      //                             padding:
      //                                 const EdgeInsets.symmetric(vertical: 8),
      //                             child: SingleChildScrollView(
      //                               child: Column(
      //                                 children: [
      //                                   ///information
      //                                   areaInformation(context, size),
      //                                   const SizedBox(height: 10),
      //
      //                                   ///behavior
      //                                   areaBehavior(),
      //                                   const SizedBox(height: 10),
      //
      //                                   ///resource
      //                                   areaResource(),
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         const SizedBox(height: 10),
      //                         buttonUpload(),
      //                       ],
      //                     ),
      //                   ),
      //             value ? Positioned(
      //               top: 0,
      //               left: 0,
      //               bottom: 0,
      //               right: 0,
      //               child: Center(
      //                 child: Container(
      //                   height: 200,
      //                   width: 550,
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                   child: const Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Text("Loading..."),
      //                       SizedBox(height: 10),
      //                       CircularProgressIndicator(color: Colors.blue),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ) : const SizedBox.shrink(),
      //           ],
      //         );
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  Widget buttonUpload() {
    var provider = Provider.of<UploadCommunityProvider>(context, listen: false);
    return Container();
    // return GestureDetector(
    //   onTap: () {
    //     if(controllerAddonName.text.isEmpty){
    //       _focusNodes[0].requestFocus();
    //       return;
    //     }
    //     if(controllerAuthorName.text.isEmpty){
    //       _focusNodes[1].requestFocus();
    //       return;
    //     }
    //     if(controllerDescription.text.isEmpty){
    //       _focusNodes[3].requestFocus();
    //       return;
    //     }
    //     if(imgData.value.isEmpty){
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text("Please select image"),
    //         ),
    //       );
    //       return;
    //     }
    //     if(provider.cateSelected['id'] == "0"){
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text("Please select category"),
    //         ),
    //       );
    //       return;
    //     }
    //     {
    //       provider.uploadData(
    //         item: widget.item,
    //         addonName: controllerAddonName.text,
    //         authorName: controllerAuthorName.text,
    //         authorSocialNetwork: controllerAuthorSocialNetwork.text,
    //         description: controllerDescription.text,
    //         category: provider.cateSelected['name'],
    //         hashTags: provider.listHashTag,
    //         imgData: imgData.value,
    //         isPublicAddon: provider.isPublicAddon,
    //       );
    //     }
    //   },
    //   child: Container(
    //     height: 50,
    //     width: double.infinity,
    //     decoration: BoxDecoration(
    //       gradient: kGradientButton,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     alignment: Alignment.center,
    //     child: const Text(
    //       "UPLOAD",
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    // );
  }

  Container areaResource() {
    return Container();
    // return areaInfor(
    //   "Resource",
    //   [
    //     rowInfoItem(
    //       title: "Animation Controllers",
    //       contents: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           ...widget.item.animationControllersRP!.map(
    //             (e) => Text(jsonDecode(e)['fileName'],
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,),
    //           ),
    //         ],
    //       ),
    //     ),
    //     rowInfoItem(
    //       title: "Animations",
    //       contents: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           ...widget.item.animationsRP!.map(
    //             (e) => Text(jsonDecode(e)['fileName'],
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,),
    //           ),
    //         ],
    //       ),
    //     ),
    //     rowInfoItem(
    //       isRequire: true,
    //       title: "Entity",
    //       contents: Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           Text(
    //             widget.item.entityRP.isEmpty
    //                 ? ""
    //                 : jsonDecode(widget.item.entityRP)['fileName'],
    //             maxLines: 1,
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //         ],
    //       ),
    //     ),
    //     rowInfoItem(
    //       isRequire: true,
    //       title: "Json Models",
    //       contents: Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           Text(
    //             widget.item.modelsRP.isEmpty
    //                 ? ""
    //                 : jsonDecode(widget.item.modelsRP)['fileName'],
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //           ),
    //         ],
    //       ),
    //     ),
    //     rowInfoItem(
    //       title: "Materials",
    //       contents: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           ...widget.item.materialsRP!.map(
    //             (e) => Text(jsonDecode(e)['fileName'],
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,),
    //           ),
    //         ],
    //       ),
    //     ),
    //     rowInfoItem(
    //       title: "Particles",
    //       contents: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           ...widget.item.particleRP!.map(
    //                 (e) => Text(jsonDecode(e)['fileName'],
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,),
    //           ),
    //         ],
    //       ),
    //     ),
    //     rowInfoItem(
    //       title: "Render Controllers",
    //       contents: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           ...widget.item.renderControllersRp!.map(
    //             (e) => Text(jsonDecode(e)['fileName'],
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,),
    //           ),
    //         ],
    //       ),
    //     ),
    //     rowInfoItem(
    //       isRequire: true,
    //       title: "Texture",
    //       contents: Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           widget.item.textureRP!.isEmpty
    //               ? const SizedBox.shrink()
    //               : Image.memory(
    //             Uint8List.fromList(jsonDecode(widget.item.textureRP!)['data']
    //                 .cast<int>()
    //                 .toList()),
    //             width: 100,
    //             errorBuilder: (context, error, stackTrace) {
    //               return const Text(
    //                 "Image incorrect format or not found",
    //               );
    //             },
    //           )
    //         ],
    //       )
    //     ),
    //   ],
    // );
  }

  Container areaBehavior() {
    return areaInfor(
      "Behavior",
      [
        rowInfoItem(
          title: "Animation Controllers",
          contents: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...widget.item.animationControllersBP!.map(
                    (e) => Text(
                  jsonDecode(e)['fileName'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        rowInfoItem(
          title: "Animations",
          contents: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...widget.item.animationsBP!.map(
                    (e) => Text(
                  jsonDecode(e)['fileName'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        rowInfoItem(
          isRequire: true,
          title: "Entity",
          contents: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.item.entitiesBP.isEmpty ? "" : jsonDecode(widget.item.entitiesBP)['fileName'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        rowInfoItem(
          title: "Functions",
          contents: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...widget.item.functionsBP!.map(
                    (e) => Text(
                  e['fileName'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container areaInformation(BuildContext context, ui.Size size) {
    var provider = Provider.of<UploadCommunityProvider>(context, listen: false);
    return areaInfor(
      "Information",
      [
        rowInputText(
          focus: _focusNodes[0],
          title: "Addon Name",
          controller: controllerAddonName,
        ),
        rowInputText(
          focus: _focusNodes[1],
          title: "Author Name",
          controller: controllerAuthorName,
        ),
        // rowSocialNetwork(),
        rowInputText(
          focus: _focusNodes[2],
          title: "Author link",
          controller: controllerAuthorSocialNetwork,
        ),
        rowInputText(
          focus: _focusNodes[3],
          title: "Description",
          controller: controllerDescription,
        ),
        Row(
          children: [
            const Text("Category: "),
            const Spacer(),
            // Text(
            //   context.watch<ToolUploadProvider>().cateSelected['name'],
            // ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                dialogCategory();
              },
              child: Container(
                width: 80,
                height: 35,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  gradient: kGradientItem,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text('Change'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Hash Tags: "),
            // Expanded(
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: [
            //         ...context
            //             .watch<ToolUploadProvider>()
            //             .listHashTag
            //             .map(
            //               (e) => Container(
            //                 margin:
            //                     const EdgeInsets
            //                         .symmetric(
            //                   horizontal: 5,
            //                 ),
            //                 padding:
            //                     const EdgeInsets
            //                         .all(5),
            //                 decoration:
            //                     BoxDecoration(
            //                   gradient:
            //                       kGradientItem,
            //                   borderRadius:
            //                       BorderRadius
            //                           .circular(
            //                               10),
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     Text("#$e"),
            //                     const SizedBox(
            //                         width: 3),
            //                     GestureDetector(
            //                       onTap: () {
            //                         // provider.updateHashTags(
            //                         //   "remove",
            //                         //   e,
            //                         // );
            //                       },
            //                       child:
            //                           const Icon(
            //                         Icons.close,
            //                         color: Colors.black,
            //                         size: 20,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             )
            //             .toList(),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                final FocusNode _focusNode = FocusNode();
                _focusNode.requestFocus();
                showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController controller = TextEditingController();
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              const Text(
                                "Hash Tags",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.blueGrey,
                          content: SizedBox(
                            width: size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                TextField(
                                  focusNode: _focusNode,
                                  controller: controller,
                                  cursorColor: Colors.white,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onSubmitted: (value) {
                                    addHashTag(controller, provider);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Input hash tags",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Close",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                addHashTag(controller, provider);
                              },
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    });
              },
              child: Container(
                width: 80,
                height: 35,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  gradient: kGradientItem,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget screenViewModel(BuildContext context, ui.Size size) {
    // return Container();
    return GestureDetector(
      onTap: () {
        try {
          final data = {
            'geoJson': widget.item.modelsRP,
            'texture': widget.item.textureRP,
          };
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewBlockBenchPage(data: data),
            ),
          ).then((value) {
            if (value != null) {
              imgData.value = value;
            }
          });
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Model incorrect format or not found"),
                      const SizedBox(height: 10),
                      Text("$e"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"),
                    ),
                  ],
                );
              });
        }
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              SizedBox(
                height: size.width < 1000 ? 300 : size.height,
                child: ValueListenableBuilder<String>(
                  valueListenable: imgData,
                  builder: (context, value, child) {
                    return Container(
                      height: 350,
                      width: size.width,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        // color: Colors.amber.withOpacity(.3),
                        gradient: kGradientItem,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: value.isEmpty
                          ? const SizedBox.shrink()
                          : Image.memory(
                        base64Decode(value),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            "Image incorrect format or not found",
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Container(
                  width: 100,
                  height: 40,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: const Text(
                    "View in 3D",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Row rowSocialNetwork() {
  //   var size = MediaQuery.of(context).size;
  //   const underlineInputBorder = UnderlineInputBorder(
  //     borderSide: BorderSide(color: Colors.white),
  //   );
  //   return Row(
  //     children: [
  //       const Text("Author link: "),
  //       const Spacer(),
  //       Container(
  //         constraints: const BoxConstraints(
  //           maxWidth: 300,
  //         ),
  //         child: TextFormField(
  //           focusNode: _focusNodes[2],
  //           controller: controllerAuthorSocialNetwork,
  //           decoration: const InputDecoration(
  //             hintText: "Input link",
  //             hintStyle: TextStyle(
  //               color: Colors.grey,
  //             ),
  //             enabledBorder: underlineInputBorder,
  //             focusedBorder: underlineInputBorder,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Row rowInputText({
    required String title,
    required TextEditingController controller,
    required FocusNode focus,
  }) {
    const underlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );
    return Row(
      children: [
        Text("$title: "),
        const Spacer(),
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: TextFormField(
            focusNode: focus,
            controller: controller,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Input ${title.toLowerCase()}",
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: underlineInputBorder,
              focusedBorder: underlineInputBorder,
            ),
          ),
        ),
      ],
    );
  }

  dialogCategory() {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return StatefulBuilder(builder: (context, setState) {
    //       return AlertDialog(
    //         title: Row(
    //           children: [
    //             const Text(
    //               "Category",
    //               style: TextStyle(
    //                 color: Colors.white,
    //               ),
    //             ),
    //             const Spacer(),
    //             GestureDetector(
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //               child: const Icon(
    //                 Icons.close,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ],
    //         ),
    //         backgroundColor: Colors.blueGrey,
    //         content: Container(
    //           constraints: BoxConstraints(
    //             maxHeight: MediaQuery.of(context).size.height * .5,
    //           ),
    //           child: Column(
    //             children: [
    //               Expanded(
    //                 child: SingleChildScrollView(
    //                   child: Wrap(
    //                     spacing: 5,
    //                     runSpacing: 5,
    //                     children: [
    //                       ...context.watch<ToolUploadProvider>().cateVehicleList.map(
    //                         (e) => GestureDetector(
    //                       onTap: () {
    //                         context
    //                             .read<ToolUploadProvider>()
    //                             .updateVehicleCate(e);
    //                         Navigator.pop(context);
    //                       },
    //                       child: Container(
    //                         height: 50,
    //                         width: 350,
    //                         alignment: Alignment.center,
    //                         decoration: BoxDecoration(
    //                           gradient: kGradientItem,
    //                           borderRadius: BorderRadius.circular(
    //                             10,
    //                           ),
    //                         ),
    //                         child: Stack(
    //                           children: [
    //                             Container(
    //                               width: double.infinity,
    //                               height: double.infinity,
    //                               alignment: Alignment.center,
    //                               child: Text(
    //                                 e['name'],
    //                               ),
    //                             ),
    //                             Positioned(
    //                               right: 10,
    //                               top: 0,
    //                               bottom: 0,
    //                               child: GestureDetector(
    //                                 onTap: () {
    //                                   showDialog(
    //                                     context: context,
    //                                     builder: (context) {
    //                                       return AlertDialog(
    //                                         backgroundColor:
    //                                         Colors.blueGrey,
    //                                         title: const Text(
    //                                           "Delete Category",
    //                                           style: TextStyle(
    //                                               color: Colors.white),
    //                                         ),
    //                                         content: const Text(
    //                                             "Are you sure delete this category?", style: TextStyle(color: Colors.white),),
    //                                         actions: [
    //                                           TextButton(
    //                                             onPressed: () {
    //                                               Navigator.pop(
    //                                                   context);
    //                                             },
    //                                             child: const Text(
    //                                               "Close",
    //                                               style: TextStyle(
    //                                                   color:
    //                                                   Colors.grey),
    //                                             ),
    //                                           ),
    //                                           TextButton(
    //                                             onPressed: () {
    //                                               context
    //                                                   .read<ToolUploadProvider>()
    //                                                   .deleteVehicleCate(e["id"]);
    //                                               Navigator.pop(
    //                                                   context);
    //                                             },
    //                                             child: const Text(
    //                                               "Delete",
    //                                               style: TextStyle(
    //                                                   color:
    //                                                   Colors.white),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       );
    //                                     },
    //                                   );
    //                                 },
    //                                 child: Container(
    //                                   color: Colors.transparent,
    //                                   child: const Icon(
    //                                     Icons.clear,
    //                                     color: Colors.white,
    //                                   ),
    //                                 ),
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ),),
    //                     ],
    //                   )
    //                 ),
    //               ),
    //               GestureDetector(
    //                 onTap: () {
    //                   showDialog(
    //                     context: context,
    //                     builder: (context) {
    //                       TextEditingController cateName =
    //                           TextEditingController();
    //                       TextEditingController keyword =
    //                           TextEditingController();
    //                       return AlertDialog(
    //                         backgroundColor: Colors.blueGrey,
    //                         title: const Text(
    //                           "Add Category",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                           ),
    //                         ),
    //                         content: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             TextFormField(
    //                               controller: cateName,
    //                               cursorColor: Colors.white,
    //                               style: const TextStyle(
    //                                 color: Colors.white,
    //                               ),
    //                               decoration: const InputDecoration(
    //                                 labelText: "Category name",
    //                                 labelStyle: TextStyle(
    //                                   color: Colors.grey,
    //                                 ),
    //                                 enabledBorder: UnderlineInputBorder(
    //                                   borderSide: BorderSide(
    //                                     color: Colors.white,
    //                                   ),
    //                                 ),
    //                                 focusedBorder: UnderlineInputBorder(
    //                                   borderSide: BorderSide(
    //                                     color: Colors.white,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             TextFormField(
    //                               controller: keyword,
    //                               cursorColor: Colors.white,
    //                               style: const TextStyle(
    //                                 color: Colors.white,
    //                               ),
    //                               decoration: const InputDecoration(
    //                                 labelText: "Keyword",
    //                                 labelStyle: TextStyle(
    //                                   color: Colors.grey,
    //                                 ),
    //                                 enabledBorder: UnderlineInputBorder(
    //                                   borderSide: BorderSide(
    //                                     color: Colors.white,
    //                                   ),
    //                                 ),
    //                                 focusedBorder: UnderlineInputBorder(
    //                                   borderSide: BorderSide(
    //                                     color: Colors.white,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         actions: [
    //                           TextButton(
    //                             onPressed: () {
    //                               Navigator.pop(context);
    //                             },
    //                             child: const Text(
    //                               "Close",
    //                               style: TextStyle(
    //                                 color: Colors.grey,
    //                               ),
    //                             ),
    //                           ),
    //                           TextButton(
    //                             onPressed: () {
    //                               if (cateName.text.isNotEmpty &&
    //                                   keyword.text.isNotEmpty) {
    //                                 context
    //                                     .read<ToolUploadProvider>()
    //                                     .addNewVehicleCate(
    //                                       cateName: cateName.text,
    //                                       keyword: keyword.text,
    //                                     );
    //                                 Navigator.pop(context);
    //                               }
    //                             },
    //                             child: const Text(
    //                               "Add",
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       );
    //                     },
    //                   );
    //                 },
    //                 child: Container(
    //                   margin: const EdgeInsets.only(
    //                     top: 10,
    //                   ),
    //                   width: MediaQuery.of(context).size.width,
    //                   height: 50,
    //                   decoration: BoxDecoration(
    //                     color: Colors.blue,
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   child: const Icon(
    //                     Icons.add,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     });
    //   },
    // );
  }

  Container rowInfoItem({required String title, required Widget contents, bool isRequire = false}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              text: "$title: ",
              children: [
                TextSpan(
                  text: isRequire ? "*" : "",
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: contents)
        ],
      ),
    );
  }

  Container areaInfor(String title, List child) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        gradient: kGradientItem,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
          ),
          const Divider(
            color: Colors.white,
          ),
          ...child
        ],
      ),
    );
  }
}
