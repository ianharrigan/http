package;

import haxe.Json;
import hx.http.HttpRequest;
import hx.http.HttpStatus;
import hx.http.HttpVerb;

class Main {
	static function main() {
        trace("start");
        
        basicTests();
	}
    
    private static function basicTests() {
        trace("basic tests");
        
        var r = new HttpRequest("http://jsonplaceholder.typicode.com/posts");
        r.onError = function(error) {
            trace("error: " + error);
        }
        r.onStatus = function(status) {
            if (status != HttpStatus.Created) {
                throw "Status was not expected " + HttpStatus.Created + " (" + status + ")";
            }
        }
        r.onData = function(data) {
            var json = Json.parse(data);
            if (json.id != 101) {
                throw "json id not correct";
            }
        }
        r.onComplete = function(response) {
            if (!response.headers.exists("Content-Type") && !response.headers.exists("content-type")) {
                throw "No Content-Type response header!!";
            }
            if (response.headers.exists("Content-Type") && response.headers.get("Content-Type") != "application/json; charset=utf-8") {
                throw "Invalid Content-Type response header!!";
            }
            if (response.headers.exists("content-type") && response.headers.get("content-type") != "application/json; charset=utf-8") {
                throw "Invalid Content-Type response header!!";
            }
        }
        r.call(HttpVerb.Post);
        
        var r = new HttpRequest("http://jsonplaceholder.typicode.com/posts");
        r.call(HttpVerb.Post).then(function(response) {
            if (response.status != HttpStatus.Created) {
                throw "Status was not expected " + HttpStatus.Created + " (" + response.status + ")";
            }
            var json = Json.parse(response.bytes.toString());
            if (json.id != 101) {
                throw "json id not correct";
            }
            if (!response.headers.exists("Content-Type") && !response.headers.exists("content-type")) {
                throw "No Content-Type response header!!";
            }
            if (response.headers.exists("Content-Type") && response.headers.get("Content-Type") != "application/json; charset=utf-8") {
                throw "Invalid Content-Type response header!!";
            }
            if (response.headers.exists("content-type") && response.headers.get("content-type") != "application/json; charset=utf-8") {
                throw "Invalid Content-Type response header!!";
            }
        });
        
        var r = new HttpRequest("http://jsonplaceholder.typicode.com/posts/1");
        r.call().then(function(response) {
            if (response.status != HttpStatus.OK) {
                throw "Status was not expected " + HttpStatus.OK + " (" + response.status + ")";
            }
            var json = Json.parse(response.bytes.toString());
            if (json.id != 1) {
                throw "json id not correct";
            }
            if (json.userId != 1) {
                throw "json userId not correct";
            }
            if (json.title != "sunt aut facere repellat provident occaecati excepturi optio reprehenderit") {
                throw "json title not correct";
            }
            if (!response.headers.exists("Content-Type") && !response.headers.exists("content-type")) {
                throw "No Content-Type response header!!";
            }
            if (response.headers.exists("Content-Type") && response.headers.get("Content-Type") != "application/json; charset=utf-8") {
                throw "Invalid Content-Type response header!!";
            }
            if (response.headers.exists("content-type") && response.headers.get("content-type") != "application/json; charset=utf-8") {
                throw "Invalid Content-Type response header!!";
            }
        });
        
        var r = new HttpRequest("http://jsonplaceholder.typicode.com/posts/22");
        r.call(HttpVerb.Put, ["Content-Type" => "application/json"], {title: "tim"}).then(function(response) {
            if (response.status != HttpStatus.OK) {
                throw "Status was not expected " + HttpStatus.OK + " (" + response.status + ")";
            }
            var json = Json.parse(response.bytes.toString());
            if (json.id != 22) {
                throw "json id not correct";
            }
            if (json.title != "tim") {
                throw "json title not correct";
            }
        });
        
        var r = new HttpRequest("http://jsonplaceholder.typicode.com/posts/1");
        r.call(HttpVerb.Patch, {body: "jim"}).then(function(response) {
            if (response.status != HttpStatus.OK) {
                throw "Status was not expected " + HttpStatus.OK + " (" + response.status + ")";
            }
            var json = Json.parse(response.bytes.toString());
            if (json.id != 1) {
                throw "json id not correct";
            }
            if (json.title != "sunt aut facere repellat provident occaecati excepturi optio reprehenderit") {
                throw "json title not correct";
            }
            if (json.body != "jim") {
                throw "json title not correct";
            }
        });
    }
}