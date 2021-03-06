# Document Store

[![Build Status](https://travis-ci.org/tmannherz/document-store.svg?branch=master)](https://travis-ci.org/tmannherz/document-store)

A service for serving and storing documents from the Google Cloud.

## Installation + Configuration

Override any default configuration from `config_default.yaml`, save to `config.yaml`, and run `pub get`.

If `ssl_certificate` and `ssl_key` are provided, a secure server will be started.

Since documents are frequently accessed repeatedly, a local, cached version is stored. The cache can be cleared with a simple cron: `bin/cli.dart document purge_cache`

## Server

Run `dart bin/server.dart` or to run in the background, `nohup dart bin/server.dart >> /var/log/dart.log 2>&1`

Provide a Basic Auth header when connecting to the API.

### Fetch a document

#### Request
```
GET http://localhost:8080/{document-ID} HTTP/1.1
Authorization: Basic [AUTH_TOKEN]
```

#### Response
`{Binary data representing document}`

### Delete a document

#### Request
```
DELETE http://localhost:8080/{document-ID} HTTP/1.1
Authorization: Basic [AUTH_TOKEN]
```

#### Response
`Document deleted.`

### Create a document

#### Request
```
POST http://localhost:8080/ HTTP/1.1
Content-Type: image/jpeg
Content-Length: [NUMBER_OF_BYTES_IN_FILE]
Authorization: Basic [AUTH_TOKEN]

[JPEG_DATA]
```

Optionally pass `directory` as a query parameter to specify a folder in the storage bucket.

#### Response
```$json
{
    "id":"58ebcc02bd51c69a23514e49",
    "content_type":"text/plain",
    "encryption_key":"abc123"
}
```

## CLI

Usage: `dart bin/cli.dart <command> <subcommand> [arguments]`

Available commands:
* `document`   - Manage Document records.
* `help`       - Display help information for ds-cli.
* `user`       - Modify User records.

### Managing Documents

Available subcommands:
* `create`      - Create a Document.
* `update`      - Update a Document.
* `delete`      - Delete a Document.
* `info`        - View Document details.
* `purge_cache` - Purge the local file cache.

#### Create

Usage: `ds-cli document create [arguments]`

```
-f, --file         Path to local file to add to storage.
-d, --directory    Storage bucket subdirectory.
```

#### Update

Usage: `ds-cli document update [arguments]`

```
-i, --id           ID of Document to replace.
-f, --file         Path to local file to add to storage.
```

#### Delete

Usage: `ds-cli document delete [arguments]`

```
-i, --id          ID of Document to edit.
```

#### Info

Usage: `ds-cli document info [arguments]`

```
-i, --id          ID of Document to query.
```

#### Cache Purge

Usage: `ds-cli document purge_cache`

### Managing Users

Available subcommands:
* `delete`     - Delete a User.
* `edit `      - Edit User details.
* `info `      - View User details.
* `register`   - Register a new User

#### Delete

Usage: `ds-cli user delete [arguments]`

```
-i, --id          ID of User to edit.
-u, --username    Username to delete.
```

#### Edit

Usage: `ds-cli user edit [arguments]`

```
-i, --id              ID of User to edit.
-u, --username        Username of User to edit.
-n, --new_username    New username for User.
-e, --enable          Enable the User.
-d, --disable         Disable the User.  
```

#### Info

Usage: `ds-cli user info [arguments]`

```
-i, --id          ID of User to edit.
-u, --username    Username to delete.
```

#### Register

Usage: `ds-cli user register [arguments]`

```
-u, --username    Username for the new User.
-p, --password    Password for the new User.
```

## Running tests

`pub run test test`