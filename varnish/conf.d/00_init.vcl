import std;
import directors;

sub vcl_init {
    new glossary_director = directors.round_robin();
}