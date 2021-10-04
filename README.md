
# qr code generator tool

Small command line tool for generate and reconition qr codes written in Swift

## Using

```
Usage: ./qrgen [options]
  -m, --mode:
      mode. g - generation, r = reconition, default is generation
  -s, --silent:
      suppress output, default is false
  -i, --input:
      source (either string to encode for genetation or image file name for recognition), required
  -o, --output:
      output file name, required
  --size:
      size of the image, default is 400
  -b, --back:
      background color #RRGGBB, default if #FFFFFF
  -f, --front:
      foreground color #RRGGBB, default is #000000
```

# License

MIT license. See the LICENSE file for more info.
