# blake3

wrapper [rust blake3](https://crates.io/crates/blake3)

## Import Module

```javascript
import * as blake3 from 'https://deno.land/x/blake3/pkg/blake3.js'
```


## Usage

```javascript
import * as blake3 from 'https://deno.land/x/blake3/pkg/blake3.js';
import * as hex from "https://deno.land/std/encoding/hex.ts";

const encoder = new TextEncoder();

for(var i of ["hi", "test"]){
  console.log(`${i}`, hex.encodeToString(blake3.hash(encoder.encode(i))));
}
```
