xbacklight -get | awk '{print int($1+0.5)}'
