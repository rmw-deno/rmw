#!/usr/bin/env coffee

import { dirname } from "std/path/mod.ts"

export default dirname(dirname(new URL(import.meta.url).pathname))
