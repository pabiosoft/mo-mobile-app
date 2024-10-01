
class CategoryModel {

static const String CAT_NAME_KEY = "name";
  static const String CAT_ICON_PATH_KEY = "iconPath";

  String name;
  String iconPath;


  CategoryModel({
    required this.name,
    required this.iconPath,
  });

  factory CategoryModel.fromMap(Map<String, dynamic>? _map) {
    return CategoryModel(
      name: _map![CAT_NAME_KEY],
      iconPath: _map![CAT_ICON_PATH_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      CAT_NAME_KEY: name,
      CAT_ICON_PATH_KEY: iconPath,
    };
    return map;
  }


}