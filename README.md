# ds4_led_panel

## DS4 LED panel
Simple bash script with zenity interface and csv text as "database" to manage ds4 controller LED. <br />
Zenity is required for proper operation. <br />

## Idea
The PlayStation 4 controller has a LED that with Linux drivers can interactively change color, the problem is that these settings are temporary, and are lost every time the device is disconnected/connected. <br />
So if for example the controller light bothers you, you have to turn it off manually every time. <br />
This simple script manages the color of the LED in order to maintain the settings. <br />
The default color is set via a GUI with zenity, or you can choose to permanently turn off the LED (default color black). <br />
In addition, there are two modes: <br />

- Automatic battery LED mode <br />
  Changes the color of the LED dynamically based on the percentage of charge of the controller <br />
  
- Automatic application LED mode: <br />
  Changes the color of the LED dynamically based on some open applications. <br />
  The applications that trigger the change can be added, removed, or changed color by selecting "Manage automatic application LED settings" instead. <br />

## Usage
