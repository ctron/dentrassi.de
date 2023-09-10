---
id: 770
title: 'RPM File Format'
date: '2016-04-12T15:56:30+02:00'
author: 'Jens Reimann'
layout: page
guid: 'https://dentrassi.de/?page_id=770'
spacious_page_layout:
    - default_layout
---

This is my cheat sheet for the RPM file format. While there is an article about the RPM file format, it is far from complete. Still, have a look: <http://rpm.org/wiki/DevelDocs/FileFormat>

## Lead

The lead section seems to be pretty much dead. (also see [2.3. Lead format](http://rpm.org/wiki/DevelDocs/FileFormat#a2.3.Leadformat))

## Signature header

| TAG | Type | Description |
|---|---|---|
| `SIZE` | int32\_t | The size of the package header and payload section in bytes |
| `MD5` | BLOB | The MD5 digest of the package header and payload as they are stored on the file system. |
| `SHA1HEADER` | STRING | The SHA1 digest of the package header only. Stored as lowercase hex string. |
| `PAYLOAD_SIZE` | int32\_t | The uncompressed size in bytes of the CPIO archive in the payload section. |

## Signature padding

After the signature header has been written the file is aligned to 8 bytes. This makes the following package header start of in a file index dividable by 8.

## Package header

The package header has the same format as the signature header, but does use different tags.

### Tags

| TAG | Type | Description |
|---|---|---|
| `PAYLOAD_FORMAT` | STRING | The type of the archive format, currently only `cpio` can be used. |
| `PAYLOAD_CODING` | STRING | The way the file archive is compressed: e.g. `gzip`. |
| `FILE_SIZES` | int32\_t | For each file and directory stored in the archive the size in bytes. Directories do count 4096 each. |

## Payload data

The payload data is the actual file data. It is a CPIO archive, compressed either by GZIP, BZIP2 or XZ. Also see tags PAYLOAD\_FORMAT and PAYLOAD\_CODING.

Also see:

- <https://www.redhat.com/archives/rpm-list/2000-December/msg00217.html>