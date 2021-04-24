#!/usr/bin/env coffee

import * as base64url from 'https://deno.land/x/base64/base64url.ts'
import config from './yml'

export default do =>
  {seed} = config
  if not seed
    seed = new Uint8Array(32)
    crypto.getRandomValues(seed)
    config.seed = base64url.fromUint8Array seed
  else
    seed = base64url.toUint8Array seed
  return seed


