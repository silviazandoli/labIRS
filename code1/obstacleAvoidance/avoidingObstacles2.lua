--avoiding obstacles
-- Versione con l'angolo
MAX_VELOCITY = 20
MIN_VELOCITY = MAX_VELOCITY/4
MOVE_STEPS = 15

function init()
left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
end


function step()
n_steps = n_steps + 1
	if n_steps % MOVE_STEPS == 0 then
		left_v = robot.random.uniform(0,MAX_VELOCITY)
		right_v = robot.random.uniform(0,MAX_VELOCITY)
	end
-- Search for the reading with the highest value
	local value = 0 -- highest value found so far
	local idx = 0   -- index of the highest value
	local angle=0
	
	for i=1,#robot.proximity do
		if value < robot.proximity[i].value then
			idx = i
			value = robot.proximity[i].value --proximity value
			angle=robot.proximity[i].angle   --obstacle direction
		end
	end
	log("robot max proximity sensor: " .. idx .. "," .. value .. "," ..angle)
	--* If the angle of the vector is small enough and the closest obstacle
    --* is far enough, continue going straight, otherwise curve a little
    --/* Turn, depending on the sign of the angle */
    	if value == 0 then --no detection di un oggetto-> go straight
    	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
    	else
    		if angle > 0 then
    		--se l'angolo è positivo (ostacolo a sinistra) giro a destra
    		--ruoto a sinistra
    		robot.wheels.set_velocity(MAX_VELOCITY, MIN_VELOCITY)
    		else
    		--ruoto a destra
    		robot.wheels.set_velocity(MIN_VELOCITY, MAX_VELOCITY)
    		end
    		
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
