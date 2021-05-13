#! /bin/env python3
"""
Environment variables:

    DIGITALOCEAN_ACCESS_TOKEN
        The token to use to authenticate to the DigitalOcean API.
"""

import os
import sys
import subprocess
from pathlib import Path

import digitalocean


def prompt_select(
    prompt,
    options,
    formatter,
    multiple=False,
    default=None,
    allow_none=False,
):
    options = list(options)
    while True:
        print()
        print(prompt)
        default_idx = None
        for i, opt in enumerate(options):
            print(f'  {i}: {formatter(opt)}')
            if default and opt.slug == default:
                default_idx = i
        print()

        try:
            how_many = {
                (True, True): 'zero or more',
                (True, False): 'one or more',
                (False, True): 'zero or one',
                (False, False): 'one',
            }[(multiple, allow_none)]

            result = set(
                map(
                    int,
                    input('Enter {} of the indexes{}: '.format(
                        how_many,
                        f' [{default_idx}]' if default else '',
                    )).split(),
                ))

            if len(result) == 0:
                if default:
                    if multiple:
                        return [options[default_idx]]
                    else:
                        return options[default_idx]
                elif allow_none:
                    return None
                continue
            elif len(result) == 1:
                if multiple:
                    return [options[list(result)[0]]]
                else:
                    return options[list(result)[0]]
            elif multiple is False:
                continue
            else:
                return [options[i] for i in result]
        except Exception:
            # Could be something that wasn't a number, invalid index, etc.
            # Regardless, reprompt.
            pass


def prompt_proceed(prompt):
    while True:
        proceed = input(prompt + ' [yN]: ')
        if proceed in ('y', 'Y'):
            return True
        elif proceed in ('n', 'N', ''):
            return False


token = (os.environ.get('DIGITALOCEAN_ACCESS_TOKEN')
         or input('DigitalOcean Access Token: '))

print(f'Using Access Token: {token}')
manager = digitalocean.Manager(token=token)

ips = manager.get_all_floating_ips()
floating_ip_str = os.environ.get('DROPLET_FLOATING_IP')
floating_ip_to_use = None if not floating_ip_str else [
    i for i in ips if i.ip == floating_ip_str
][0]
if not floating_ip_to_use:
    floating_ip_to_use = prompt_select(
        'Which floating IP do you want to assign to the droplet?',
        ips,
        lambda i: str(i),
        allow_none=True,
    )

# Prompt for the keys to auto-add to the droplet.
keys_to_use = prompt_select(
    'Which SSH keys do you want to be able to access the machine?',
    manager.get_all_sshkeys(),
    lambda s: s.name,
    multiple=True,
)

name = os.environ.get('DROPLET_NAME') or input('Droplet name: ')

region = os.environ.get('DROPLET_REGION')
if not region:
    region = prompt_select(
        'Which droplet region do you want to use?',
        manager.get_all_regions(),
        lambda r: f'{r.name}: {r.slug}',
        default='sfo2',
    ).slug

size = os.environ.get('DROPLET_SIZE')
if not size:
    size = prompt_select(
        'Which droplet size do you want to use?',
        filter(lambda m: m.memory <= 8192, manager.get_all_sizes()),
        lambda s: f'{s.memory}MiB/{s.disk}GiB@${s.price_monthly}/mo: {s.slug}',
        default='s-1vcpu-1gb',
    ).slug

image = os.environ.get('DROPLET_IMAGE')
if not image:
    image = prompt_select(
        'Which droplet size do you want to use?',
        filter(
            lambda i: (i.slug is not None and region in i.regions and
                       ('ubuntu' in i.slug or 'fedora' in i.slug)),
            manager.get_all_images(),
        ),
        lambda i: f'{i.name}: {i.slug}',
        default='ubuntu-16-04-x64',
    ).slug

# Extract all of the secrets and create runcmds for the initial sync.
cwd = Path(__file__).parent.resolve()
subprocess.run(
    [str(cwd.joinpath('secrets_file_manager.sh')), 'extract'],
    capture_output=True,
)
secrets = cwd.joinpath('secrets')
secrets_runcmds = []
for path in secrets.iterdir():
    with open(path, 'r') as f:
        lines = [
            l.strip().replace('"', r'\"').replace('`', r'\`')
            for l in f.readlines()
        ]
        for line in lines:
            secrets_runcmds.append(
                f'  - echo "{line}" >> /etc/nixos/secrets/{path.name}')

secrets_runcmds = '\n'.join(secrets_runcmds)

user_data = f'''#cloud-config

runcmd:
  - apt install -y git
  - git clone https://git.sr.ht/~sumner/infrastructure /etc/nixos
  - mkdir -p /etc/nixos/secrets
{secrets_runcmds}
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIXOS_IMPORT=./host.nix NIX_CHANNEL=nixos-unstable bash 2>&1 | tee /tmp/infect.log
'''

floating_ip_text = '\n' if not floating_ip_to_use else f'''
The following floating IP will be assigned to the machine:
    {floating_ip_to_use.ip}
'''

print()
print('=' * 80)
print('SUMMARY:')
print('=' * 80)
print(f'''
A droplet named "{name}" with initial image of "{image}" and size
"{size}" will be created in the {region} region.

The following SSH keys will be able to access the machine:
    { ', '.join(map(lambda k: k.name, keys_to_use))}
{floating_ip_text}
It will be configured with the following cloud configuration:

{user_data}''')

if not prompt_proceed(
        'Would you like to create a droplet with this configuration?'):
    print('Cancelling!')
    sys.exit(1)

droplet = digitalocean.Droplet(
    backups=False,
    image=image,
    ipv6=True,
    name=name,
    private_networking=True,
    region=region,
    size_slug=size,
    ssh_keys=keys_to_use,
    tags=[],
    token=token,
    user_data=user_data,
)

print('Creating...', end=' ')
droplet.create()

if floating_ip_to_use:
    floating_ip_to_use.assign(droplet.id)

print('DONE')
