if status is-interactive
    pfetch
end
set -g fish_greeting 
switch (uname)
    case Darwin
        fish_add_path /usr/local/opt/ruby/bin
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/jre
        set -gx LDFLAGS -L/usr/local/opt/ruby/lib
        set -gx CPPFLAGS -I/usr/local/opt/ruby/include
        export HOMEBREW_NO_EMOJI=1
        export HOMEBREW_NO_ENV_HINTS=1
	export CLICOLOR=1
	export LSCOLORS=GxFxCxDxBxegedabagaced
        alias lsblk="diskutil list"
        if begin; [ (pwd) = $HOME ]; and test -z $DACS; end
	    cd $DACS
        end
        function systemctl
            if [ $argv[1] = status ]
                command brew services info $argv[2]
            else
                command brew services $argv
            end
        end
        function paru
            command pacapt $argv && brew bundle dump --file=~/Brewfile --force
        end
    case Linux
        set -gx PATH ~/.gem/ruby/2.2.0/bin $PATH
	alias ls='colorls --dark --sd --dark'
	alias cat='bat --theme=Dracula --style=plain'
        set -U fish_user_paths ~/.emacs.d/bin (ruby -e 'print Gem.user_dir')/bin $fish_user_paths
end

export GOPATH=$HOME/dev/go
export QT_QPA_PLATFORMTHEME=qt5ct


alias parurg=paru_remove_grep
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# alias emacs='devour emacsclient -c'
alias xclip='xclip -sel clip'
alias hh='npx hardhat'

abbr --add --global p paru
abbr --add --global prg parurg
abbr --add --global py 'paru -Syy'
abbr --add --global pc 'paru -c'
abbr --add --global dc docker-compose
abbr --add --global dcb 'docker-compose build --no-cache'
abbr --add --global dcd 'docker-compose down -v'
abbr --add --global dcub 'docker-compose up --build -d'
abbr --add --global dcu 'docker-compose up -d'
abbr --add --global dcs 'docker container stop (docker container ls -aq)'
abbr --add --global dcrm 'docker container rm -f (docker container ls -aq)'
abbr --add --global dirm 'docker image rm -f (docker image ls -q)'
abbr --add --global df dotfiles
abbr --add --global dfp 'dotfiles fetch && dotfiles pull'
abbr --add --global dfr 'dotfiles reset (dotfiles commit-tree HEAD^{tree} -m "A new start") '
abbr --add --global dfrh 'dotfiles fetch && dotfiles reset --hard @{u}'
abbr --add --global e emacs
abbr --add --global se sudo_emacs
abbr --add --global es 'rm -rf ~/.emacs.d/.local/straight && doom sync'
abbr --add --global et 'emacsclient -t'
abbr --add --global ga 'git add'
abbr --add --global gb 'git checkout'
abbr --add --global gc 'git commit -m'
abbr --add --global gca 'git commit -a -m'
abbr --add --global gdm 'git branch --merged | egrep -v "(^\*|main|dev)" | xargs git branch -d'
abbr --add --global gf 'git fetch'
abbr --add --global gl 'git log'
abbr --add --global gm 'git merge'
abbr --add --global gp 'git push -u'
abbr --add --global gs 'git status'
abbr --add --global grh 'git fetch && git reset --hard @{u}'
abbr --add --global grs 'git reset --soft HEAD~'
abbr --add --global s systemctl
abbr --add --global gcco 'gcc -g -Wall -Wextra -o'
abbr --add --global gccc 'gcc -g -Wall -Wextra -c'
abbr --add --global v vim

thefuck --alias | source
starship init fish | source
