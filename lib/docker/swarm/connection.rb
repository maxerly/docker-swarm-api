# This class represents a Connection to a Docker server. The Connection is
# immutable in that once the url and options is set they cannot be changed.
module Docker
  module Swarm
    class Connection < Docker::Connection
      def request(*args, &block)
        request = compile_request_params(*args, &block)
        log_request(request)
        if args.last[:full_response] == true
          resource.request(request)
        else
          resource.request(request).body
        end
      rescue Excon::Errors::BadRequest => ex
        raise ClientError, ex.response.body
      rescue Excon::Errors::Unauthorized => ex
        raise UnauthorizedError, ex.response.body
      rescue Excon::Errors::NotFound => ex
        raise NotFoundError, ex.response.body
      rescue Excon::Errors::Conflict => ex
        raise ConflictError, ex.response.body
      rescue Excon::Errors::InternalServerError => ex
        raise ServerError, ex.response.body
      rescue Excon::Errors::Timeout => ex
        raise TimeoutError, ex.message
      end
    end
  end
end
