#!/bin/bash

min_time=$(($1 < $2 ? $1 : $2))
max_time=$(($1 > $2 ? $1 : $2))
time_quotient=$((max_time / min_time))

roslaunch turtle_tf turtle_tf_demo.launch > /dev/null 2> /dev/null &
turtle_pid=$!
rosrun rviz rviz -t "$min_time" -d `rospack find turtle_tf`/rviz/turtle_rviz.rviz > /dev/null &
rviz_pid_1=$!
rosrun rviz rviz -t "$max_time" -d `rospack find turtle_tf`/rviz/turtle_rviz.rviz > /dev/null &
rviz_pid_2=$!

sleep 10
initial_mem_1=$(ps aux | awk -v rviz_pid_1=$rviz_pid_1 '$2 == rviz_pid_1 { print $6 }')
initial_mem_2=$(ps aux | awk -v rviz_pid_2=$rviz_pid_2 '$2 == rviz_pid_2 { print $6 }')
initial_mem=$((initial_mem_1 < initial_mem_2 ? initial_mem_1 : initial_mem_2))
sleep $((max_time + max_time / 2))
final_mem_1=$(ps aux | awk -v rviz_pid_1=$rviz_pid_1 '$2 == rviz_pid_1 { print $6 }')
final_mem_2=$(ps aux | awk -v rviz_pid_2=$rviz_pid_2 '$2 == rviz_pid_2 { print $6 }')
buffer_size_1=$((final_mem_1 - initial_mem_1))
buffer_size_2=$((final_mem_2 - initial_mem_2))
if (( buffer_size_2 <= (buffer_size_1 * (time_quotient + 4)) && buffer_size_2 >= (buffer_size_1 * (time_quotient - 4)) )); then
	echo OK
else 
	echo Test failed
fi

kill "$rviz_pid_1"
kill "$rviz_pid_2"
kill "$turtle_pid"