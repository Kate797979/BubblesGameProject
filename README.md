# BubblesGameProject

Задача: Написать игру “Пузыри”

В задании предлагается реализовать функционал игры Пузыри. Игра выглядит следующим образом: по экрану движутся N точек в разных направлениях и с разной (постоянной) скоростью. Игрок кликает в любом месте экрана левой кнопкой мыши, после чего в этом месте начинает надуваться круг. Радиус круга вырастает до некоторого значения, на котором останавливается, после чего круг ещё некоторое время висит на экране, и потом очень быстро уменьшается и исчезает (в этот момент исчезнувший объект удаляем из памяти). Пока круг виден на экране, летающие точки могут врезаться в него. При столкновении точки с кругом, точка перестаёт существовать, а на её месте также рождаётся раздувающийся круг, радиус которого также увеличивается от нуля до некоторого значения. Этот круг, также как и первый, висит с максимальным радиусом некоторое время, после чего исчезает. Процесс столкновения точек и рождения таких кругов происходит до тех пор, пока на экране существует хоть бы один живой круг. Когда последний круг пропадает - уровень завершается. После чего должна быть возможность рестарта уровня, с удалением всех старых объектов и созданием новых.
