--avoiding obstacles
-- /* Do we have an obstacle in front? */
--Yes, we do: avoid it
--/* The obstacle is on the left, turn right *
-- /* The obstacle is on the right, turn left */
-- There isn't any obstacle in front, go straight
MAX_VELOCITY = 20
MIN_VELOCITY = MAX_VELOCITY/4
MOVE_STEPS = 15
n_steps = 0
function init()
left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
end

function object_detection()
	sensor_detected = -1
	proximity = -1
	for sensor_index, proximity_sensor in pairs(robot.proximity) do
		local current_value = proximity_sensor.value
		log("sensor: " .. sensor_index .. ", intensity: " .. current_value .. ", radians: " .. proximity_sensor.angle)
		
		if current_value > proximity then -- Search for the reading with the highest value
			proximity = current_value
			sensor_detected = sensor_index
		end
	end
	log("sensor detected: " .. sensor_detected .. ", intensity: " .. proximity)
end

function is_object_in_front()
	return (1 <= sensor_detected and sensor_detected <= 3) or
			(22 <= sensor_detected and sensor_detected <= 24)
end

function is_object_on_left()
	return 4 <= sensor_detected and sensor_detected <= 12
end

function go_straight()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
end

function turn_left()
	robot.wheels.set_velocity(MIN_VELOCITY, MAX_VELOCITY)
end

function turn_right()
	robot.wheels.set_velocity(MAX_VELOCITY, MIN_VELOCITY)
end

function step()
---il robot deve avere una random walk
	n_steps = n_steps + 1
	if n_steps % MOVE_STEPS == 0 then
		left_v = robot.random.uniform(0,MAX_VELOCITY)
		right_v = robot.random.uniform(0,MAX_VELOCITY)
	end
	robot.wheels.set_velocity(left_v,right_v)

	--DO WE HAVE AN OBSTACLE IN FRONT?	
	object_detection()
	--yes,avoid it
	if is_object_in_front() then
		--
	  if is_object_on_left() then
		turn_right()	
	  else
		turn_left()
	  end
	else
	--se l'oggetto non è di fronte a te vai avanti
	    go_straight()
	end
end

function reset()
left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
end

function destroy()
end
