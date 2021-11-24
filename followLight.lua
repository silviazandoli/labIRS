--Ex lab 2
--1)Random walk 2) phototaxis 3)avoid obstacles which has the highest priority
-- Put your global variables here

--Each behavior has a flag.  When the flag is true, it is
 --the action chosen by the behavior.  An arbitrator
 --gives control to the  behavior whose flag
 --is true.The flag becomes true when the previous competence has been resolved
 
 --In this simple example, there are three behaviors: wander
 --which always wants to go in random walk, phototaxis which turns
 --towards light, and avoidObstacles which backs and turns away
 --from obstacles.   wander has the lowest priority and avoidObstacles 
 --has the highest priority.

MOVE_STEPS = 15
VELOCITY_STANDARD=20


n_steps = 0
wander_flag=true
lux_flag=false
obs_flag=false



--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
left_v = robot.random.uniform(0,VELOCITY_STANDARD)
	right_v = robot.random.uniform(0,VELOCITY_STANDARD)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0

end

--first checked have low priority and last checked have high priority.
function arbitrate()

      if(wander_flag) then
      log("wandering")
       wander()
      end
      if(lux_flag) then
      log("trought light")
      phototaxis()
      end
      if(obs_flag) then
      log("avoid")
      	avoidObstacles()
      end
   
end

function wander()
--provide a random walk
	n_steps = n_steps + 1
	if n_steps % MOVE_STEPS == 0 then
		left_v = robot.random.uniform(0,VELOCITY_STANDARD)
		right_v = robot.random.uniform(0,VELOCITY_STANDARD)
	end
	robot.wheels.set_velocity(left_v,right_v)
	log("wander")
	
	
end

function light_detection()
light_intensity = 0
light_direction = 0
	
	for sensor_index, light_sensor in pairs(robot.light) do
		local current_light_intensity = light_sensor.value
		
		if current_light_intensity > light_intensity then
			light_intensity = current_light_intensity
			light_direction = light_sensor.angle
		end
	end
	log(", intensity: " .. light_intensity)
	if(light_intensity>0) then --se vedo la luce setto  vado verso di essa
		log(",light_intensity"..light_intensity)
		lux_flag=true
	else
		lux_flag=false
end


end

function phototaxis()
light_detection()
robot.wheels.set_velocity(VELOCITY_STANDARD, VELOCITY_STANDARD)
log("doing phototasxis")

end

function obstacleDetection()
proximity_value=0
angle=0 --proximity angle
	local idx = 0   -- index of the highest value
	
	for i=1,#robot.proximity do
		if proximity_value < robot.proximity[i].value then
			idx = i
			proximity_value = robot.proximity[i].value --proximity value
			angle=robot.proximity[i].angle   --obstacle direction
		end
	end
	log("robot max proximity sensor: " .. idx .. "," .. proximity_value .. "," ..angle)
	if(proximity_value>0) then
		obs_flag=true
	else
		obs_flag=false
	end
	
end

function avoidObstacles()
obstacleDetection()
robot.wheels.set_velocity(VELOCITY_STANDARD,VELOCITY_STANDARD)
log("avoiding obstacles")
    		if angle > 0 then
    		--se l'angolo è positivo (ostacolo a sinistra) giro a destra
    		--ruoto a sinistra
    		log("robot angle: " ..angle)
    		robot.wheels.set_velocity(VELOCITY_STANDARD, 0)
    		else
    		--ruoto a destra
    		robot.wheels.set_velocity(0, VELOCITY_STANDARD)
    		end
   		
end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
wander()
phototaxis()
avoidObstacles()
arbitrate()

end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()

end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end
