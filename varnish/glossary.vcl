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

import std;
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

acl purge {
    "localhost";
}

sub vcl_recv {

    #set req.grace = 120s;

    # Before anything else we need to fix gzip compression
    if (req.http.Accept-Encoding) {
        if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
            # No point in compressing these
            unset req.http.Accept-Encoding;
        } else if (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } else if (req.http.Accept-Encoding ~ "deflate") {
            set req.http.Accept-Encoding = "deflate";
        } else {
            # unknown algorithm
            unset req.http.Accept-Encoding;
        }
    }

    if (req.http.X-Forwarded-Proto == "https" ) {
        set req.http.X-Forwarded-Port = "443";
    } else {
        set req.http.X-Forwarded-Port = "80";
        set req.http.X-Forwarded-Proto = "http";
    }

    # we serve eea.europa.eu plone 4 and glossary
    if (req.url ~ "^/VirtualHostBase/http/(www.)?glossary.(..\.)?eea.europa.eu")
    {
        # www., en. and www.en also go to glossary.eea.europa.eu - normalize host
        if (req.url ~ "^/VirtualHostBase/http/(www.)?glossary.(en.)?eea.europa.eu")
        {
            set req.http.host = "glossary.eea.europa.eu";
        }

        # pick correct backend for glossary
        set req.backend_hint = glossary_director.backend();
    }
    else
    {
        # pick up a random instance for anonymous users to the eea site
    #    set req.backend = eea_director;
    }


    # Handle special requests
    if (req.method != "GET" && req.method != "HEAD") {

        # POST - Logins and edits
        if (req.method == "POST") {
            return(pass);
        }

        # PURGE - The CacheFu product can invalidate updated URLs
        if (req.method == "PURGE") {
            if (client.ip !~ purge) {
                return (synth(405, "Not allowed."));
            }

            # replace normal purge with ban-lurker way - may not work
            # ban ("req.url == " + req.url);
            ban ("obj.http.x-url ~ " + req.url);
            return (synth(200, "Purged."));
        }

        return(pass);
    }

    ### always cache these items:

    # javascript
    if (req.method == "GET" && req.url ~ "\.(js)") {
        return(hash);
    }

    ## images
    if (req.method == "GET" && req.url ~ "\.(gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf)$") {
        return(hash);
    }

    ## multimedia
    if (req.method == "GET" && req.url ~ "\.(svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)$") {
        return(hash);
    }

    ## xml
    if (req.method == "GET" && req.url ~ "\.(xml)$") {
        return(hash);
    }

    ## for some urls or request we can do a pass here (no caching)
    if (req.method == "GET" && (req.url ~ "aq_parent" || req.url ~ "manage$" || req.url ~ "manage_workspace$" || req.url ~ "manage_main$")) {
        return(pass);
    }

    return(hash);
}

sub vcl_pipe {
    # This is not necessary if we do not do any request rewriting
    set req.http.connection = "close";
}

sub vcl_backend_response {
    # needed for ban-lurker
    set beresp.http.x-url = bereq.url;

    # Varnish determined the object was not cacheable
    if (!(beresp.ttl > 0s)) {
        set beresp.http.X-Cacheable = "NO: Not Cacheable";
    }

    # SAINT mode
    # if we get error 500 jump to the next backend
    #if (req.method == "GET" && (beresp.status == 500 || beresp.status == 503 || beresp.status == 504)) {
    #    set beresp.saintmode = 10s;
    #    return (restart);
    #}
    set beresp.grace = 30m;

    # cache all XML and RDF objects for 1 day
    if (beresp.http.Content-Type ~ "(text\/xml|application\/xml|application\/atom\+xml|application\/rss\+xml|application\/rdf\+xml)") {
        set beresp.ttl = 1d;
        set beresp.http.X-Varnish-Caching-Rule-Id = "xml-rdf-files";
        set beresp.http.X-Varnish-Header-Set-Id = "cache-in-proxy-24-hours";
    }

    # add Access-Control-Allow-Origin header for webfonts and truetype fonts
    if (beresp.http.Content-Type ~ "(application\/vnd.ms-fontobject|font\/truetype|application\/font-woff|application\/x-font-woff)") {
        set beresp.http.Access-Control-Allow-Origin = "*";
    }

    #intecept 5xx errors here. Better reliability than in Apache
    if ( beresp.status >= 500 && beresp.status <= 505) {
        return (abandon);
    }
}

sub vcl_deliver {
    # needed for ban-lurker, we remove it here
    unset resp.http.x-url;

    # add a note in the header regarding the backend
    set resp.http.X-Backend = req.backend_hint;


    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
    } else {
        set resp.http.X-Cache = "MISS";
    }

    unset resp.http.error50x;
}

sub vcl_synth {
    set resp.http.Content-Type = "text/html; charset=utf-8";
    set resp.http.Retry-After = "5";

    if ( resp.status >= 500 && resp.status <= 505) {
        set resp.http.error50x = std.fileread("/var/static/500msg.html");
        synthetic(resp.http.error50x);
    } else {
        synthetic ({"<!DOCTYPE html>
        <html>
            <head>
                <title>"} + resp.status + " " + resp.reason + {"</title>
            </head>
            <body>
                <h1>Error "} + resp.status + " " + resp.reason + {"</h1>
                <p>"} + resp.reason + {"</p>
                <h3>Guru Meditation:</h3>
                <p>XID: "} + req.xid + {"</p>
                <hr>
                <p>Varnish cache server</p>
            </body>
        </html>
        "});
    }
    return (deliver);
}

sub vcl_backend_error {
    #if (beresp.status == 503 && req.method == "GET" && req.restarts < 2) {
    #    return (restart);
    #}
    set beresp.http.Content-Type = "text/html; charset=utf-8";
    set beresp.http.Retry-After = "5";

    if ( beresp.status >= 500 && beresp.status <= 505) {
        set beresp.http.error50x = std.fileread("/var/static/500msg.html");
        synthetic(beresp.http.error50x);
    } else {
        synthetic ({"<!DOCTYPE html>
        <html>
            <head>
                <title>"} + beresp.status + " " + beresp.reason + {"</title>
            </head>
            <body>
                <h1>Error "} + beresp.status + " " + beresp.reason + {"</h1>
                <p>"} + beresp.reason + {"</p>
                <h3>Guru Meditation:</h3>
                <p>XID: "} + bereq.xid + {"</p>
                <hr>
                <p>Varnish cache server</p>
            </body>
        </html>
        "});
    }

    return (deliver);
}
