class ReviewPaging {
  int? size;
  num? averageRating;
  int? totalPage;
  int currentPage;
  int totalCount;
  ReviewPaging(this.size, this.totalPage, this.currentPage, this.totalCount, this.averageRating);

  ReviewPaging.fromJson(Map<String, dynamic> json)
      : size = json["size"],
        totalPage = json["totalPage"],
        currentPage = json["currentPage"],
        averageRating = json['average_grade'],
        totalCount = json["totalCount"];
}
