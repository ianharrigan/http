package hx.http;

import haxe.Json;
import haxe.io.Bytes;
import hx.http.impl.HttpRequestImpl;

#if promhx
typedef HttpRequestReturn = promhx.Promise<HttpResponse>;
#else
typedef HttpRequestReturn = Void;
#end

class HttpRequest {
    public var url:String;
    
    public var onError:String->Void = null;
    public var onStatus:HttpStatus->Void = null;
    public var onBytes:Bytes->Void = null;
    public var onData:String->Void = null;
    public var onComplete:HttpResponse->Void = null;
    
    public var responseHeaders:Map<String, String> = null;
    
    public var detectContentType:Bool = true;
    
    public function new(url:String) {
        this.url = url;
    }
    
    public function call(verb:HttpVerb = HttpVerb.Get, headers:Map<String, String> = null, data:Any = null):HttpRequestReturn {
        var httpResponse:HttpResponse = {};
        
        var stringData:String = null;
        var contentType:String = null;
        switch (Type.typeof(data)) {
            case TObject:
                stringData = Json.stringify(data);
                if (detectContentType) {
                    contentType = "application/json";
                }
            case TNull: // do nothing    
            case _:    
                stringData = Std.string(data);
        }
        
        if (contentType != null) {
            if (headers == null) {
                headers = new Map<String, String>();
            }
            if (!headers.exists("Content-Type")) {
                headers.set("Content-Type", contentType);
            }
        }
        
        #if promhx
        var deferred = new promhx.Deferred<HttpResponse>();
        #end
        
        var impl = new HttpRequestImpl(url);
        
        impl.onError = function(error) {
            httpResponse.error = error;
            if (this.onError != null) {
                this.onError(error);
            }
        }
        impl.onStatus = function(status) {
            httpResponse.status = status;
            if (this.onStatus != null) {
                this.onStatus(status);
            }
        }
        impl.onBytes = function(bytes) {
            httpResponse.bytes = bytes;
            if (this.onBytes != null) {
                this.onBytes(bytes);
            }
            if (this.onData != null) {
                this.onData(bytes.toString());
            }
        }
        impl.onComplete = function() {
            this.responseHeaders = impl.responseHeaders;
            httpResponse.headers = impl.responseHeaders;
            if (this.onComplete != null) {
                this.onComplete(httpResponse);
            }
            
            #if promhx
            deferred.resolve(httpResponse);
            #end
        }
        
        impl.makeRequest(verb, headers, stringData);
        
        #if promhx
        return deferred.promise();
        #end
    }
}
