#!/bin/sh
# create a new session. Note the -d flag, we do not want to attach just yet!
tmux new-session -s mining -n 'miner' -d

# send 'tail -f foo<enter>' to the first pane.
# I address the first pane using the -t flag. This is not necessary,
# I'm doing it so explicitly to show you how to do it.
# for the <enter> key, we can use either C-m (linefeed) or C-j (newline)
tmux send-keys -t mining:miner.0 'cd /home/user/mining/Claymore_ETH/ && ./start.bash' C-j

# split the window *vertically*
tmux split-window -v

# we now have two panes in myWindow: pane 0 is above pane 1
# again, specifying pane 1 with '-t 1' is optional
tmux send-keys -t mining:miner.1 'watch /home/user/mining/ROC-smi/rocm-smi' C-j
