require 'spec_helper'

describe Loggly do

  before(:all) do
    @test_subdomain = 'example'
    @test_user = 'user'
    @test_pass = 'pass'
    @test_key = '123456'
    @loggly = Loggly.new(
      :subdomain => @test_subdomain, 
      :user => @test_user, 
      :pass => @test_pass, 
      :key => @test_key
    )
  end

  describe "#device" do
		describe "#list" do
    	it "should generate an appropriate RestClient GET" do
    	  RestClient.should_receive(:get).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/" ).and_return(mock('response', :to_str=>"{}"))
				@loggly.list_devices
   	  end
			it "should execute a callback when its provided" do
      	Kernel.should_receive(:print).with({})
    	  RestClient.should_receive(:get).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/" ).and_return(mock('response', :to_str=>"{}"))
				@loggly.list_devices{|data|Kernel.print data}
			end
			it "should  return device data" do
    	  RestClient.should_receive(:get).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/" ).and_return(mock('response', :to_str=>"{}"))
				@loggly.list_devices.should == {}
			end
		end
		describe "#get" do
    	it "should generate an appropriate RestClient GET" do
    	  RestClient.should_receive(:get).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/1").and_return(mock('response', :to_str=>"{}"))
				@loggly.get_device(:id=>1)
   	  end
			it "should execute a callback when its provided" do
      	Kernel.should_receive(:print).with({})
    	  RestClient.should_receive(:get).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/1" ).and_return(mock('response', :to_str=>"{}"))
				@loggly.get_device(:id=>1){|data|Kernel.print data}
			end
			it "should  return data" do
    	  RestClient.should_receive(:get).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/1" ).and_return(mock('response', :to_str=>"{}"))
				@loggly.get_device(:id=>1).should == {}
			end
		end
		describe "#add" do
    	it "should generate an appropriate RestClient POST" do
    	  RestClient.should_receive(:post).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/",:ip=>'127.0.0.1',:input_id=>1).and_return(mock('response', :code=>201))
				@loggly.add_device(:input_id=>1,:ip=>'127.0.0.1')
   	  end
			it "should return true for HTTP 201 requests" do
    	  RestClient.should_receive(:post).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/",:ip=>'127.0.0.1',:input_id=>1).and_return(mock('response', :code=>201))
				@loggly.add_device(:input_id=>1,:ip=>'127.0.0.1').should be_true
			end
			it "should return false for HTTP non 201 requests" do
    	  RestClient.should_receive(:post).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/",:ip=>'127.0.0.1',:input_id=>1).and_return(mock('response', :code=>500))
				@loggly.add_device(:input_id=>1,:ip=>'127.0.0.1').should be_false
			end
		end
		describe "#remove" do
    	it "should generate an appropriate RestClient DELETE" do
    	  RestClient.should_receive(:delete).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/1").and_return(mock('response', :code=>204))
				@loggly.remove_device(:id=>1)
   	  end
			it "should  return true for HTTP 204 calls" do
    	  RestClient.should_receive(:delete).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/1").and_return(mock('response', :code=>204))
				@loggly.remove_device(:id=>1).should be_true
			end
			it "should  return true for HTTP non 204 calls" do
    	  RestClient.should_receive(:delete).with( "https://#{@test_user}:#{@test_pass}@#{@test_subdomain}.loggly.com/api/devices/1").and_return(mock('response', :code=>400))
				@loggly.remove_device(:id=>1).should be_false
			end
		end
	end
end

