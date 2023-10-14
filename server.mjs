import { createServer } from "node:http"

let port = 8081

createServer((req, res) => {
  let url = new URL(req.url, `http://${req.headers.host}`)

  switch (url.pathname) {
    case "/hi": {
      return res.setHeader("content-type", "text/html").writeHead(200).end("hi")
    }

    default:
      res.writeHead(404).end("not found")
      break
  }
})
  .listen(port, "0.0.0.0")
  .once("listening", () => {
    console.log(`🟨 Node.js@${process.version}\n📡 http://0.0.0.0:${port}/`)
  })
