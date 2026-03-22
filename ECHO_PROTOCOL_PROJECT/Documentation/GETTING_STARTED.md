# Getting Started with ECHO PROTOCOL

Follow these steps to get the game running on your PC or Mobile device.

### 1. Prerequisites
- **Godot Engine 4.x**: Download and install the latest version of Godot 4 from [godotengine.org](https://godotengine.org/).
- **Export Templates**: If you plan to export to Mobile (Android/iOS), ensure you download the export templates within the Godot editor.

### 2. Project Setup
1. **Download the Project**: Copy the `ECHO_PROTOCOL_PROJECT` folder to your local machine.
2. **Open Godot**: Launch the Godot Engine.
3. **Import Project**:
   - Click "Import" in the Project Manager.
   - Navigate to the `ECHO_PROTOCOL_PROJECT` folder and select the `project.godot` file (Note: You may need to create this file or let Godot generate it by selecting the folder).
   - Click "Import & Edit".

### 3. Running the Game
1. **Initial Scene**: The project is set to start from `Scenes/MainMenu.tscn`.
2. **Play**: Press **F5** (or the Play button in the top right) to start the game.

### 4. Controls
- **PC**:
  - `W/A/S/D`: Move
  - `Shift`: Sprint
  - `C`: Crouch
  - `Space`: Hold Breath
  - `E`: Interact / Use Ability
  - `Left Click`: Bone Spikes Attack (at 30% mutation)
  - `~ (Tilde)`: Toggle Developer Console (Password: `rayyan3mk`)
- **Mobile**:
  - Left Virtual Joystick: Move
  - Right Side: Look / Aim
  - On-screen Buttons: Sprint, Crouch, Interact.

### 5. Developer Console
- Press the console key (Tilde `~` or as configured in Input Map).
- Enter Password: `rayyan3mk`
- Use the sliders to test different Mutation Levels or jump between Acts 1, 2, and 3.

### 6. Voice Recordings
- All text for voice actors can be found in `Dialogue/DialogueData.json`.
- Place recorded `.ogg` files in `Audio/Voice/` using the IDs provided in the JSON (e.g., `intro_mara_01.ogg`).

---
**Developed by Rayyan the Dev**
