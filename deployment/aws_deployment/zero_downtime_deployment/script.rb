require 'json'

def get_total_instance_connected_to_load_balancer (load_balancer_instances_description_hash)
	return load_balancer_instances_description_hash["InstanceStates"].length
end

def total_instance_in_service (load_balancer_instances_description_hash)
	instance_in_service = 0
	load_balancer_instances_description_hash["InstanceStates"].each do |instance_state|
		if instance_state["State"] == "InService"
			instance_in_service = instance_in_service + 1
		end
	end
	return instance_in_service
end

def make_instance_id_to_ip_hash load_balancer_instances_description_hash
	instance_id_to_ip_address_hash = Hash.new
	load_balancer_instances_description_hash["InstanceStates"].each do |instance_state|
		instance_id = instance_state["InstanceId"]
		instance_description_response = `aws ec2 describe-instances --instance-id #{instance_id}`
		instance_description = JSON.parse(instance_description_response)
		ip_address = instance_description["Reservations"][0]["Instances"][0]["PublicIpAddress"]
		puts ip_address
		instance_id_to_ip_address_hash["#{instance_id}"] = "#{ip_address}"
	end
	return instance_id_to_ip_address_hash
end


def deregister_deploy_register instance_id_to_ip_address_hash, name_of_load_balancer
	instance_id_to_ip_address_hash.each do |key, value|
		puts "================================================================================="
		puts "De-registering #{value} from load balancer"
		deregister_instance(key, name_of_load_balancer)
		puts "Deregistered"
		puts "Deploying in #{value} instance"
		system("ssh -i ~/Downloads/test.pem ubuntu@#{value} <<'ENDSSH' \n ls")
		puts "Deployed in #{value} instance"
		puts "Registering #{value} with load balancer"
		register_instance(key, name_of_load_balancer)
		wait_till_instance_is_in_service(key, name_of_load_balancer)
		puts "================================================================================="
	end

end

def deregister_instance instance_id, name_of_load_balancer
	`aws elb deregister-instances-from-load-balancer --load-balancer-name #{name_of_load_balancer} --instances #{instance_id}`
end

def register_instance instance_id, name_of_load_balancer
	`aws elb register-instances-with-load-balancer --load-balancer-name #{name_of_load_balancer} --instances #{instance_id}`
end

def wait_till_instance_is_in_service instance_id, name_of_load_balancer
	while !instance_is_in_service?(instance_id, name_of_load_balancer) do
	end
end


def instance_is_in_service? instance_id, name_of_load_balancer
	load_balancer_insrance_data_hash = get_load_balancer_particular_instance_data instance_id, name_of_load_balancer
	return load_balancer_insrance_data_hash["InstanceStates"][0]["State"] == "InService"
end

def get_load_balancer_data (name_of_load_balancer)
	load_balancers_instance_description_command = "aws elb describe-instance-health --load-balancer-name #{name_of_load_balancer}"
	puts load_balancers_instance_description_command
	load_balancer_instances_description = `#{load_balancers_instance_description_command}`
	puts load_balancer_instances_description
	return JSON.parse(load_balancer_instances_description)
end

def get_load_balancer_particular_instance_data instance_id, name_of_load_balancer
	load_balancers_instance_description_command = "aws elb describe-instance-health --load-balancer-name #{name_of_load_balancer} --instances #{instance_id}"
	puts load_balancers_instance_description_command
	load_balancer_instances_description = `#{load_balancers_instance_description_command}`
	puts load_balancer_instances_description
	return JSON.parse(load_balancer_instances_description)
end



name_of_load_balancer = "test-load-balancers" 
load_balancer_instances_description_hash = get_load_balancer_data(name_of_load_balancer)
instances_id_to_ip_address_hash = make_instance_id_to_ip_hash(load_balancer_instances_description_hash)
total_instances = get_total_instance_connected_to_load_balancer (load_balancer_instances_description_hash)
total_instances_in_service = total_instance_in_service (load_balancer_instances_description_hash)
puts "================================================================================="
puts "Total Instances InService is #{total_instances_in_service} out of #{total_instances}"
puts "================================================================================="
puts "Starting deployment >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
deregister_deploy_register(instances_id_to_ip_address_hash, name_of_load_balancer)
puts "Deployment done >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

