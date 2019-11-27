class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.1.tar.gz"
  sha256 "df1d2ec1b4db9c89c216772f0998581a1cbb665e295ff9a418549360bb42f758"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    root_url("https://github.com/ElektraInitiative/homebrew-elektra/releases/" \
             "download/0.9.1")
    sha256 "3f1a181eac8cbfd066a5562a33731f7e7a29e15228c9294bb92113d38027e0ee" => :catalina
  end

  option "with-gitresolver", "Build with gitresolver plugin"
  option "with-qt", "Build GUI frontend"
  option "with-xerces", "Build with xerces plugin"

  # Build Dependencies
  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  depends_on "libgit2" if build.with? "gitresolver"
  depends_on "xerces-c" if build.with? "xerces"

  depends_on "augeas" => :optional
  depends_on "dbus" => :optional
  depends_on "lua" => :optional

  depends_on "swig" if build.with? "lua"
  depends_on "qt" => :optional

  depends_on "discount" if build.with? "qt"
  depends_on "yajl" => :optional

  def install
    bindings = ["cpp"]
    tools = ["kdb"]
    plugins = ["NODEP"]

    if build.with? "lua"
      bindings << "swig_lua"
      plugins << "lua"
    end

    plugins << "augeas" if build.with? "augeas"
    plugins << "dbus" << "dbusrecv" if build.with? "dbus"
    plugins << "gitresolver" if build.with? "gitresolver"
    plugins << "xerces" if build.with? "xerces"
    plugins << "yajl" if build.with? "yajl"

    tools << "qt-gui" if build.with? "qt"

    cmake_args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBINDINGS='#{bindings.join ";"}'
      -DTOOLS='#{tools.join ";"}'
      -DPLUGINS='#{plugins.join ";"}'
    ]

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end

    bash_completion.install "scripts/completion/kdb-bash-completion" => "kdb"
    fish_completion.install "scripts/completion/kdb.fish"
    zsh_completion.install "scripts/completion/kdb_zsh_completion" => "_kdb"
  end

  test do
    output = shell_output("#{bin}/kdb get system/elektra/version/infos/licence")
    assert_match "BSD", output
    Utils.popen_read("#{bin}/kdb", "list").split.each do |plugin|
      system "#{bin}/kdb", "check", plugin
    end
  end
end
