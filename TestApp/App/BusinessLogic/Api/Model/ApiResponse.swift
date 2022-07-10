struct ApiResponse {
    
    let result: [String:Any]?
    let error: ApiResponseError
    
    init(_ json: [String:Any]? = nil) {
        self.result = json?["result"] as? [String:Any]
        self.error = ApiResponseError(json?["error"] as? [String:Any])
    }
}
