#!/data/data/com.termux/files/usr/bin/bash

# Define lastest version of metasploit-framework (https://github.com/rapid7/metasploit-framework/releases)
target_version="6.0.4.1"

echo "Metasploit Framework require at least 500Mb in the disk to work"
echo "Please press ENTER to continue or CTRL + C to abort..."
read E_

echo "Installing..."

# Install dependencies
apt install autoconf -y
apt install bison -y
apt install clang -y
apt install coreutils -y
apt install curl -y
apt install tsu -y
apt install findutils -y
apt install git -y
apt install apr -y
apt install apr-util -y
apt install libffi-dev -y
apt install libgmp-dev -y
apt install libpcap-dev -y
apt install postgresql-dev -y
apt install readline-dev -y
apt install libsqlite-dev -y
apt install openssl-dev -y
apt install libtool -y
apt install libxml2-dev -y
apt install libxslt-dev -y
apt install ncurses-dev -y
apt install pkg-config -y
apt install postgresql-contrib -y
apt install wget -y
apt install make -y
apt install ruby-dev -y
apt install libgrpc-dev -y
apt install ncurses-utils -y
apt install termux-tools -y

cd $HOME
curl -LO https://github.com/rapid7/metasploit-framework/archive/$targetversion.tar.gz
tar -xf $HOME/$targetversion.tar.gz

mv $HOME/metasploit-framework-$targetversion $HOME/metasploit-framework
cd $HOME/metasploit-framework

sed '/rbnacl/d' -i Gemfile.lock
sed '/rbnacl/d' -i metasploit-framework.gemspec

gem install bundler
bundle config build.nokogiri --use-system-libraries
gem install nokogiri -- --use-system-libraries

sed 's|grpc (.*|grpc (1.4.1)|g' -i $HOME/metasploit-framework/Gemfile.lock

gem unpack grpc -v 1.4.1

cd grpc-1.4.1
curl -LO https://raw.githubusercontent.com/grpc/grpc/v1.4.1/grpc.gemspec
curl -L https://wiki.termux.com/images/b/bf/Grpc_extconf.patch -o extconf.patch

patch -p1 < extconf.patch

gem build grpc.gemspec
gem install grpc-1.4.1.gem

cd ..
rm -r grpc-1.4.1

cd $HOME/metasploit-framework
bundle install -j5

$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;
rm ./modules/auxiliary/gather/http_pdf_authors.rb
ln -s $HOME/metasploit-framework/msfconsole /data/data/com.termux/files/usr/bin/

echo "Metasploit-framework has sucessfully installed!"
echo "To run: msfconsole"
