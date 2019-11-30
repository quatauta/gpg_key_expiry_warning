expand :clean, paths: ["pkg", "doc", ".yardoc", "tmp"]

expand :minitest, libs: ["lib", "test"]

expand :rspec, format: "Fuubar"

desc "rspec tests with xml output to tmp/rspec.xml"
expand :rspec, name: ["spec", "xml"], format: "RspecJunitFormatter", out: "tmp/rspec.xml"

expand :rubocop

expand :gem_build

expand :gem_build, name: "release", push_gem: true

expand :gem_build, name: "install", install_gem: true

tool "rubycritic" do
  desc "Run rubycritic"

  include :exec, result_callback: :handle_result
  include :terminal

  def handle_result(result)
    if result.success?
      puts("** #{result.name} passed\n\n", :green, :bold)
    else
      puts("** CI terminated: #{result.name} failed!", :red, :bold)
      exit(1)
    end
  end

  def run
    exec "rubycritic"
  end
end

tool "ci" do
  desc "Run all CI checks"

  long_desc "The CI tool runs all CI checks for the toys-core gem, including" \
            " unit tests, rubocop, and documentation checks. It is useful" \
            " for running tests in normal development, as well as being" \
            " the entrypoint for CI systems. Any failure will result in a" \
            " nonzero result code."

  include :exec, result_callback: :handle_result
  include :terminal

  def handle_result(result)
    if result.success?
      puts("** #{result.name} passed\n\n", :green, :bold)
    else
      puts("** CI terminated: #{result.name} failed!", :red, :bold)
      exit(1)
    end
  end

  def run
    exec_tool(["fasterer"], name: "fasterer")
    exec_tool(["standard", "fix"], name: "style checker auto-fix")
    exec_tool(["bundle", "audit"], name: "bundle audit")
    exec_tool(["bundle", "leak"], name: "bundle leak")
    exec_tool(["rubycritic"], name: "rubycritic")
    exec_tool(["spec"], name: "rspec tests")
    exec_tool(["spec", "xml"], name: "rspec tests with xml output to tmp/rspec.xml")
  end
end

expand :rake
