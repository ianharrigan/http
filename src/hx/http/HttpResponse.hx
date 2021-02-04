package hx.http;
import haxe.io.Bytes;

typedef HttpResponse = {
    var ?status:HttpStatus;
    var ?bytes:Bytes;
    var ?error:String;
    var ?headers:Map<String, String>;
}