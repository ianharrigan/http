package hx.http.impl;

import haxe.io.Bytes;
import js.html.XMLHttpRequest;

@:allow(hx.http.HttpRequest)
class JsHttpRequestImpl {
    public var url:String;

    public var onError:String->Void = null;
    public var onStatus:HttpStatus->Void = null;
    public var onBytes:Bytes->Void = null;
    public var onComplete:Void->Void = null;
    
    public var responseHeaders:Map<String, String>;
    
    public function new(url:String) {
        this.url = url;
    }
    
    private function makeRequest(verb:HttpVerb, headers:Map<String, String>, data:String = null) {
        var xhr = new XMLHttpRequest();
        xhr.open(verb, url);
        if (headers != null) {
            for (k in headers.keys()) {
                var v = headers.get(k);
                xhr.setRequestHeader(k, v);
            }
        }
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                responseHeaders = parseResponseHeaders(xhr.getAllResponseHeaders());
                if (this.onStatus != null) {
                    this.onStatus(xhr.status);
                }
                if (xhr.responseText != null) {
                    var bytes = Bytes.ofString(xhr.responseText);
                    if (this.onBytes != null) {
                        this.onBytes(bytes);
                    }
                }
                if (this.onComplete != null) {
                    this.onComplete();
                }
            }
        }
        xhr.onerror = function() {
            if (this.onError != null) {
                this.onError(xhr.statusText);
            }
        }
        
        xhr.send(data);
    }
    
    private function parseResponseHeaders(s:String):Map<String, String> {
        var r = new Map<String, String>();
        var lines = s.split("\n");
        for (l in lines) {
            l = StringTools.trim(l);
            if (l.length == 0) {
                continue;
            }
            var parts = l.split(":");
            var k = parts.shift();
            var v = parts.join(":");
            r.set(StringTools.trim(k), StringTools.trim(v));
        }
        return r;
    }
}