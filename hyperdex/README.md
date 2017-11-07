

Install hyperdex
`ansible-playbook hyperdex_install.yml`

Start coordinator and daemons process
`ansible-playbook hyperdex_start.yml`

Init database and space, make a copy into hyperdex.db.bak
`ansible-playbook hyperdex_init.yml`

Stop database process without deleting hyperdex.db
`ansible-playbook hyperdex_install.yml`

Clean hyperdex.db database
`ansible-playbook hyperdex_install.yml`

do Stop and Clean together
`ansible-playbook hyperdex_stop_clean.yml`

Reload hyperdex.db from hyperdex.db.bak
QUESTION: do I need init before reload???
`ansible-playbook hyperdex_restore.yml`
