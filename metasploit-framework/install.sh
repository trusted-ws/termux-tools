#!/data/data/com.termux/files/usr/bin/bash

# Define lastest version of metasploit-framework (https://github.com/rapid7/metasploit-framework/releases)
target_version="6.0.4.1"

echo "Metasploit Framework require at least 500Mb in the disk to work"
echo "Please press ENTER to continue or CTRL + C to abort..."
read E_

echo "Installing..."

# Install dependencies
apt install autoconf bison clang coreutils curl tsu findutils git apr apr-util libffi-dev libgmp-dev libpcap-dev postgresql-dev readline-dev libsqlite-dev openssl-dev libtool libxml2-dev libxslt-dev ncurses-dev pkg-config postgresql-contrib wget make ruby-dev libgrpc-dev ncurses-utils termux-tools -y

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
