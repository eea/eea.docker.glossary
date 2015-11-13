backend server1 {
    .host = "zclient1";
    .port = "8080";
}

backend server2 {
    .host = "zclient2";
    .port = "8080";
}

backend server3 {
    .host = "zclient3";
    .port = "8080";
}

import std;
import directors;
sub vcl_init {
    new backends_director = directors.round_robin();
    backends_director.add_backend(server1);
    backends_director.add_backend(server2);
    backends_director.add_backend(server3);
}

sub vcl_recv {
    set req.backend_hint = backends_director.backend();
}
