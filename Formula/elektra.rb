class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.0.tar.gz"
  sha256 "fcdbd1a148af91e2933d9a797def17d386a17006f629d5146020fe3b1b51ddd8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    root_url("https://github.com/ElektraInitiative/homebrew-elektra/releases/" \
             "download/0.9.0")
    sha256 "7417802277e452b69e7cdc28a7ee89bff9831f31bf363b77fe37967967098c08" => :mojave
  end

  option "with-qt", "Build GUI frontend"

  # rubocop: disable Style/ClassVars
  opt = [[:optional], proc {}, []]
  @@plugin_dependencies = {
    "augeas"      => [Dependency.new("augeas", *opt)],
    "dbus"        => [Dependency.new("dbus", *opt)],
    "gitresolver" => [Dependency.new("libgit2", *opt)],
    "tcl"         => [Dependency.new("boost", *opt)],
    "yajl"        => [Dependency.new("yajl", *opt)],
    "yamlcpp"     => [Dependency.new("yaml-cpp", *opt)],
  }
  # rubocop: enable Style/ClassVars
  option "with-dep-plugins", \
         "Build with additional plugins: " \
         "#{@@plugin_dependencies.keys.join ", "}"

  # Build Dependencies
  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  # Run-Time Dependencies
  @@plugin_dependencies.values.flatten.each do |dependency|
    depends_on dependency
  end

  depends_on "lua" => :optional
  depends_on "swig" if build.with? "lua"
  depends_on "qt" => :optional
  depends_on "discount" if build.with? "qt"

  def install
    bindings = ["cpp"]
    tools = ["kdb"]
    plugins = ["NODEP"]

    plugins += @@plugin_dependencies.keys if build.with? "dep-plugins"

    if build.with? "lua"
      bindings << "swig_lua"
      plugins << "lua"
    end

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

    bash_completion.install "scripts/kdb-bash-completion" => "kdb"
    fish_completion.install "scripts/kdb.fish"
    zsh_completion.install "scripts/kdb_zsh_completion" => "_kdb"
  end

  test do
    output = shell_output("#{bin}/kdb get system/elektra/version/infos/licence")
    assert_match "BSD", output
    Utils.popen_read("#{bin}/kdb", "list").split.each do |plugin|
      system "#{bin}/kdb", "check", plugin
    end
  end
end
