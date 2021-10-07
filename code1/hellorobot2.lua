--doing phototaxis
MAX_VELOCITY = 10
MIN_VELOCITY = MAX_VELOCITY/4

function init()
end

function light_detection()
	sensor_detected = -1
	intensity = -1
	for sensor_index, light_sensor in pairs(robot.light) do
		local current_value = light_sensor.value
		log("sensor: " .. sensor_index .. ", intensity: " .. current_value .. ", radians: " .. light_sensor.angle)
		
		if current_value > intensity then
			intensity = current_value
			sensor_detected = sensor_index
		end
	end
	log("sensor detected: " .. sensor_detected .. ", intensity: " .. intensity)
end

function is_light_in_front()
	return (1 <= sensor_detected and sensor_detected <= 3) or
			(22 <= sensor_detected and sensor_detected <= 24)
end

function is_light_on_left()
	return 4 <= sensor_detected and sensor_detected <= 12
end

function go_away()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
end

function turn_left()
	robot.wheels.set_velocity(MIN_VELOCITY, MAX_VELOCITY)
end

function turn_right()
	robot.wheels.set_velocity(MAX_VELOCITY, MIN_VELOCITY)
end

function step()
	light_detection()
	
	if is_light_in_front() then
		go_away()
	elseif is_light_on_left() then
		turn_left()	
	else
		turn_right()
	end
end

function reset()
end

function destroy()
end
