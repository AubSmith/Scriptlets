sudo apt update && sudo apt upgrade
# sudo apt install nodejs
# sudo apt install npm
wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh
bash install.sh
nvm -v
nvm list-remote
nvm install v18 # Specific version
nvm install node # Latest version
nvm ls 
nvm use 18
nvm alias default 18

node -v

sudo apt-get install git
cd /opt/
git clone https://github.com/juice-shop/juice-shop.git --depth 1
sudo chmod -R 777 /opt/juice-shop
cd juice-shop
npm install
npm start

# http://localhost:3000
