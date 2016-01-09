# make sure only root can run this script
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

$ORIGINAL_DIRECTORY = $PWD

# Add the ros repo to the packages list
echo "deb http://packages.ros.org/ros/ubuntu wheezy main" > /etc/apt/sources.list.d/ros-latest-list

# get the ros key securely from github
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key
# add the key to apt
apt-key add ros.key

# Enable backports repository
echo "deb http://http.debian.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list

# make sure package index is up to date
apt-get update
apt-get upgrade -y

apt-get remove libogre-1.7.*

apt-get install checkinstall -y
apt-get install cmake -y
apt-get install libboost-system-dev -y
apt-get install libboost-thread-dev -y
apt-get install libboost-test-dev -y
apt-get install libtinyxml-dev -y
apt-get install libboost-filesystem-dev libxml2-dev -y
apt-get install libogre-1.8-dev

# install setup tools
apt-get install python-setuptools
easy_install pip
pip install -U rosdep rosinstall_generator wstool rosinstall

# make catkin workspace
mkdir $1/ros_catkin_ws
cd $1/ros_catkin_ws

# Install ROS-comm
rosinstall_generator ros_comm --rosdistro indigo --deps --wet-only --exclude roslisp --tar > indigo-ros_comm-wet.rosinstall
wstool init -j8 src indigo-ros_comm-wet.rosinstall
rosinstall_generator robot --rosdistro indigo --deps --wet-only --tar > indigo-robot-wet.rosinstall
rosinstall_generator desktop --rosdistro indigo --deps --wet-only --tar > indigo-robot-wet.rosinstall

# install console_bridge
mkdir #1/ros_catkin_ws/external_src
cd #1/ros_catkin_ws/external_src
git clone https://github.com/ros/console_bridge.git
cd console_bridge
cmake .

echo "the name (2) needs to change from 'console-bridge' to 'libconsole-bridge-dev'"
read
checkinstall make install

# install console_bridge
cd #1/ros_catkin_ws/external_src
git clone https://github.com/ros/urfdom_headers.git
cd urdfdom_headers
cmake .

echo "the name (2) needs to change from 'urdfdom-headers' to 'liburdfdom-headers-dev'"
read
checkinstall make install

cd #1/ros_catkin_ws/external_src
git clone https://github.com/ros/urdfdom.git
cd urdfdom
cmake .

echo "the name (2) needs to change from 'urdfdom' to 'liburdfdom-dev'
read
checkinstall make install

cd #1/ros_catkin_ws/external_src
wget http://downloads.sourceforge.net/project/collada-dom/Collada%20DOM/Collada%20DOM%202.4/collada-dom-2.4.0..tgz
tar -xzf collada-dom-2.4.0.tgz
cd collada-dom-2.4.0
cmake .

echo "the name (2) needs to change from \"collada-dom\" to \"collada-dom-dev\""
read
checkinstall make install

cd #1/ros_catkin_ws/external_src
git clone https://github.com/Itseez/opencv.git
mkdir opencv/release
cd opencv/release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
make

echo "the name (2) needs to change from \"release\" to \"libopencv-dev\""
read
checkinstall make install

# Cleanup
cd $ORIGINAL_DIRECTORY
