# Docker options
## Prevent Postgres from trying to allocate 25% of total memory
postgresql['shared_buffers'] = '1MB'
postgresql['shmmax'] = '16MB'
postgresql['shmall'] = '16MB'

# Manage accounts with docker
#manage_accounts['enable'] = false

# Get hostname from shell
host = `hostname`.strip
external_url "http://#{host}"

# Load custom config from environment variable: GITLAB_OMNIBUS_CONFIG
eval ENV["GITLAB_OMNIBUS_CONFIG"].to_s
