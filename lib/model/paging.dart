class Paging {
  int size;
  int totalPage;
  int currentPage;
  int totalCount;
  Paging(this.size, this.totalPage, this.currentPage, this.totalCount);

  Paging.fromJson(Map<String, dynamic> json)
      : totalPage = json["totalPage"],
        currentPage = json["currentPage"],
        totalCount = json["totalCount"];
}
