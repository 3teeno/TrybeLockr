class AcceptCancelGroundedResponse {
  String status;
  String message;

  AcceptCancelGroundedResponse({
      this.status, 
      this.message});

  AcceptCancelGroundedResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    return map;
  }

}