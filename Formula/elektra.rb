class Elektra < Formula
  desc "Configuration Framework"
  homepage "https://web.libelektra.org"
  url "http://www.libelektra.org/ftp/elektra/releases/elektra-0.8.19.tar.gz"
  sha256 "cc14f09539aa95623e884f28e8be7bd67c37550d25e08288108a54fd294fd2a8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    root_url("https://github.com/ElektraInitiative/homebrew-elektra/releases/" \
             "download/0.8.19")
    sierra = "be74a6119140876af7ef5d99ce085fb8c7c1d0a07499cd40c52b61c42ef83d5c"
    sha256(sierra => :sierra)
  end

  env :userpaths

  # Build Dependencies
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  ronn = LanguageModuleRequirement.new :ruby, "ronn"
  ronn.tags << :build
  depends_on ronn

  # Run-Time Dependencies
  opt = [[:optional], proc {}, []]
  # rubocop:disable Style/ClassVars
  @@plugin_dependencies = {
    "augeas" => [Dependency.new("augeas", *opt)],
    "dbus" => [Dependency.new("dbus", *opt)],
    "gitresolver" => [Dependency.new("libgit2", *opt)],
    "tcl" => [Dependency.new("boost", *opt)],
    "yajl" => [Dependency.new("yajl", *opt)],
  }
  option "with-dep-plugins", \
         "Build with additional plugins: " \
         "#{@@plugin_dependencies.keys.join ", "}"
  @@plugin_dependencies.values.flatten.each do |dependency|
    depends_on dependency
  end

  depends_on "lua" => :optional
  if build.with? "lua"
    depends_on "swig"
  end

  depends_on Dependency.new("qt5", [:optional], proc {}, ["gui"])
  if build.with? "gui"
    depends_on "discount" => ["with-fenced-code", "with-shared"]
  end

  def install
    cmake_args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]
    bindings = ["cpp"]
    tools = ["kdb", "gen"]
    plugins = ["NODEP;-fcrypt"]

    if build.with? "optional-plugins"
      plugins + @@plugin_dependencies.keys
    end

    if build.with? "lua"
      bindings << "swig_lua"
      plugins << "lua"
    end

    if build.with? "gui"
      tools << "qt-gui"
      cmake_args << "-DCMAKE_PREFIX_PATH=/usr/local/opt/qt5"
    end

    cmake_args += %W[
      -DBINDINGS='#{bindings.join ";"}'
      -DTOOLS='#{tools.join ";"}'
      -DPLUGINS='#{plugins.join ";"}'
    ]

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end

    bash_completion.install "scripts/kdb-bash-completion" => "kdb"
    zsh_completion.install "scripts/kdb_zsh_completion" => "_kdb"
  end

  test do
    kdb = "#{bin}/kdb"
    system kdb, "ls", "/"
    system kdb, "list"
    `#{kdb} list`.split.each { |plugin| system kdb, "check", plugin }
  end
end
