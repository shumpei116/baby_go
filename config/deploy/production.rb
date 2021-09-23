server "35.76.64.33", user: "shumpei", roles: %w{app db web}

set :ssh_options, {
  keys: (ENV['PRODUCTION_SSH_KEY']),
  forward_agent: true,
  auth_methods: %w(publickey),
}
