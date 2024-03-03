

## Features

This is a small package designed to compress specifically SMS, which includes a phone number of no more than 7 digits and texts no larger than 128 characters. The texts do not include Latin characters, so before passing the text, it must be converted from Latin to non-Latin characters. The performance is superior to compressors like gzip. The mechanism used is that of pre-shared dictionaries; the dictionary has the 128 most used words of the language in question. In the case of the Spanish language, compressions of up to less than 60% are achieved.

It is designed to be used as a socket, so an extra bit is added that includes the size of the message so that it can be easily used as a stream in a socket connection.


## Usage


```dart
final smsTrafficOptimizer = SmsTrafficOptimizerBase(defaultDictionary);
    final msgForTest =
        "hola es un jemeplo de mensajes de testo.";
    
      final compress = smsTrafficOptimizer.compress(2825899, msgForTest);
   
      final decompress=smsTrafficOptimizer.decompress(compress);
  
```
