# Multi-core OCaml HTTP server vs Node.js native HTTP server

Two very simple HTTP web servers to compare baseline server performance, one in OCaml 5.1.0 with eio and the other in plain Node.js (v.20.8.1)

## Why

To profile runtime server performance between the two platforms

## How to test

### OCaml

1. Install OCaml deps as normal (`opam`, `dune`, etc)
2. Compile and run the OCaml server (runs on port 8080)
3. Compile with `dune build`
4. Run the executable `./_build/default/bin/main.exe`
5. Blast it with autocannon `bun x autocannon 'http://0.0.0.0:8080/hi`

### Node.js

1. Install `node` v20.8.1 through a node version manager — like `pnpm env use --global latest`
2. Run the server (runs on port 8081) `node server.mjs`
3. Blast it with autocannon `bun x autocannon 'http://0.0.0.0:8081/hi`

## Results

Machine: M1 MacBook Air 8GB RAM

Note, these are from a single run.

### OCaml

```shell
bun x autocannon 'http://0.0.0.0:8080/hi'
Running 10s test @ http://0.0.0.0:8080/hi
10 connections


┌─────────┬──────┬──────┬───────┬───────┬─────────┬─────────┬───────┐
│ Stat    │ 2.5% │ 50%  │ 97.5% │ 99%   │ Avg     │ Stdev   │ Max   │
├─────────┼──────┼──────┼───────┼───────┼─────────┼─────────┼───────┤
│ Latency │ 0 ms │ 0 ms │ 5 ms  │ 10 ms │ 0.32 ms │ 1.54 ms │ 20 ms │
└─────────┴──────┴──────┴───────┴───────┴─────────┴─────────┴───────┘
┌───────────┬────────┬────────┬─────────┬─────────┬─────────┬─────────┬────────┐
│ Stat      │ 1%     │ 2.5%   │ 50%     │ 97.5%   │ Avg     │ Stdev   │ Min    │
├───────────┼────────┼────────┼─────────┼─────────┼─────────┼─────────┼────────┤
│ Req/Sec   │ 11567  │ 11567  │ 12703   │ 18047   │ 14026.8 │ 2063.44 │ 11566  │
├───────────┼────────┼────────┼─────────┼─────────┼─────────┼─────────┼────────┤
│ Bytes/Sec │ 1.3 MB │ 1.3 MB │ 1.42 MB │ 2.02 MB │ 1.57 MB │ 231 kB  │ 1.3 MB │
└───────────┴────────┴────────┴─────────┴─────────┴─────────┴─────────┴────────┘

Req/Bytes counts sampled once per second.
# of samples: 10

140k requests in 10.02s, 15.7 MB read
```

### Node.js

```shell
bun x autocannon 'http://0.0.0.0:8081/hi'
Running 10s test @ http://0.0.0.0:8081/hi
10 connections


┌─────────┬──────┬──────┬───────┬──────┬─────────┬─────────┬───────┐
│ Stat    │ 2.5% │ 50%  │ 97.5% │ 99%  │ Avg     │ Stdev   │ Max   │
├─────────┼──────┼──────┼───────┼──────┼─────────┼─────────┼───────┤
│ Latency │ 0 ms │ 0 ms │ 0 ms  │ 0 ms │ 0.01 ms │ 0.12 ms │ 33 ms │
└─────────┴──────┴──────┴───────┴──────┴─────────┴─────────┴───────┘
┌───────────┬─────────┬─────────┬─────────┬─────────┬─────────┬─────────┬─────────┐
│ Stat      │ 1%      │ 2.5%    │ 50%     │ 97.5%   │ Avg     │ Stdev   │ Min     │
├───────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Req/Sec   │ 67711   │ 67711   │ 73151   │ 80575   │ 73324.8 │ 4558.75 │ 67663   │
├───────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Bytes/Sec │ 11.4 MB │ 11.4 MB │ 12.3 MB │ 13.5 MB │ 12.3 MB │ 767 kB  │ 11.4 MB │
└───────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┘

Req/Bytes counts sampled once per second.
# of samples: 10

733k requests in 10.01s, 123 MB read
```

I was very surprised by these results.

How is Node.js ~4x faster than multi-core OCaml?

Is Node.js that _optimized_ or have I misconfigured something on the OCaml side?
