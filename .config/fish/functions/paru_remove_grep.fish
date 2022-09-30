function paru_remove_grep
  paru -R (paru  -Q | grep -E $argv | awk '{print $1}')
end
