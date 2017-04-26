require 'cgi'
require 'json'
require 'excon'
require 'tempfile'
require 'base64'
require 'find'
require 'rubygems/package'
require 'uri'
require 'open-uri'

# Add the Hijack middleware at the top of the middleware stack so it can
# potentially hijack HTTP sockets (when attaching to stdin) before other
# middlewares try and parse the response.
require 'excon/middlewares/hijack'
Excon.defaults[:middlewares].unshift Excon::Middleware::Hijack

Excon.defaults[:middlewares] << Excon::Middleware::RedirectFollower

# The top-level module for this gem. Its purpose is to hold global
# configuration variables that are used as defaults in other classes.
module Docker
  module Swarm
    include Docker

    require 'docker/swarm/node'
    require 'docker/swarm/service'
    require 'docker/swarm/swarm'
    require 'docker/swarm/connection'
    require 'docker/swarm/task'

    module_function :default_socket_url, :env_url, :url, :url=, :env_options,
                    :options, :options=, :creds, :creds=, :logger, :logger=,
                    :connection, :reset!, :reset_connection!, :version, :info,
                    :ping, :authenticate!, :validate_version!, :ssl_options
  end
end
