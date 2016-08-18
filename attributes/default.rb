# /etc/opendkim.conf
default['postfix_dkim']['domain'] = node[:fqdn]
default['postfix_dkim']['keyfile'] = '/etc/mail/dkim.key'
default['postfix_dkim']['selector'] = 'mail'
default['postfix_dkim']['autorestart'] = false
default['postfix_dkim']['sender_headers'] = nil
default['postfix_dkim']['on_bad_signature'] = 'reject'
default['postfix_dkim']['on_key_not_found'] = 'reject'
default['postfix_dkim']['on_security'] = 'discard'
default['postfix_dkim']['query_cache'] = 'no'

# /etc/default/opendkim
default['postfix_dkim']['socket'] = 'inet:8891@localhost' # Ubuntu default - listen on loopback on port 8891

# key generation
default['postfix_dkim']['testmode'] = true # Running in test mode - see "t=" on http://www.dkim.org/specs/rfc4871-dkimbase.html#key-text
