#!/usr/bin/env coffee

import {encode,decode} from "https://deno.land/std/encoding/utf8.ts"
import * as hex from "https://deno.land/std/encoding/hex.ts"
import udp from './net/udp'
import {hash} from '../wasm/blake3'
import * as base64 from "https://denopkg.com/chiefbiiko/base64/mod.ts"
import seed from './config/seed'

import sodium from "https://deno.land/x/sodium/basic.ts"

{hostname, port, transport}= udp.addr
console.log "#{transport}://#{hostname}:#{port}"
console.log "hex", hex.encodeToString(seed)
console.log base64.fromUint8Array(seed)
console.log hex.encodeToString hash seed


n = 0
now = new Date() - 0

heartbeat = =>
  console.log await udp.send(
    encode(n+" "+now)
    {
      hostname:"47.104.79.244"
      port:30110
      transport: "udp"
    }
  )
  now += 1000
  if ++n % 60 == 0
    console.log  n, (new Date() - now)/1000
  return

heartbeat()
setInterval heartbeat, 1000

do =>
  await sodium.ready
  loop
    [data, remote] = await udp.receive()
    console.log data, remote
