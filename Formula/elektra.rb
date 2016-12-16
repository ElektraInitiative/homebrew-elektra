class Elektra < Formula
  desc "Configuration Framework"
  homepage "https://web.libelektra.org"
  url "http://www.libelektra.org/ftp/elektra/releases/elektra-0.8.19.tar.gz"
  sha256 "cc14f09539aa95623e884f28e8be7bd67c37550d25e08288108a54fd294fd2a8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    root_url("https://github.com/ElektraInitiative/homebrew-elektra/releases/" \
             "download/0.8.19")
    sierra = "60d17548afd2e055dc4b884ab12c4efdef3406ce43037ea942c83187a219fb45"
    sha256(sierra => :sierra)
  end

  env :userpaths

  # Build Dependencies
  depends_on "cmake" => :build
  depends_on "discount" => [:build, "with-fenced-code"]
  depends_on "doxygen" => [:build, "with-graphviz", "with-llvm"]
  ronn = LanguageModuleRequirement.new :ruby, "ronn"
  ronn.tags << :build
  depends_on ronn

  def install
    cmake_args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_PREFIX_PATH=/usr/local/opt/qt5
      -DBINDINGS=ALL
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
