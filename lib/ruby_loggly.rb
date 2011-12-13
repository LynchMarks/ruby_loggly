require 'rest_client'
require 'json'

class Loggly
  def initialize(options)
    @subdomain = options[:subdomain]
    @user = options[:user]
    @pass = options[:pass]
    @key = options[:key]
    @ec2 = options[:ec2] ||= false
  end

  def log(log_data)
    ec2flag = @ec2 ? 'ec2.' : ''
    RestClient.post("https://#{ec2flag}logs.loggly.com/inputs/#{@key}", log_data)
  end

  def search(query)
    response = RestClient.get("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/search", {:params => {:q => query}})
    yield response.to_str if block_given?
  end

  def list_inputs
    response = RestClient.get("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/inputs/")
		response_array=JSON.parse(response.to_str)
    yield response_array if block_given?
		response_array
  end
	def get_input(options)
    response = RestClient.get("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/inputs/#{options[:id]}")
		input_hash=JSON.parse(response.to_str)
    yield input_hash if block_given?
		input_hash
	end
	def add_input(options)
    response = RestClient.post("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/inputs/", :name=>options[:name],:description=> options[:description],:service=>options[:service])
		response.code==201 ? true : false
	end
	def remove_input(options)
    response = RestClient.delete("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/inputs/#{options[:id]}")
		response.code==204 ? true : false
	end
	def list_devices
    response = RestClient.get("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/devices/")
		response_array=JSON.parse(response.to_str)
    yield response_array if block_given?
		response_array
	end
	def add_device(options)
    response = RestClient.post("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/devices/",:ip=>options[:ip],:input_id=>options[:input_id])
		response.code==201 ? true : false
	end
	def remove_device(options)
    response = RestClient.delete("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/devices/#{options[:id]}")
		response.code==204 ? true : false
	end
	def get_device(options)
    response = RestClient.get("https://#{@user}:#{@pass}@#{@subdomain}.loggly.com/api/devices/#{options[:id]}")
		device=nil
		device_hash=JSON.parse(response.to_str)
    yield device_hash if block_given?
		device_hash 
	end
end
