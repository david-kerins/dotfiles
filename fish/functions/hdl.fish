function hdl --description 'Recreate Omarchy Herdr Dev Layout with editor, AI agent, and shell'
    # Default to open code / standard shell if no agent is specified
    set -l agent opencode
    if test (count $argv) -gt 0
        # Expand common agent shortcuts like Omarchy does
        switch $argv[1]
            case c
                set agent opencode
            case cx
                set agent claude-code
            case cy
                set agent cursor
            case *
                set agent $argv[1]
        end
    end

    # Ensure a background herdr session is active or attached
    if not herdr status >/dev/null 2>&1
        # Launch a fresh layout sequence if starting new
        herdr new-workspace (basename (pwd))
    end

    # 1. Open the primary Text Editor pane (defaults to nvim / editor)
    if set -q EDITOR
        herdr split-pane --horizontal --command "$EDITOR ."
    else
        herdr split-pane --horizontal --command "nvim ."
    end

    # 2. Slice the right side to host the AI Assistant pane
    herdr split-pane --vertical --command "$agent"

    # 3. Final slice creates the generic interactive terminal floor
    herdr split-pane --vertical

    # Reattach immediately to the structured session layout
    herdr attach
end
