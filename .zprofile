
if [ `uname -s` == "Darwin"]; then
	# Added by Toolbox App
	export PATH="$PATH:/Users/bolster/Library/Application Support/JetBrains/Toolbox/scripts"
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ `uname -s` == "Linux" ]; then
	
fi

