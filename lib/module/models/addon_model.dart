import 'dart:typed_data';

class AddonModels {
  String? addonName;
  String? identifier;
  String? formatVersion;
  List? animationsBP;
  List? animationControllersBP;
  String entitiesBP;
  List? functionsBP;
  List? animationsRP;
  List? animationControllersRP;
  String entityRP;
  List? materialsRP;
  String modelsRP;
  List? particleRP;
  List? particleImg;
  List? renderControllersRp;
  Uint8List? textureRP;
  String itemRP;

  AddonModels({
    this.addonName,
    this.identifier,
    this.formatVersion,
    this.animationsBP,
    this.animationControllersBP,
    required this.entitiesBP,
    this.functionsBP,
    this.animationsRP,
    this.animationControllersRP,
    required this.entityRP,
    required this.materialsRP,
    required this.modelsRP,
    this.particleRP,
    this.particleImg,
    this.renderControllersRp,
    this.textureRP,
    required this.itemRP,
  });

  AddonModels.defaultData()
      : addonName = '',
        identifier = '',
        formatVersion = '',
        animationsBP = [],
        animationControllersBP = [],
        entitiesBP = '',
        functionsBP = [],
        animationsRP = [],
        animationControllersRP = [],
        entityRP = '',
        materialsRP = [],
        modelsRP = '',
        particleRP = [],
        particleImg = [],
        renderControllersRp = [],
        textureRP = Uint8List(0),
        itemRP = '';

  AddonModels.fromJson(Map<String, dynamic> json)
      : addonName = json['addonName'] ?? '',
        identifier = json['identifier'] ?? '',
        formatVersion = json['format_version'] ?? '',
        animationsBP = json['animationsBP'] ?? [],
        animationControllersBP = json['animationControllersBP'] ?? [],
        entitiesBP = json['entitiesBP'] ?? [],
        functionsBP = json['functionsBP'] ?? [],
        animationsRP = json['animationsRP'] ?? [],
        animationControllersRP = json['animationControllersRP'] ?? [],
        entityRP = json['entityRP'] ?? [],
        materialsRP = json['materialsRP'] ?? [],
        modelsRP = json['modelsRP'] ?? [],
        particleRP = json['particleRP'] ?? [],
        particleImg = json['particleImg'] ?? [],
        renderControllersRp = json['renderControllersRp'] ?? '',
        textureRP = json['textureRP'] ?? Uint8List(0),
        itemRP = json['itemRP'] ?? [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addonName'] = addonName ?? "";
    data['identifier'] = identifier ?? "";
    data['format_version'] = formatVersion ?? "";
    data['animationsBP'] = animationsBP ?? [];
    data['animationControllersBP'] = animationControllersBP ?? [];
    data['entitiesBP'] = entitiesBP;
    data['functionsBP'] = functionsBP ?? [];
    data['animationsRP'] = animationsRP ?? [];
    data['animationControllersRP'] = animationControllersRP ?? [];
    data['entityRP'] = entityRP;
    data['materialsRP'] = materialsRP ?? [];
    data['modelsRP'] = modelsRP;
    data['particleRP'] = particleRP ?? [];
    data['particleImg'] = particleImg ?? [];
    data['renderControllersRp'] = renderControllersRp ?? [];
    data['textureRP'] = textureRP ?? Uint8List(0);
    data['itemRP'] = itemRP;
    return data;
  }
}
