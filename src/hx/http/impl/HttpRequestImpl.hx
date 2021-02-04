package hx.http.impl;

#if sys
typedef HttpRequestImpl = SysHttpRequestImpl;
#elseif js
typedef HttpRequestImpl = JsHttpRequestImpl;
#else
#error
#end