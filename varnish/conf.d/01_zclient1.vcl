backend glossary_instance_1 {
  .host = "zclient1";
  .port = "8080";
}

sub vcl_init {
    glossary_director.add_backend(glossary_instance_1);
}