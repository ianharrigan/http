package hx.http.impl;

import haxe.Http;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

@:allow(hx.http.HttpRequest)
class SysHttpRequestImpl {
    public var url:String;
    
    public var onError:String->Void = null;
    public var onStatus:HttpStatus->Void = null;
    public var onBytes:Bytes->Void = null;
    public var onComplete:Void->Void = null;
    
    public var responseHeaders:Map<String, String>;
    
    public function new(url:String) {
        this.url = url;
    }
    
    private function makeRequest(verb:HttpVerb, headers:Map<String, String>, data:String) {
        var request = new Http(url);
        if (headers != null) {
            for (k in headers.keys()) {
                var v = headers.get(k);
                request.addHeader(k, v);
            }
        }
        if (data != null) {
            request.setPostData(data);
        }
        
        request.onError = function(error) {
            if (this.onError != null) {
                this.onError(error);
            }
        }
        
        request.onStatus = function(status) {
            if (this.onStatus != null) {
                this.onStatus(status);
            }
        }
        
        var responseBytes = new BytesOutput();
        request.customRequest(true, responseBytes, verb);
        
        var bytes = responseBytes.getBytes();
        this.responseHeaders = request.responseHeaders;
        if (this.onBytes != null) {
            this.onBytes(bytes);
        }
        
        if (this.onComplete != null) {
            this.onComplete();
        }
    }
}
