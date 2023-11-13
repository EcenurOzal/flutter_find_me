class ProfilePicture {
  String? id;
  String? author;
  int? width;
  int? height;
  String? url;
  String? downloadUrl;

  ProfilePicture({
    this.id,
    this.author,
    this.width,
    this.height,
    this.url,
    this.downloadUrl,
  });

  ProfilePicture copyWith({
    String? id,
    String? author,
    int? width,
    int? height,
    String? url,
    String? downloadUrl,
  }) {
    return ProfilePicture(
      id: id ?? this.id,
      author: author ?? this.author,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'width': width,
      'height': height,
      'url': url,
      'download_url': downloadUrl,
    };
  }

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      id: json['id'] as String?,
      author: json['author'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      url: json['url'] as String?,
      downloadUrl: json['download_url'] as String?,
    );
  }

  @override
  String toString() =>
      "ProfilePicture(id: $id,author: $author,width: $width,height: $height,url: $url,downloadUrl: $downloadUrl)";

  @override
  int get hashCode => Object.hash(id, author, width, height, url, downloadUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfilePicture &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          author == other.author &&
          width == other.width &&
          height == other.height &&
          url == other.url &&
          downloadUrl == other.downloadUrl;
}
