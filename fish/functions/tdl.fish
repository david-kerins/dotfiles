function tdl --description 'Omarchy-style Tmux Dev Layout for Fish shell'
    # 1. Ensure we are already inside a Tmux session
    if not set -q TMUX
        echo "Error: 'tdl' must be run inside an active Tmux session."
        return 1
    end

    # 2. Check for missing arguments
    if test (count $argv) -eq 0
        echo "Usage: tdl <agent_alias> [optional_second_agent]"
        return 1
    end

    # 3. Resolve the first AI agent argument
    set -l agent_cmd ""
    switch $argv[1]
        case c opencode
            set agent_cmd opencode
        case cx claude
            set agent_cmd claude
        case codex
            set agent_cmd codex
        case '*'
            set agent_cmd $argv[1] # Pass-through custom binary names
    end

    # Rename the window based on the chosen agent
    set -l window_name "dev-$argv[1]"
    tmux rename-window $window_name

    # Ensure $EDITOR is fallback-protected (defaults to nvim if not set)
    set -l editor_cmd nvim
    if set -q EDITOR
        set editor_cmd $EDITOR
    end

    # 4. Handle optional second AI agent (Omarchy 3.4+ double-agent stack split)
    if test (count $argv) -ge 2
        set -l agent2_cmd ""
        switch $argv[2]
            case c opencode
                set agent2_cmd opencode
            case cx claude
                set agent2_cmd claude
            case codex
                set agent2_cmd codex
            case '*'
                set agent2_cmd $argv[2]
        end

        # Layout: Editor (Left), Top AI (Right-Top), Bottom AI (Right-Bottom), Terminal (Bottom)
        tmux split-window -h -p 50 "$agent_cmd"
        tmux split-window -v -p 50 "$agent2_cmd"
        tmux select-pane -t 0
        tmux split-window -v -p 35
        tmux select-pane -t 0
        eval $editor_cmd .
    else
        # Standard Omarchy 3-way layout: Editor (Left), AI Agent (Right), Terminal (Bottom)
        tmux split-window -h -p 40 "$agent_cmd"
        tmux select-pane -t 0
        tmux split-window -v -p 35
        tmux select-pane -t 0
        eval $editor_cmd .
    end
end
