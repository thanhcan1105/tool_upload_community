import 'dart:async';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/addon_model.dart';

class UploadCommunityProvider with ChangeNotifier {
  UploadCommunityProvider() {
    pickAndUnzipAddon();
  }

  List<AddonModels> listAddonExtracted = <AddonModels>[];
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isUpdate = ValueNotifier(false);

  Future<Map> repairJSData(Uint8List fileData) async {
    var errorJson = utf8.decode(fileData);
    // var repoData = js.context.callMethod('myFunc', [errorJson]);
    return jsonDecode(errorJson);
  }

  List<GetDataAddonModel> listBlockBP = []; //lay data tu cai nay
  List<GetDataAddonModel> listEntityRP = []; //hoac lay data tu cai nay
  List<GetDataAddonModel> listModelRP = [];
  List<GetDataAddonModel> listTextureRP = [];
  late ArchiveFile terrainTextureData = ArchiveFile("", 0, "");

  _resetListDataDefault() {
    listAddonExtracted.clear();
    terrainTextureData.clear();
    listBlockBP.clear();
    listModelRP.clear();
    listTextureRP.clear();
  }

  pickAndUnzipAddon() async {
    _resetListDataDefault();
    var dataPicked = await rootBundle.load("assets/Blossomcitpack.zip");
    Archive archive = Archive();

    archive = ZipDecoder().decodeBytes(dataPicked.buffer.asUint8List());

    //lay behavior va resource path
    String resource = '';
    String behavior = '';
    var manifestRepo = await _getManifestAddon(archive, behavior, resource);
    resource = manifestRepo["resource"];
    behavior = manifestRepo["behavior"];

    // for (final file in archive) {
    //   if (file.name.contains("$resource/models")) {
    //     if (file.isFile) {
    //       listModelRP.add(GetDataAddonModel(
    //         name: "",
    //         data: file,
    //       ));
    //     }
    //   }
    // }

    //get block data
    for (final file in archive) {
      if (file.name.contains("$behavior/blocks")) {
        if (file.isFile) {
          //get name file
          String blockName = "";
          var repo = await repairJSData(file.content);
          blockName = repo['minecraft:block']['description']['identifier'];
          listBlockBP.add(GetDataAddonModel(
            name: blockName,
            data: file,
          ));
        }
      }
    }

    //get model
    for (final file in archive) {
      if (file.name.contains("$resource/models")) {
        if (file.isFile) {
          //get name file
          String modelName = "";
          var repo = await repairJSData(file.content);
          //case binh thuong ton tai key minecraft:geometry va mot key id nam o key
          if (repo.containsKey("minecraft:geometry")) {
            modelName = repo["minecraft:geometry"][0]["description"]["identifier"];
          }
          listModelRP.add(GetDataAddonModel(
            name: modelName,
            data: file,
          ));
        }
      }
    }

    //get texture
    for (final file in archive) {
      if (file.name.contains("$resource/textures")) {
        if (file.isFile && !file.name.contains(".json")) {
          listTextureRP.add(GetDataAddonModel(
            name: file.name,
            data: file,
          ));
        }
      }
    }

    //get terrain texture
    for (final file in archive) {
      if (file.name.contains("$resource/textures/terrain_texture.json")) {
        terrainTextureData = file;
      }
    }

    _handleDataBlockFurniture(archive);
  }

  Future<Map> _getManifestAddon(Archive archive, String behavior, String resource) async {
    var manifest = archive.where((element) => element.name.contains('manifest.json'));
    for (var file in manifest) {
      if (file.name.contains("manifest.json")) {
        var fileContent = await repairJSData(file.content);
        var getType = await fileContent['modules'].first['type'];
        if (getType == "data") {
          behavior = file.name.split("/").first;
        } else if (getType == "resources") {
          resource = file.name.split("/").first;
        }
      }
    }
    return {"behavior": behavior, "resource": resource};
  }

  _handleDataBlockFurniture(Archive archive) async {
    for (var element in listBlockBP) {
      print("\n-------------------start-------------------\n");
      AddonModels defaultData = AddonModels.defaultData();
      var jsonDataBlock = await repairJSData(element.data?.content);

      defaultData.addonName = jsonDataBlock['minecraft:block']['description']['identifier'];

      ///handle model behavior pack
      //get name model by block
      var getModelNameBlock = jsonDataBlock['minecraft:block']['components']['minecraft:geometry'];
      //set data
      defaultData.modelsRP = repairJSData(listModelRP.where((modelData) => modelData.name == getModelNameBlock).first.data?.content).toString();

      ///handle texture behavior pack
      //get name texture by block
      var getTextureNameBlock = jsonDataBlock['minecraft:block']['components']['minecraft:material_instances']['*']['texture'];
      //get terrain texture
      var jsonDataTerrainTexture = await repairJSData(terrainTextureData.content);
      List<String> listTextureName = jsonDataTerrainTexture['texture_data'].keys.toList();

      //get path texture
      var pathTexture = "";
      if (listTextureName.where((textureNameItem) => textureNameItem == getTextureNameBlock).first == getTextureNameBlock) {
        pathTexture = jsonDataTerrainTexture['texture_data'][getTextureNameBlock]['textures'].first;
      }

      //get texture
      defaultData.textureRP = listTextureRP.where((textureItem) => textureItem.name?.contains("$pathTexture.png") ?? false).first.data?.content;

      //set data
      listAddonExtracted.add(defaultData);
      notifyListeners();
    }
  }
}

class GetDataAddonModel {
  String? name;
  ArchiveFile? data;

  GetDataAddonModel({this.name, this.data});
}
