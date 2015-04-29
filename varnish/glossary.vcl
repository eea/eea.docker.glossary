#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and http://varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

import directors;

# Default backend definition. Set this to point to your content server.
backend glossary_instance_1 {
  .host = "zclient1";
  .port = "8080";
}

backend glossary_instance_2 {
  .host = "zclient2";
  .port = "8080";
}

backend glossary_instance_3 {
  .host = "zclient3";
  .port = "8080";
}

sub vcl_init {
    new glossary_director = directors.round_robin();
    glossary_director.add_backend(glossary_instance_1);
    glossary_director.add_backend(glossary_instance_2);
    glossary_director.add_backend(glossary_instance_3);
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.

    # pick correct backend for glossary
    set req.backend_hint = glossary_director.backend();
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}
