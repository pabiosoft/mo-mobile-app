// element_model.dart
class ElementModel {
  String uid;
  String elementTypeUid;
  String userUid;
  String categorieUid;
  String name;
  String content;
  String description;
  String locate;
  String price;
  String size;
  DateTime createdDate;
  bool verified;
  String exactLocate;
  String desired;
  String city;
  bool isActif;
  String imageUrl;
  String apiContext; // New field for @context
  String apiId;      // New field for @id
  String apiType;    // New field for @type

  // Additional fields
  List<ImageModel> images; // List of images
  List<PieceModel> pieces; // List of pieces
  UserModel user;          // User details
  ElementTypeModel elementType; // ElementType details
  CatModel category;  // Category details

  ElementModel({
    required this.uid,
    required this.elementTypeUid,
    required this.userUid,
    required this.categorieUid,
    required this.name,
    required this.content,
    required this.description,
    required this.locate,
    required this.price,
    required this.size,
    required this.createdDate,
    required this.verified,
    required this.exactLocate,
    required this.desired,
    required this.city,
    required this.isActif,
    required this.imageUrl,
    required this.apiContext,
    required this.apiId,
    required this.apiType,
    required this.images,
    required this.pieces,
    required this.user,
    required this.elementType,
    required this.category,
  });

  Map<String, dynamic> toJson() {
  return {
    'id': uid,
    'elementType': {
      'name': elementTypeUid,
    },
    'user': {
      'id': userUid,
    },
    'category': {
      'id': categorieUid,
    },
    'name': name,
    'content': content,
    'description': description,
    'locate': locate,
    'price': price,
    'size': size,
    'createdDate': createdDate.toIso8601String(),
    'verified': verified,
    'exactLocate': exactLocate,
    'desired': desired,
    'city': city,
    'isActif': isActif,
    'images': images.map((image) => image.toJson()).toList(),
    'pieces': pieces.map((piece) => piece.toJson()).toList(),
    'user': user.toJson(),
    'elementType': elementType.toJson(),
    'category': category.toJson(),
    '@context': apiContext,
    '@id': apiId,
    '@type': apiType,
  };
}


  factory ElementModel.fromJson(Map<String, dynamic> json) {
    return ElementModel(
      uid: json['id'] ?? '',
      elementTypeUid: json['elementType']?['name'] ?? '',
      userUid: json['user']?['id'] ?? '',
      categorieUid: json['category']?['id'] ?? '',
      name: json['name'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      locate: json['locate'] ?? '',
      price: json['price'] ?? "0.0",
      size: json['size'] ?? '',
      createdDate: DateTime.tryParse(json['createdDate']) ?? DateTime.now(),
      verified: json['verified'] ?? false,
      exactLocate: json['exactLocate'] ?? '',
      desired: json['desired'] ?? '',
      city: json['city'] ?? '',
      isActif: json['isActif'] ?? false,
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : '',
      apiContext: json['@context'] ?? '',
      apiId: json['@id'] ?? '',
      apiType: json['@type'] ?? '',
      images: json['images'] != null
          ? List<ImageModel>.from(json['images'].map((x) => ImageModel.fromJson(x)))
          : [],
      pieces: json['pieces'] != null
          ? List<PieceModel>.from(json['pieces'].map((x) => PieceModel.fromJson(x)))
          : [],
      user: UserModel.fromJson(json['user'] ?? {}),
      elementType: ElementTypeModel.fromJson(json['elementType'] ?? {}),
      category: CatModel.fromJson(json['category'] ?? {}),
    );
  }
}

// Additional models to represent the nested data
class ImageModel {
  String url;
  String alt;
  bool isActif;

  ImageModel({required this.url, required this.alt, required this.isActif});

   Map<String, dynamic> toJson() {
    return {
      'url': url,
      'alt': alt,
      'isActif': isActif,
    };
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'] ?? '',
      alt: json['alt'] ?? '',
      isActif: json['isActif'] ?? false,
    );
  }
}

class PieceModel {
  String description;
  String surface;
  List<ItemModel> items;
  bool isActif;

  PieceModel({
    required this.description,
    required this.surface,
    required this.items,
    required this.isActif,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'surface': surface,
      'items': items.map((item) => item.toJson()).toList(),
      'isActif': isActif,
    };
  }

  factory PieceModel.fromJson(Map<String, dynamic> json) {
    return PieceModel(
      description: json['description'] ?? '',
      surface: json['surface'] ?? '',
      items: json['items'] != null
          ? List<ItemModel>.from(json['items'].map((x) => ItemModel.fromJson(x)))
          : [],
      isActif: json['isActif'] ?? false,
    );
  }
}

class ItemModel {
  String space;
  String type;
  bool isActif;

  ItemModel({
    required this.space,
    required this.type,
    required this.isActif,
  });

  Map<String, dynamic> toJson() {
    return {
      'space': space,
      'type': type,
      'isActif': isActif,
    };
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      space: json['space'] ?? '',
      type: json['type'] ?? '',
      isActif: json['isActif'] ?? false,
    );
  }
}

class UserModel {
  String id;
  String email;
  String telephone;
  String fullName;
  String age;
  String imgUrl;
  String badge;
  String bio;
  List<String> roles;

  UserModel({
    required this.id,
    required this.email,
    required this.telephone,
    required this.fullName,
    required this.age,
    required this.imgUrl,
    required this.badge,
    required this.bio,
    required this.roles,
  });

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'telephone': telephone,
      'fullName': fullName,
      'age': age,
      'imgUrl': imgUrl,
      'badge': badge,
      'bio': bio,
      'roles': roles,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      fullName: json['fullName'] ?? '',
      age: json['age'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      badge: json['badge'] ?? '',
      bio: json['bio'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}

class ElementTypeModel {
  String name;
  bool isActif;

  ElementTypeModel({required this.name, required this.isActif});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isActif': isActif,
    };
  }

  factory ElementTypeModel.fromJson(Map<String, dynamic> json) {
    return ElementTypeModel(
      name: json['name'] ?? '',
      isActif: json['isActif'] ?? false,
    );
  }
}

class CatModel {
  String name;
  String info;
  String imageUrl;
  bool isActif;

  CatModel({required this.name, required this.info, required this.imageUrl, required this.isActif});

   Map<String, dynamic> toJson() {
    return {
      'name': name,
      'info': info,
      'imageUrl': imageUrl,
      'isActif': isActif,
    };
  }

  factory CatModel.fromJson(Map<String, dynamic> json) {
    return CatModel(
      name: json['name'] ?? '',
      info: json['info'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isActif: json['isActif'] ?? false,
    );
  }
}
