# install required packages
# sudo apt install -y git
sudo apt install screen -y
sudo apt install -y ffmpeg
sudo apt install -y net-tools
sudo apt install python3-pip -y
pip install setuptools==58.2.0
pip install RPi.GPIO
sudo apt install python3-colcon-common-extensions


echo "=================================="

echo "installing mediamtx"
echo "=================================="

# Install mediamtx
wget https://github.com/bluenviron/mediamtx/releases/download/v1.6.0/mediamtx_v1.6.0_linux_arm64v8.tar.gz
rm -rf mediamtx.yml
tar -xvf mediamtx_v1.6.0_linux_arm64v8.tar.gz
sudo mv mediamtx /usr/local/bin/
sudo mv mediamtxx.yml /usr/local/etc/mediamtx.yml
rm -rf mediamtx_v1.6.0_linux_arm64v8.tar.gz


sudo tee /etc/systemd/system/mediamtx.service >/dev/null << EOF
[Unit]
Wants=network.target
[Service]
ExecStart=/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yml
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable mediamtx
sudo systemctl start mediamtx

echo "=================================="

echo "installing ros2 dependencies"
echo "=================================="
# install ros2
locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo apt install software-properties-common -y
sudo add-apt-repository universe -y
sudo apt update -y
sudo apt-get purge needrestart -y
sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update -y
sudo apt upgrade -y
sudo apt install ros-humble-ros-base -y

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc

echo "=================================="
echo "initining ros2 workspace and enabling rack service"
echo "=================================="

source /opt/ros/humble/setup.bash
mkdir ~/ros2_ws
git clone https://github.com/WKDev/bsn-middleware
mv bsn-middleware ~/ros2_ws/src
cd ~/ros2_ws
colcon build --symlink-install
source ~/ros2_ws/install/setup.bash

sudo mv ~/ros2_ws/src/rack.service /etc/systemd/system/rack.service
sudo systemctl daemon-reload
sudo systemctl enable rack
sudo systemctl start rack



echo "alias bld='cd ~/ros2_ws && colcon build --symlink-install && source ~/ros2_ws/install/setup.bash'" >> ~/.bashrc
echo "alias upros='source ~/ros2_ws/install/setup.bash'"
echo "alias eb='nano ~/.bashrc'" >> ~/.bashrc
echo "alias sb='source ~/.bashrc'" >> ~/.bashrc
echo "alias ms='cd ~/ros2_ws/src'" >> ~/.bashrc
echo "alias msc=\'code ~/ros2_ws/src\'" >> ~/.bashrc
echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
# echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc
echo "export ROS_DOMAIN_ID=0" >> ~/.bashrc


sudo systemctl status rack

echo "Installation complete. Please reboot the system."