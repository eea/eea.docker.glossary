backend glossary_instance_3 {
  .host = "zclient3";
  .port = "8080";
}

sub vcl_init {
    glossary_director.add_backend(glossary_instance_3);
}