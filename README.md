# ds4_led_panel

<p align="center">
  <img height="400" width="400" src="https://github.com/user-attachments/assets/9efed300-21ca-430f-80c6-d211c7a2535d">
</p>

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
  For example, if you want to set the light to blue when you launch the PS2 emulator (PCSX2) and the light to red when you launch the PSX emulator (PCSXR), you just need to add both applications to the list and select their color. <br />

Only one of these two modes can be running at a time. <br />
If both are set to ON, they will both be disabled by the program. <br />

## Install
To launch the script in the background and make it work, some services need to be created:  <br />

    cd /etc/systemd/system/

  1) Default LED monitor mode:

          sudo vim patan-ds4_default.service
        
      <br />
      Paste this inside and save (Be sure to replace YOURUSERNAME with your actual username.): <br />
  
          Description=
          After=multi-user.target
          
          [Service]
          ExecStart=/home/YOURUSERNAME/code/Bash/ds4.sh -d
          
          [Install]
          WantedBy=multi-user.target
  
      <br />
    
          sudo systemctl patan-ds4_default.service
     
      <br />
      
  3) Battery LED monitor mode:

          sudo vim patan-ds4_battery.service
            
        <br />
          Paste this inside and save (Be sure to replace YOURUSERNAME with your actual username.): <br />
      
          Description=
          After=multi-user.target
          
          [Service]
          ExecStart=/home/YOURUSERNAME/code/Bash/ds4.sh -b
          
          [Install]
          WantedBy=multi-user.target
      
      
        <br />
        
          sudo systemctl patan-ds4_battery.service

        <br />
         
  
  5) Applications LED monitor mode:

          sudo vim patan-ds4_launch.service
            
        <br />
          Paste this inside and save (Be sure to replace YOURUSERNAME with your actual username.): <br />
      
          Description=
          After=multi-user.target
          
          [Service]
          ExecStart=/home/YOURUSERNAME/code/Bash/ds4.sh -l
          
          [Install]
          WantedBy=multi-user.target
      
      
        <br />
        
          sudo systemctl patan-ds4_launch.service
  
        <br />
  
## Usage
To launch the GUI you can run the script with -g argument. <br />

<div class="row" >
<img height="200" width="200" alt="Selenium" src="https://github.com/user-attachments/assets/862858ec-2b92-487e-92dc-f00287182d68">
<img height="200" width="200" alt="Telegram" src="https://github.com/user-attachments/assets/957e00c3-b2d7-4b83-9c6c-26ddb9d04d62">
<img height="200" width="400" alt="Python" src="https://github.com/user-attachments/assets/f5287304-fc3c-4845-9ede-4ba15ec015d9">
</div>
