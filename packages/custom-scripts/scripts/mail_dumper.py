#!/usr/bin/env python3

import imaplib, os, sys

if len(sys.argv) < 5:
    print(f'usage: {sys.argv[0]} <host> <user> <pass> <dump_dir>')
    print(f'  e.g: {sys.argv[0]} 10.10.10.1 jonas@localhost hunter2 ./loot')
    sys.exit(1)

rhost, user, passwd, dump_dir = sys.argv[1:5]

os.makedirs(dump_dir, exist_ok=True)
mail_client = imaplib.IMAP4(rhost)

print(f'attempting login: {user}:{passwd}')
mail_client.login(user, passwd)

print('dumping inbox...')
mail_client.select('INBOX')
_, nums = mail_client.search(None, 'ALL')

for n in nums[0].split():
    _, data = mail_client.fetch(n, '(BODY[])')
    open(f'{dump_dir}/msg_{n.decode()}.eml', 'wb').write(data[0][1])

print(f'dumped {len(nums[0].split())} messages to {dump_dir}/')
