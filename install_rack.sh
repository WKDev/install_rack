# install required packages
# sudo apt install -y git
sudo apt install screen -y
screen -S install_rack
sudo apt install -y ffmpeg
sudo apt install -y net-tools
sudo apt install python3-pip -y
pip install setuptools==58.2.0
pip install RPi.GPIO

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

# install ros2
locale  # check for UTF-8

yes | sudo apt update && sudo apt install locales
yes | sudo locale-gen en_US en_US.UTF-8
yes | sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

yes | locale  # verify settings

yes | sudo apt install software-properties-common
yes | sudo add-apt-repository universe
yes | sudo apt update
yes |  sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
yes | sudo apt update -y
yes | sudo apt upgrade -y
yes | sudo apt install ros-humble-ros-base -y

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc

source /opt/ros/humble/setup.bash
source ~/.bashrc
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build --symlink-install
source ~/ros2_ws/install/setup.sh
echo "alias bld='cd ~/ros2_ws && colcon build --symlink-install && source ~/ros2_ws/install/setup.bash'" >> ~/.bashrc
echo "alias upros='source ~/ros2_ws/install/setup.sh'"
echo "alias eb='nano ~/.bashrc'" >> ~/.bashrc
echo "alias sb='source ~/.bashrc'" >> ~/.bashrc
echo "alias ms='cd ~/ros2_ws/src'" >> ~/.bashrc
echo "alias msc=\'code ~/ros2_ws/src\'" >> ~/.bashrc
echo "source ~/ros2_ws/install/setup.sh" >> ~/.bashrc
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
# echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc
echo "export ROS_DOMAIN_ID=0" >> ~/.bashrc

