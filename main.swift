import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var textView: NSTextView!
    var currentURL: URL?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenu()
        setupWindow()
    }

    func setupWindow() {
        let rect = NSRect(x: 0, y: 0, width: 900, height: 600)
        window = NSWindow(contentRect: rect, styleMask: [.titled, .closable, .resizable, .miniaturizable], backing: .buffered, defer: false)
        window.title = "Notepad"

        let scrollView = NSScrollView(frame: window.contentView!.bounds)
        scrollView.hasVerticalScroller = true
        scrollView.autoresizingMask = [.width, .height]

        let contentSize = scrollView.contentSize
        textView = NSTextView(frame: NSRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        textView.isRichText = false
        textView.font = NSFont.userFixedPitchFont(ofSize: 13)

        scrollView.documentView = textView
        window.contentView!.addSubview(scrollView)
        window.center()
        window.makeKeyAndOrderFront(nil)
    }

    func setupMenu() {
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        let aboutItem = NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        appMenu.addItem(aboutItem)
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(NSMenuItem(title: "Quit Notepad", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        appMenuItem.submenu = appMenu

        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: "Edit")
        editMenuItem.submenu = editMenu
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")

        let fileMenuItem = NSMenuItem()
        mainMenu.addItem(fileMenuItem)
        let fileMenu = NSMenu(title: "File")
        fileMenuItem.submenu = fileMenu
        fileMenu.addItem(withTitle: "New", action: #selector(newFile), keyEquivalent: "n")
        fileMenu.addItem(withTitle: "Open…", action: #selector(openFile), keyEquivalent: "o")
        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(withTitle: "Save", action: #selector(saveFile), keyEquivalent: "s")
        fileMenu.addItem(withTitle: "Save As…", action: #selector(saveAsFile), keyEquivalent: "S")

        NSApp.mainMenu = mainMenu
    }

    @objc func newFile() {
        textView.string = ""
        currentURL = nil
        window.title = "Notepad"
    }

    @objc func openFile() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.begin { result in
            if result == .OK, let url = panel.url {
                do {
                    let str = try String(contentsOf: url, encoding: .utf8)
                    DispatchQueue.main.async {
                        self.textView.string = str
                        self.currentURL = url
                        self.window.title = url.lastPathComponent
                    }
                } catch {
                    self.showError("Failed to open file:\n\(error.localizedDescription)")
                }
            }
        }
    }

    @objc func saveFile() {
        if let url = currentURL { writeText(to: url) } else { saveAsFile() }
    }

    @objc func saveAsFile() {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.begin { result in if result == .OK, let url = panel.url { self.writeText(to: url) } }
    }

    func writeText(to url: URL) {
        let str = textView.string
        do {
            try str.write(to: url, atomically: true, encoding: .utf8)
            currentURL = url
            window.title = url.lastPathComponent
        } catch {
            showError("Failed to save file:\n\(error.localizedDescription)")
        }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = message
            alert.runModal()
        }
    }

    @objc func showAbout() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        let developer = "Safwan Safat"

        let full = NSMutableAttributedString()
        let textColor = NSColor.controlTextColor
        let verAttr = NSAttributedString(string: "Version: \(version) (build \(build))\n\n", attributes: [.font: NSFont.systemFont(ofSize: 12), .foregroundColor: textColor])
        full.append(verAttr)
        let devAttr = NSAttributedString(string: "Developed by \(developer)\n\n", attributes: [.font: NSFont.systemFont(ofSize: 12), .foregroundColor: textColor])
        full.append(devAttr)

        func link(_ text: String, _ url: String) -> NSAttributedString {
            let a = NSMutableAttributedString(string: text, attributes: [.font: NSFont.systemFont(ofSize: 12), .foregroundColor: textColor])
            a.addAttribute(.link, value: url, range: NSRange(location: 0, length: a.length))
            return a
        }

        full.append(link("GitHub", "https://github.com/sfwnsft"))
        full.append(NSAttributedString(string: "  "))
        full.append(link("LinkedIn", "https://www.linkedin.com/in/sfwnsft"))
        full.append(NSAttributedString(string: "  "))
        full.append(link("Email", "mailto:safwansafatswe@gmail.com"))

        let tv = NSTextView(frame: NSRect(x: 0, y: 0, width: 420, height: 140))
        tv.textStorage?.setAttributedString(full)
        tv.isEditable = false
        tv.drawsBackground = false
        tv.isSelectable = true
        tv.insertionPointColor = textColor
        tv.linkTextAttributes = [.foregroundColor: textColor, .underlineStyle: NSUnderlineStyle.single.rawValue]

        let scroll = NSScrollView(frame: tv.frame)
        scroll.borderType = .noBorder
        scroll.hasVerticalScroller = false
        scroll.documentView = tv

        let effect = NSVisualEffectView(frame: scroll.frame)
        if #available(macOS 10.14, *) { effect.material = .underWindowBackground } else { effect.material = .sidebar }
        effect.blendingMode = .withinWindow
        effect.state = .active
        effect.wantsLayer = true
        effect.layer?.cornerRadius = 10
        scroll.frame = effect.bounds
        scroll.autoresizingMask = [.width, .height]
        effect.addSubview(scroll)

        let alert = NSAlert()
        alert.messageText = "Notepad"
        alert.accessoryView = effect
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
