import {
  hash
} from './mod.js';
import {
  assertEquals,
  assertThrowsAsync
} from "./dev.deps.js";
import {
  b64Encode
} from './dev.deps.js';

const encode = (new TextEncoder()).encode

Deno.test(
  "hash",
  () => {
    for (var [i, right] of [
        ["", "rxNJufX5oaagQE3qNtzJSZvLJcmtwRK3zJqTyuQfMmI="],
        ["hi", "hQUumqsbZ7ZiLZSghEGwn9W3rKYe42BBbXDeXaZ9hso="],
        ["您好", "sV7GDRr304JM+9IRjTkcYVBZAJ6EotxATG+nn636jCE="]
      ]) {
      var buf = hash(encode(i));
      assertEquals(
        b64Encode(buf),
        right
      );
    }

  }
)
