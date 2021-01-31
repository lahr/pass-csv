# pass csv

An extension for the [standard unix password manager](https://www.passwordstore.org) that generates a CSV file from specified key-value fields in the metadata. A use case for `pass csv` could be to generate an overview to which service you gave your address and phone number across the password store.

A password file can store arbitrary information in the lines after the password:

```
Yw|ZSNH!}z"6{ym9pI
URL: *.amazon.com/*
Username: user@example.com
has-address: true
has-tel: false
Account Created: 2021-02-01
```

`pass csv key1 key2 ...` iterates over the password store, searches for the specified keys and prints their value. The key-value pairs must be colon-separated. The password itself is never read. If a specified key in a password file is not found, the corresponding value in the CSV is `-`.

## Example

`pass csv has-addr has-tel "Account Created" > summary.csv` generates the following CSV file:

```
"name","has-addr","has-tel","Account Created"
"amazon.com","true","false","2021-02-01"
"google.com","false","true","-"
```

| name       | has-addr | has-tel | Account Created |
| :--------- | :------: | :-----: | :-------------: |
| amazon.com | true     | false   |   2021-02-01    |
| google.com | false    | true    |        -        |

## Installation

- `make install`
- Alternatively, you can copy the `src/csv.*` files to `~/.password-store/.extensions`, make the bash script executable and set the `PASSWORD_STORE_ENABLE_EXTENSIONS` environment variable to `true`.
