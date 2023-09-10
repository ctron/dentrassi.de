---
id: 137
title: 'Bye bye Lotus Notes'
date: '2011-12-12T10:19:53+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=137'
permalink: /2011/12/12/bye-bye-lotus-notes/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Infrastructure
---

We used it for some time. It was nice. But now our ways seem to …

well, let me just say: PNG, 64bit Linux, Windows 7, …

I was migrating E-Mails from Notes to Courier IMAP using “[imapsync](http://freecode.com/projects/imapsync)” when I stumbled over two strange problems…

<!-- more -->

# Missing “sent” folder

I was not able to synchronize the “Sent” folder. Since the “Sent” folder does not seem to exists in the IMAP namespace and also Notes seems to have two sent folders (one for Notes one for IMAP). In the recent 8.5.2 release a new “IMAP Folder Sync” option was added (see <http://www.dominopower.com/issues/issue201103/00002621001.html>) that should fix this issue. Since we had 8.5.2 installed I tried and failed. This feature instantly caused a deadlock in the Domino server when the mail file was accessed with a write operation. In addition the “Sent” folder was absent. Event running “convert” in the mail file locked the server up and resolved nothing. The only “solution” was to create a “SentXX” folder (or any other name) and copy the messages in Notes to that folder, synchronizing the folder and move the messages back to the “Sent” folder in Courier IMAP.

# IMAP Idle/Lookup/Protocol error

Converting e-mails takes some time and for some users the process just stopped with a timeout message like this:

`Could not fetch message #123 from MyFolder timeout waiting 600s for data from server`

Re-running the task continued with the messages that were not converted up to now (thanks to imapsync) but immediately stopped at the first message with the same timeout. Looking on the domino server side I noticed that the “imap” process was idling at 0% CPU load, which is strange since it normally takes up to 200% when converting messages.

Running “imapsync” the flags –debug and –debugimap showed a strange response in the protocol stream at the end of attachments:

While the normal response seem to be something like:

`10 OK FETCH completed`

in these cases the response was:

`10 O   K FETCH completed` (or something similar).

Which was not interpreted by “imapsync” as response and kept it waiting until it timed out.

Scrolling up in the log file a little bit showed the message that caused the problem and fiddling around with the message a little bit provided a workaround that helped.

Locate the message in the mail file. Open it. Edit the message (e.g. by double clicking the content). Make no changes! (You could but you should not since you don’t want to edit received mail). And “Save and close” the message. Et voilá, it worked. Re-running “imapsync” did convert this message and successfully all following until it runs in the next timeout.

I hope this helps anybody running into the same issues.

Bye bye Notes!

PS: I used the following parameters with imapsync:

`imapsync --host1 domino.mydomain.com --user1 "Ford Prefect" --passfile1 passfile1 --ssl1 --authmech1 PLAIN --host2 localhost --user2 ford.prefect@mydomain.com --passfile2 passfile2 --ssl2 --authmech2 PLAIN --skipsize  --nofoldersizes  --regextrans2 "s/\\\\/\\./g"  --useheader Subject --useheader Date  --allowsizemismatch --skipsize  --regextrans2 "s/\\//_/g" --include "^Folder Prefix"`

`--useheader Date --useheader Subject` : was necessary since Notes seemed to change the message IDs, which caused duplicate messages each time imapsync was run. These two arguments limited the equality of messages to Subject and Date, which was OK for me.

`--nofoldersizes` : stopped imapsync from calculating the size of the folder before it runs. This caused a huge speedup since this seems to be a major task for notes to provide this operation.

`--skipsize --allowsizemismatch` : also was required to prevent imapsync from canceling messages that had another amount of payload data than the header suggested. Notes sometimes reported wrong message sizes which could be the same issue as the protocol error above.

`--regextrans2 "s/\\\\/\\./g"` : was necessary since imapsync sometimes did not apply the IMAP namespace and prefix correctly when using regular expressions for the folder names.

`--regextrans2 "s/\\//_/g"` : was necessary since Lotus Notes allows “/” in the folder name, which Courier IMAP does not. So all “/” where converted to “\_” for the moment.

`--include "^Folder Prefix"` : was quite useful to limit the imapsync run to a specific folder name if you need to close in on some issues or want more control on the current migration. Leaving out this parameter simply converts all folders.

PPS: Running “imapsync” seemed to be extremely slow before enabling specific IMAP features in the Notes mail files. I had to run “convert” for each file file in order to enable IMAP folder references and generate IMAP specific attributes. This could be due to the fact that we never used IMAP in Notes and therefore had IMAP features not enabled. Which prevents Notes from creating these information during normal runtime. This information is the generated “on demand” but not stored.

Enable IMAP for mailfile: `load convert -e mail/mailfile.nsf`  
Enable IMAP folder references: `load convert -m mail/mailfile.nsf`  
Generate IMAP attributes: `load convert -h mail/mailfile.nsf`
