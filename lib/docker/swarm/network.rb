require 'docker-api'

class Docker::Swarm::Network 
  attr_reader :hash
  
  def initialize(swarm, hash)
    @hash = hash
    @swarm = swarm
  end
  
  def connection
    return @swarm.connection
  end
  
  def id
    return @hash['Id']
  end
  
  def name
    return @hash['Name']
  end

  def driver
    return @hash['Driver']
  end
  
  def subnets
    if (@hash['IPAM']) && (@hash['IPAM']['Config'])
      return @hash['IPAM']['Config']
    end
    return []
  end
  

  def remove
    network_name = name
    response = @swarm.connection.delete("/networks/#{id()}", {}, expects: [200, 204, 500], full_response: true)
    if (response.status > 204)
      raise "Error deleting network (#{name})  HTTP-#{response.status}  #{response.body}"
    end
    
    attempts = 0
    while (@swarm.find_network_by_name(network_name) != nil)
      sleep 1
      attempts += 1
      if (attempts > 30)
        raise "Failed to remove network: #{network_name}, operation timed out. Response: HTTP#{response.status}  #{response.body}"
      end
    end
  end
end

# EXAMPLE INSPECT OF OVERLAY NETWORK:
# {
#         "Name": "overlay1",
#         "Id": "3eluvldbrv17xw6w39xxgg30a",
#         "Scope": "swarm",
#         "Driver": "overlay",
#         "EnableIPv6": false,
#         "IPAM": {
#             "Driver": "default",
#             "Options": null,
#             "Config": [
#                 {
#                     "Subnet": "10.0.9.0/24",
#                     "Gateway": "10.0.9.1"
#                 }
#             ]
#         },
#         "Internal": false,
#         "Containers": null,
#         "Options": {
#             "com.docker.network.driver.overlay.vxlanid_list": "257"
#         },
#         "Labels": null
#     }
    