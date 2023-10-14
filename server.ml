open Cohttp_eio

let app (req, _, _) = match Http.Request.resource req with
  | "/hi" -> Server.html_response "hi"
  | _ -> Server.not_found_response

let () =
  Eio_main.run @@ fun env ->
  Server.run ~port:8080 ~domains:(Domain.recommended_domain_count ()) env app
