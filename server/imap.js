Meteor.startup(function() {
    Fiber = Npm.require('fibers');
    time = setInterval(function() {
        console.log("Starting IMAP");
        var Imap = Npm.require('imap'),
            inspect = Npm.require('util').inspect;

        var imap = new Imap({
            user: 'nicolas@marsmoore.com',
            password: 'MarsBloom07',
            host: 'imap.gmail.com',
            port: 993,
            tls: true
        });

        function findAttachmentParts(struct, attachments) {
            attachments = attachments ||  [];
            for (var i = 0, len = struct.length, r; i < len; ++i) {
                if (Array.isArray(struct[i])) {
                    findAttachmentParts(struct[i], attachments);
                } else {
                    if (struct[i].disposition && ['INLINE', 'ATTACHMENT'].indexOf(struct[i].disposition.type) > -1) {
                        attachments.push(struct[i]);
                    }
                }
            }
            return attachments;
        }
        function buildAttMessageFunction(attachment) {
            var filename = attachment.params.name;
            var encoding = attachment.encoding;

            console.log("encoding: " + encoding);
            debugger;

        }
        function addToSharedocs(text) {
            Fiber(function() {

            });
        }
        function openInbox(cb) {
            imap.openBox('INBOX', true, cb);
        }

        imap.once('ready', function() {
            console.log("Imap is ready");
            openInbox(function(err, box) {
                if (err) throw err;
                //var f = imap.seq.fetch('1:30', {
                //bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
                //struct: true
                //});
                imap.search(['ALL',['SUBJECT', 'aertsuploaded']], function(err, results) {
                    if (err) throw err;
                    if(results.length > 0) {
                        var f = imap.fetch(results, {
                            bodies: ['HEADER.FIELDS (FROM TO SUBJECT DATE BODY)'],
                            struct: true
                        });
                        f.on('message', function(msg, seqno) {
                            console.log('Message #%d', seqno);
                            var prefix = '(#' + seqno + ') ';
                            msg.on('body', function(stream, info) {
                                if (info.which === 'TEXT')
                                    console.log(prefix + 'Body [%s] found, %d total bytes', inspect(info.which), info.size);
                                var buffer = '', count = 0;
                                stream.on('data', function(chunk) {
                                    count += chunk.length;
                                    buffer += chunk.toString('utf8');

                                    console.log("BUFFER", buffer)

                                });
                                stream.once('end', function() {
                                    console.log("Priour entering fiber");
                                    Fiber(function(){
                                        console.log("entering fiber");
                                        console.log(prefix + 'Parsed header: %s', inspect(Imap.parseHeader(buffer)));
                                        Meteor.call("createSharedocFDL", Imap.parseHeader(buffer).subject[0]);

                                    }).run();
                                });
                            });
                            msg.once('end', function() {
                                console.log(prefix + 'Finished');
                            });
                        });
                        f.once('error', function(err) {
                            console.log('Fetch error: ' + err);
                        });
                        f.once('end', function() {
                            console.log('Done fetching all messages!');
                            imap.end();
                        });

                    }
                });
            });
        });

        imap.once('error', function(err) {
            console.log(err);
        });

        imap.once('end', function() {
            console.log('Connection ended');
        });

        imap.connect();
    },360000);
});
