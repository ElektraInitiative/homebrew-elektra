class Elektra < Formula
  desc "Configuration Framework"
  homepage "https://web.libelektra.org"
  url "http://www.libelektra.org/ftp/elektra/releases/elektra-0.8.19.tar.gz"
  sha256 "cc14f09539aa95623e884f28e8be7bd67c37550d25e08288108a54fd294fd2a8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    root_url("https://github.com/ElektraInitiative/homebrew-elektra/releases/" \
             "download/0.8.19")
    sierra = "f55334d35230b1c693cb42f049f19ed27a78d52d8ffdbee0ec01c934b8f2c7a7"
    sha256(sierra => :sierra)
  end

  env :userpaths

  depends_on "cmake" => :build
  ronn = LanguageModuleRequirement.new :ruby, "ronn"
  ronn.tags << :build
  depends_on ronn

  def install
    cmake_args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_PREFIX_PATH=/usr/local/opt/qt5
      -DTOOLS=ALL
    ]

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    kdb = "#{bin}/kdb"
    system kdb, "ls", "/"
    system kdb, "list"
    `#{kdb} list`.split.each { |plugin| system kdb, "check", plugin }
  end
end
