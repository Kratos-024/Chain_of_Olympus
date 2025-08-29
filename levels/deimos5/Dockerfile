# Use a specific version for reproducibility
FROM alpine:latest

# Install all necessary tools, including nmap and coreutils.
RUN apk add --no-cache bash openssh python3 nmap coreutils nano util-linux

# --- 1. Create the 'pyrun' Gatekeeper Script ---
RUN cat <<'EOF' > /usr/local/bin/pyrun
#!/bin/sh
ALLOWED_DIR="/home/deimos4/pythonScripts"
if [ -z "$1" ]; then
    echo "Usage: python3 <path_to_your_script.py>"
    exit 1
fi
USER_SCRIPT="$1"

ABSOLUTE_PATH=$(realpath -m -- "$USER_SCRIPT")
case "$ABSOLUTE_PATH" in
    "$ALLOWED_DIR"/*)
        timeout 10s python3 - "$USER_SCRIPT" <<PYEOF
import sys
user_script_path = sys.argv[1]
safe_builtins = {"print":print, "open":open, "len":len, "ord":ord, "chr":chr, "range":range, "int":int, "str":str, "Exception":Exception}
safe_globals = {"__builtins__": safe_builtins}
try:
    with open(user_script_path, "r") as f:
        user_code = f.read()
    exec(user_code, safe_globals, {})
except FileNotFoundError:
    print(f"Error: Script '{user_script_path}' not found.", file=sys.stderr)
except Exception as e:
    print(f"An error occurred: {e}", file=sys.stderr)
PYEOF
        ;;
    *)
        echo "Error: Access denied. Scripts can only be run from $ALLOWED_DIR"
        exit 1
        ;;
esac
EOF
RUN chmod +x /usr/local/bin/pyrun

# --- 2. Create the Global Shell Alias ---
RUN echo "alias python3='/usr/local/bin/pyrun'" > /etc/profile.d/python_alias.sh

# --- 3. User, Directory, and SSH Setup (CORRECTED ORDER) ---

# STEP 1: Create the user. This will correctly create the /home/deimos4 DIRECTORY.
RUN adduser -D -s /bin/bash deimos4 && \
    echo 'deimos4':'selphariontukez' | chpasswd

# STEP 2: Create the required subdirectory now that the parent exists.
RUN mkdir -p /home/deimos4/pythonScripts

# STEP 3: Copy files INTO the user's home directory. Note the trailing slash.
COPY credentials.txt /home/deimos4/

# STEP 4: Set ownership for everything inside the home directory.
RUN chown -R deimos4:deimos4 /home/deimos4

# Configure and expose SSH.
RUN ssh-keygen -A && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
EXPOSE 22

# Start the SSH server to allow connections.
CMD ["/usr/sbin/sshd", "-D"]
