(lang dune 3.11)

(name ocaml_http)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name ocaml_http)
 (allow_empty)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends cohttp-eio eio_main))
