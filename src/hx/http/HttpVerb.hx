package hx.http;

@:enum
abstract HttpVerb(String) from String to String {
    var Get         = "GET";
    var Post        = "POST";
    var Put         = "PUT";
    var Delete      = "DELETE";
    var Patch       = "PATCH";
    var Head        = "HEAD";
    var Options     = "OPTIONS";
    var Trace       = "TRACE";
}