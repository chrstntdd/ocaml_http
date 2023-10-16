open Piaf
open Eio.Std

let connection_handler ({ request; _ } : Request_info.t Server.ctx) =
  match (request, request.target) with
  | { Request.meth = `GET; _ }, "/hi" ->
      let headers =
        Headers.of_list
          [
            ("connection", "keep-alive");
            ("keep-alive", "timeout=5");
            ("content-type", "text/html");
          ]
      in
      Response.of_string ~body:"hi" ~headers `OK
  | _ ->
      let headers = Headers.of_list [ ("connection", "close") ] in
      Response.of_string ~headers `Not_found ~body:""

let run ~sw ~host ~port ~domains env handler =
  let config = Server.Config.create ~domains ~buffer_size:0x1000 (`Tcp (host, port)) in
  let server = Server.create ~config handler in
  let command = Server.Command.start ~sw env server in
  command

let start ~sw env =
  let domains = Domain.recommended_domain_count () in
  let port = 8080 in
  let host = Eio.Net.Ipaddr.V4.any in
  run ~sw ~host ~port ~domains env connection_handler

let () =
  Eio_main.run (fun env ->
      Switch.run (fun sw ->
          let _command = start ~sw env in
          ()))
