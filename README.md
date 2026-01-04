# Pi-hole Controller

A lightweight, two-file (HTML + JavaScript) controller for Pi-hole 6 that lets you easily enable or disable blocking. This controller works by communicating with the Pi-hole API using an app password and supports temporary disabling with a countdown timer.

![Screenshot of Pi-hole Controller](images/controller.png)

## Overview

The Pi-hole Controller provides a simple web interface for:

- **Enabling/Disabling Blocking:** Instantly toggle blocking on your Pi-hole installation.
- **Temporary Disabling:** Disable blocking for a set duration. The controller will show a countdown timer until the blocking state is automatically restored.
- **Bookmarkable Shortcuts:** Once an action is triggered, you can bookmark or copy the URL to quickly repeat the action later.

**Pi-hole App Password:** To interact with the Pi-hole API, you must generate an app password:

- Open your Pi-hole Admin Interface.
- Navigate to **Settings → Web interface / API**.
- Switch from **Basic** to **Expert** mode.
- Click **Configure app password** and copy the generated password.

**Controller URL:** The controller builds URLs that include your Pi-hole URL, app password, and the desired action (enable/disable).

> **Security Note:** Including your app password directly in the URL can expose it if the URL is logged or shared. Make sure to safeguard this information and only share the URL with trusted parties.

**Timer Functionality:** When disabling blocking temporarily, you can select a preset duration or set a custom time. A visible countdown timer shows how long until blocking is re-enabled.

## Quick Install

SSH into your Pi-hole and install or update everything with a single command. Elevated permissions are required by the install script because it writes into `/var/www/html` and changes file permissions.

1. SSH into your Pi-hole:

   ```bash
   ssh pi@pi.hole
   ```

   _(Enter the Pi-hole password when prompted)_

2. Run the install script:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/mikeswanson/PiHoleController/main/install.sh | sudo bash
   ```

3. Exit the SSH session:

   ```bash
   exit
   ```

To update later, rerun the same command.

## Manual Install

To install or update the controller manually:

1. Download the files to a local folder:

   ```bash
   curl -o controller.html https://raw.githubusercontent.com/mikeswanson/PiHoleController/main/controller.html
   curl -o controller.js https://raw.githubusercontent.com/mikeswanson/PiHoleController/main/controller.js
   ```

2. Transfer the files to your Pi-hole:

   ```bash
   scp controller.html controller.js pi@pi.hole:~
   ```

   _(Enter the Pi-hole password when prompted)_

3. SSH into your Pi-hole:

   ```bash
   ssh pi@pi.hole
   ```

   _(Enter the Pi-hole password when prompted)_

4. Move the files to the web server directory:

   ```bash
   sudo mv ~/controller.html ~/controller.js /var/www/html
   ```

   _If you try to access the controller by its URL and see a permission denied message, run this command to enable additional read permissions: `sudo chmod 644 /var/www/html/controller.html /var/www/html/controller.js`_

   _Keep `controller.html` and `controller.js` in the same directory._

5. Exit the SSH session:

   ```bash
   exit
   ```

### Enable Web Serving

From the Pi-hole Admin Interface, navigate to **Settings → All settings → Webserver and API → webserver.serve_all** and set it to **Enabled**.

Now, you can access the controller by navigating to `https://pi.hole/controller.html` (or the appropriate hostname/IP) in your web browser.

## Usage

1. **Access the Controller:**
   Open your browser and navigate to your Pi-hole controller URL (e.g., `https://pi.hole/controller.html`).

2. **Log In:**
   Enter your Pi-hole URL and the generated app password to log in. After logging in, you can bookmark the URL to avoid entering the password each time.

3. **Toggle Blocking:**

   - Click **Enable Blocking** to activate blocking.
   - Click **Disable Blocking** to turn it off. If you choose to disable temporarily, select a preset duration or enter a custom duration.

4. **Create Shortcuts:**
   After clicking an action, copy the URL from your browser to bookmark it as a shortcut for that specific action.

## Customization

For family-friendly setups or specialized use cases, you can customize the controller interface using URL parameters:

### Parameters

- **title=Custom+Title**: Sets a custom title for the page (default is "Pi-hole Controller")
- **showButtons=false**: Hides the main Enable/Disable blocking buttons
- **showPresets=false**: Hides all preset buttons and the custom duration option
- **showTips=false**: Hides tips throughout the interface (like password generation instructions and bookmark hints)
- **showFooter=false**: Hides the footer with version info and admin links
- **presets=item1,item2,...**: Define custom preset durations (won't be shown if `showPresets` is set to `false`)

### Custom Presets Format

Custom presets use the format `Label:Value` separated by commas:

- `Label` is the text shown on the button (use '+' for spaces)
- `Value` is the duration in seconds, or append `m` for minutes, or use `custom`

Examples:

- `presets=Quick:30,5+Minutes:300,Hour:3600`
- `presets=Quick:30,Lunch:45m,Custom:custom`

### Example URL

Simple URL with minimal interface for family use (fill-in `your-password`):

```bash
https://pi.hole/controller.html?url=https://pi.hole&pwd=your-password&title=Internet+Controls&showButtons=false&showTips=false&showFooter=false&presets=10+seconds:10,30+seconds:30,1+minute:1m
```

![Screenshot of Customized Pi-hole Controller](images/customized.png)
