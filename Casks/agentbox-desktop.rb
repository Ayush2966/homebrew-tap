# Written by the release workflow (desktop/publish-cask.sh). DO NOT EDIT.
cask "agentbox-desktop" do
  version "0.1.4"
  sha256 "8bd965791a15253e64a906694b7c22e54a17953f90a52db68c49e04e582e3447"

  url "https://github.com/Ayush2966/Agent-Box/releases/download/v#{version}/Agentbox-#{version}-macos-universal.zip"
  name "Agentbox"
  desc "Desktop window for the agentbox dashboard"
  homepage "https://github.com/Ayush2966/Agent-Box"

  livecheck do
    skip "Updated on release."
  end

  depends_on macos: :monterey

  app "Agentbox.app"

  # The app is not signed with a Developer ID, so the quarantine flag Homebrew
  # put on the download comes off the staged bundle before it moves to
  # /Applications; otherwise macOS refuses the first launch.
  preflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "Agentbox.app"], chdir: "."
  end

  zap trash: [
    "~/Library/Caches/dev.agentbox.desktop",
    "~/Library/Preferences/dev.agentbox.desktop.plist",
    "~/Library/Saved Application State/dev.agentbox.desktop.savedState",
    "~/Library/WebKit/dev.agentbox.desktop",
  ]

  caveats <<~EOS
    Agentbox.app is not notarized; the cask removed the quarantine flag so it
    opens without the Gatekeeper prompt. The app starts the agentbox daemon
    itself and shares ~/.agentbox with the agentbox CLI cask.
  EOS
end
