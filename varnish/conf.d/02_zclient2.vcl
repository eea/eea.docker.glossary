backend glossary_instance_2 {
  .host = "zclient2";
  .port = "8080";
}

sub vcl_init {
    glossary_director.add_backend(glossary_instance_2);
}