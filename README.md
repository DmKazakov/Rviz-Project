# Постановка задачи
Проект связан с 3D визуализатором RViz, одна из проблем которого заключается в том, что буфер для преобразования координат хранит информацию 10 последних минут, в чем не всегда есть необходимость и что в некоторых случаях приводит к значительному потреблению памяти. Цель - предоставить пользователю возможность самому выбирать нужный ему размер буфера.

# Описание решения
В репозиторий помещены следующие измененные файлы:
+ src/rviz/src/rviz/visualizer_app.cpp
+ src/rviz/src/rviz/frame_manager.h
+ src/rviz/src/rviz/frame_manager.cpp
+ src/rviz/src/rviz/visualization_frame.h
+ src/rviz/src/rviz/visualization_frame.cpp
+ src/rviz/src/rviz/visualization_manager.h
+ src/rviz/src/rviz/visualization_manager.cpp

В visualizer_app.cpp была добавлена обработка нового ключа: tf-buffer, за которым в командной строке должен следовать желаемый размер буфера в секундах. Значение переменной с данным параметром передается между фунциями и методами в вышеперечисленных файлах и доходит до конструктора FrameManager, где и происходит инициализация размера. Если ключ не указан, то значением по умолчанию будет 1 минута.

# Тестирование
Для начала нужно заменить исходные файлы на файлы из репозитория и скомпилировать. Убедимся в изменении размера буфера, пронаблюдав за потреблением памяти. Для примера будем использовать turtleslim.  

В первом терминале выполняем команду:  
`roslaunch turtle_tf turtle_tf_demo.launch`  

Во втором запускаем rviz с буфером в 30 секунд:  
`rosrun rviz rviz tf-buffer 30 -d 'rospack find turtle_tf'/rviz/turtle_rviz.rviz`  

